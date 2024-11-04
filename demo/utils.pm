package utils;
use strict;
use warnings FATAL => 'all';

use String::Util 'trim';

my $string = "   Hello, World!   ";

$string = trim($string);


use CGI;   # load CGI routines
$q = CGI->new;                        # create new CGI object
print $q->header;                  # create the HTTP header
1;