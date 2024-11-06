# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::Fork;

use 5.10.1;
use strict;
use warnings;
use Bugzilla::Bug;
use Bugzilla::Field;
use Data::Dumper;

use parent qw(Bugzilla::Extension);

# This code for this is in ../extensions/Fork/lib/Util.pm
use Bugzilla::Extension::Fork::Util;

our $VERSION = '0.01';


BEGIN {
    *Bugzilla::Bug::parent_bug_id = \&Bugzilla::Extension::Fork::_bug_parent_bug_id;
    *Bugzilla::Bug::parent_bug = \&Bugzilla::Extension::Fork::_bug_parent_bug;
    *Bugzilla::Bug::children_bug_ids = \&Bugzilla::Extension::Fork::_bug_children_bug_ids;
    *Bugzilla::Bug::children_bugs = \&Bugzilla::Extension::Fork::_bug_children_bugs;
}

# See the documentation of Bugzilla::Hook ("perldoc Bugzilla::Hook"
# in the bugzilla directory) for a list of all available hooks.

sub install_update_db {
    my $field = new Bugzilla::Field({ name => 'parent_bug_id' });
    if  (! defined $field || !$field ) {
        $field = Bugzilla::Field->create({
            name        => 'parent_bug_id',
            description => 'ParentBugID',
            # custom      => 1,
            # enter_bug   => 1,         # 在创建 Bug 时可见
            # buglist     => 1,         # 在 Bug 列表中可见
        });
    }

    $field = new Bugzilla::Field({ name => 'children_bug_ids' });
    if  (! defined $field || !$field ) {
        $field = Bugzilla::Field->create({
            name        => 'children_bug_ids',
            description => 'ChildrenBugIDs',
            # custom      => 1,
            # enter_bug   => 0,         # 在创建 Bug 时可见
            # buglist     => 0,         # 在 Bug 列表中可见
        });
    }
}


sub db_schema_abstract_schema {
    my ($self, $args) = @_;
    $args->{'schema'}->{'bug_relation'} = {
        FIELDS => [
            parent_bug_id    => {TYPE => 'MEDIUMINT', NOTNULL => 1,
                REFERENCES => {
                    TABLE => 'bugs',
                    COLUMN => 'bug_id',
                    DELETE => 'CASCADE',
                } },
            bug_id      => {TYPE => 'MEDIUMINT', NOTNULL => 1,
                REFERENCES => {
                    TABLE => 'bugs',
                    COLUMN => 'bug_id',
                    DELETE => 'CASCADE',
                },
            }
        ],
        INDEXES => [
            bug_relation_parent_bug_id_idx => {FIELDS => ['parent_bug_id', 'bug_id'], TYPE=>'UNIQUE'},
            bug_relation_bug_id_idx => ['bug_id'],
        ]
    };
}


sub bug_fields {
    my ($self, $args) = @_;
    my $fields = $args->{'fields'};
    push (@$fields, "parent_bug_id");
    push (@$fields, "children_bug_ids");
}



sub _bug_parent_bug_id {
    my ($self) = @_;
    return $self->{'parent_bug_id'} if exists $self->{'parent_bug_id'};
    return 0 if $self->{'error'};

    my $dbh = Bugzilla->dbh;
    my $rows = $dbh->selectcol_arrayref(
        q{SELECT parent_bug_id FROM bug_relation
           WHERE bug_id = ? },
        undef, $self->bug_id);
    if (defined $rows && @$rows){
        $self->{'parent_bug_id'} = $rows->[0]
    }else{
        $self->{'parent_bug_id'} = 0
    }
    return $self->{'parent_bug_id'};
}


sub _bug_children_bug_ids {
    my ($self) = @_;
    return $self->{'children_bug_ids'} if exists $self->{'children_bug_ids'};
    return [] if $self->{'error'};

    my $dbh = Bugzilla->dbh;
    $self->{'children_bug_ids'} = $dbh->selectcol_arrayref(
        q{SELECT bug_id FROM bug_relation where parent_bug_id = ? },
        undef, $self->bug_id);
    return $self->{'children_bug_ids'};
}


sub _bug_parent_bug {
    my $self = shift;
    return $self->{'parent_bug'} if exists $self->{'parent_bug'};
    return undef if $self->{'error'};

    $self->{'parent_bug'} = undef;
    my $parent_bug_id = $self->{'parent_bug_id'};
    if (defined $parent_bug_id && $parent_bug_id) {
        $self->{'parent_bug'} = new Bugzilla::Bug($parent_bug_id);
    }
    return $self->{'parent_bug'}
}


sub _bug_children_bugs {
    my $self = shift;
    return $self->{'children_bugs'} if exists $self->{'children_bugs'};
    return [] if $self->{'error'};

    $self->{'children_bugs'} = [];
    my $children_bug_id = $self->{'children_bug_ids'};
    if (defined $children_bug_id && $children_bug_id) {
        $self->{'children_bugs'} = Bugzilla::Bug->new_from_list($children_bug_id);
    }
    return $self->{'children_bugs'}
}

sub bug_end_of_create_validators{
    my ($self, $args) = @_;
    # This code doesn't actually *do* anything, it's just here to show you
    # how to use this hook.
    my $bug_params = $args->{'params'};
    # my $arb_value = $bug->ct_arb;
    # if (!defined $arb_value || $arb_value eq '') {
    #     Bugzilla::Error::IllegalParam->throw("The 'ARB' field cannot be empty.");
    # }
    # todo check parent_bug_id if exist
    my $parent_bug_id = $bug_params->{parent_bug_id};
    if (defined $parent_bug_id && $parent_bug_id){
        # todo ok?
        Bugzilla::Bug->check($parent_bug_id);
    }
    warn Dumper($bug_params);
}

sub bug_end_of_create {
    my ($self, $args) = @_;
    # This code doesn't actually *do* anything, it's just here to show you
    # how to use this hook.
    my $bug = $args->{'bug'};
    my $timestamp = $args->{'timestamp'};
    warn Dumper($args);
}

# sub bug_end_of_update {
#
# }


__PACKAGE__->NAME;
