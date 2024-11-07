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
    *Bugzilla::Bug::fork_bug_id = \&Bugzilla::Extension::Fork::_bug_fork_bug_id;
    *Bugzilla::Bug::fork_bug = \&Bugzilla::Extension::Fork::_bug_fork_bug;
}

# See the documentation of Bugzilla::Hook ("perldoc Bugzilla::Hook"
# in the bugzilla directory) for a list of all available hooks.

sub install_update_db {
    my $field = new Bugzilla::Field({ name => 'fork_bug_id' });
    if  (! defined $field || !$field ) {
        $field = Bugzilla::Field->create({
            name        => 'fork_bug_id',
            description => 'ForkBugID',
            # custom      => 1,
            # enter_bug   => 1,         # 在创建 Bug 时可见
            # buglist     => 1,         # 在 Bug 列表中可见
        });
    }
}


sub db_schema_abstract_schema {
    my ($self, $args) = @_;
    $args->{'schema'}->{'fork_relation'} = {
        FIELDS => [
            fork_bug_id    => {TYPE => 'MEDIUMINT', NOTNULL => 1,
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
            fork_relation_fork_bug_id_idx => {FIELDS => ['fork_bug_id', 'bug_id'], TYPE=>'UNIQUE'},
            fork_relation_bug_id_idx => ['bug_id'],
        ]
    };
}


sub bug_fields {
    my ($self, $args) = @_;
    my $fields = $args->{'fields'};
    push (@$fields, "fork_bug_id");
}



sub _bug_fork_bug_id {
    my ($self) = @_;
    return $self->{'fork_bug_id'} if exists $self->{'fork_bug_id'};
    return 0 if $self->{'error'};

    my $dbh = Bugzilla->dbh;
    my $rows = $dbh->selectcol_arrayref(
        q{SELECT fork_bug_id FROM fork_relation
           WHERE bug_id = ? },
        undef, $self->bug_id);
    if (defined $rows && @$rows){
        $self->{'fork_bug_id'} = $rows->[0]
    }else{
        $self->{'fork_bug_id'} = 0
    }
    return $self->{'fork_bug_id'};
}




sub _bug_fork_bug {
    my $self = shift;
    return $self->{'fork_bug'} if exists $self->{'fork_bug'};
    return undef if $self->{'error'};

    $self->{'fork_bug'} = undef;
    my $fork_bug_id = $self->{'fork_bug_id'};
    if (defined $fork_bug_id && $fork_bug_id) {
        $self->{'fork_bug'} = new Bugzilla::Bug($fork_bug_id);
    }
    return $self->{'fork_bug'}
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
    # todo check fork_bug_id if exist
    my $fork_bug_id = $bug_params->{fork_bug_id};
    if (defined $fork_bug_id && $fork_bug_id){
        Bugzilla::Bug->check($fork_bug_id);
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