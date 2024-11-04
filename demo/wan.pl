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
    warn  "export $key=\"$value\"";
}

# cpanm -v Compress::Zstd

#  awk -F 'at' '{print $1}' | awk -F 'export' '{print $2}'

# awk  -F 'at' '/export/ {print $1}' /var/log/apache2/error.log | awk -F 'export' '{print "export" $2}'
# tail -f /var/log/apache2/error.log | awk -F 'at' '/export/ {print $1}' | awk -F 'export' '{print "export" $2}'

warn Dumper(\%ENV);

# while (my $line = <STDIN>) {
#     warn $line;
# }
1;

