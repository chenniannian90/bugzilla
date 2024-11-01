package wan;
use strict;
use warnings FATAL => 'all';

use Data::Dumper;
use String::Util 'trim';


while (my ($key, $value) = each %ENV) {
    if ($key eq "PATH"){
        $value .= ':' . '$PATH';
    }
    $value = trim($value);
    warn  "export $key=$value";
}

# awk  '/export/ {print $7,$8}' /var/log/apache2/error.log
# tail -f /var/log/apache2/error.log | awk  '/export/ {print $7,$8}'

warn Dumper(\%ENV);

while (my $line = <STDIN>) {
    warn $line;
}
1;


awk