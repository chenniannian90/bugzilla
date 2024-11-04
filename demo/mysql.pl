package mysql;
use strict;
use warnings FATAL => 'all';


use DBI;
use Data::Dumper;


# 将标准输入重定向到文件
open my $input_fh, '<', 'input.txt' or die "无法打开文件: $!";
local *STDIN = $input_fh;  # 将标准输入重定向到 $input_fh

my $line = <STDIN>;  # 从 input.txt 读取一行
print "读取的行: $line";

close $input_fh;  # 关闭文件句柄




my $dbh = DBI->connect("DBI:mysql:bugs:39.105.54.64:3307", 'bugs', '#PassW0rdDL');
my $sth = $dbh->prepare("SELECT * FROM bugs");
$sth->execute();

while ( my @row = $sth->fetchrow_array() )
{

    print Dumper(\@row);
}

$sth->finish();
$dbh->disconnect();

1;