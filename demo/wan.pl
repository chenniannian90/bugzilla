package wan;
use strict;
use warnings FATAL => 'all';

use Data::Dumper;
use String::Util 'trim';


while (my ($key, $value) = each %hash) {
    $value = trim($value);
    warn  "export $key=$value";
}

# awk  '/export/ {print $7,$8,$9}' data

warn Dumper(\%ENV);

while (my $line = <STDIN>) {
    warn $line;
}
1;


awk