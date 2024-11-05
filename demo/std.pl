#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';



# 指定输出文件名
my $filename = 'output.txt';

# 打开文件以写入
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

print "Please enter some text (Ctrl+D to end):\n";

# 逐行读取标准输入并写入文件
while (my $line = <STDIN>) {
    print $fh $line;  # 写入文件句柄
}

close($fh);  # 关闭文件句柄

print "Input has been written to '$filename'.\n";
