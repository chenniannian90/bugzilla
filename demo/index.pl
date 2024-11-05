#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Devel::REPL;


my $a = 10;
my $b = 20;
my $c = $a + $b;



my $repl = Devel::REPL->new;
$repl->load_plugin($_) for qw(History LexEnv);
$repl->run;

print "Sum: $c\n";

my $bug_params = {
    'assigned_to' => '1028630307@qq.com',
    'status_whiteboard' => undef,
    'blocked' => '',
    'comment' => '',
    'short_desc' => '101',
    'product' => 'TestProduct',
    'qa_contact' => undef,
    'priority' => '---',
    'bug_status' => 'CONFIRMED',
    'deadline' => '',
    'alias' => '',
    'target_milestone' => undef,
    'dependson' => '',
    'bug_file_loc' => 'http://',
    'op_sys' => 'Mac OS',
    'version' => 'unspecified',
    'estimated_time' => '',
    'component' => 'TestComponent',
    'keywords' => undef,
    'see_also' => '',
    'rep_platform' => 'PC',
    'bug_severity' => 'enhancement',
    'comment_is_private' => undef
};









my $start = 1;



# open my $log, '>>', '/opt/homebrew/var/log/httpd/cgi.log' or die "Can't open log file: $!";
# print $log  Dumper(\%ENV);
# close $log;

my $env = {
    'HTTP_SEC_CH_UA' => '"Chromium";v="130", "Google Chrome";v="130", "Not?A_Brand";v="99"',
    'HTTP_ORIGIN' => 'http://127.0.0.1:8090',
    'HTTP_SEC_CH_UA_PLATFORM' => '"macOS"',
    'HTTP_ACCEPT_LANGUAGE' => 'zh-CN,zh;q=0.9',
    'REQUEST_METHOD' => 'POST',
    'HTTP_SEC_FETCH_DEST' => 'document',
    'HTTP_REFERER' => 'http://127.0.0.1:8090/form.html',
    'CONTEXT_DOCUMENT_ROOT' => '/usr/local/var/www/cgi-bin/',
    'HTTP_SEC_FETCH_SITE' => 'same-origin',
    'SERVER_SIGNATURE' => '',
    'REMOTE_PORT' => '59954',
    'SERVER_ADDR' => '127.0.0.1',
    'DOCUMENT_ROOT' => '/opt/homebrew/var/www',
    'HTTP_HOST' => '127.0.0.1:8090',
    'HTTP_ACCEPT_ENCODING' => 'gzip, deflate, br',
    'HTTP_SEC_FETCH_USER' => '?1',
    'SERVER_NAME' => '127.0.0.1',
    'SERVER_ADMIN' => 'you@example.com',
    'HTTP_ACCEPT' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'HTTP_SEC_CH_UA_MOBILE' => '?0',
    'HTTP_SEC_FETCH_MODE' => 'navigate',
    'CONTEXT_PREFIX' => '/cgi-bin/',
    'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
    'HTTP_UPGRADE_INSECURE_REQUESTS' => '1',
    '__CF_USER_TEXT_ENCODING' => '0x1F5:0x19:0x34',
    'REQUEST_URI' => '/cgi-bin/post_handler.cgi',
    'SERVER_SOFTWARE' => 'Apache/2.4.62 (Unix)',
    'SCRIPT_NAME' => '/cgi-bin/post_handler.cgi',
    'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36',
    'QUERY_STRING' => '',
    'HTTP_CACHE_CONTROL' => 'max-age=0',
    'HTTP_POSTMAN_TOKEN' => 'd33539e6-2335-4c71-bfef-a47c7d67ebc7',
    'SCRIPT_FILENAME' => '/usr/local/var/www/cgi-bin/post_handler.cgi',
    'REQUEST_SCHEME' => 'http',
    'SERVER_PORT' => '8090',
    'CONTENT_LENGTH' => '33',
    'HTTP_CONNECTION' => 'keep-alive',
    'SERVER_PROTOCOL' => 'HTTP/1.1',
    'GATEWAY_INTERFACE' => 'CGI/1.1',
    'PATH' => '/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin',
    'REMOTE_ADDR' => '127.0.0.1'
};

while (my ($key, $value) = each %{$env}) {
        $ENV{$key} = $value;
}

$ENV{CONTENT_LENGTH} = "33";

# 将标准输入重定向到文件
open my $input_fh, '<', '/Users/mac-new/go/src/github.com/bugzilla/demo/std.in' or die "无法打开文件: $!";
local *STDIN = $input_fh;  # 将标准输入重定向到 $input_fh

# my $line = <STDIN>;  # 从 input.txt 读取一行
# print "读取的行: $line";

# close $input_fh;  # 关闭文件句柄



# 创建 CGI 对象
my $cgi = CGI->new;

# 设置 HTTP 头
print $cgi->header('text/html');

# 获取 POST 参数
my $name = $cgi->param('name');
my $email = $cgi->param('email');

# 处理参数并生成响应
print $cgi->start_html('POST Request Handler');
print $cgi->h1('Received POST Data');
print $cgi->p("Name: " . ($name // 'Not provided'));
print $cgi->p("Email: " . ($email // 'Not provided'));
print $cgi->end_html;



# curl --location 'http://127.0.0.1:8090/cgi-bin/post_handler.cgi' \
# --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
# --header 'Accept-Language: zh-CN,zh;q=0.9' \
# --header 'Cache-Control: max-age=0' \
# --header 'Connection: keep-alive' \
# --header 'Content-Type: application/x-www-form-urlencoded' \
# --header 'Origin: http://127.0.0.1:8090' \
# --header 'Referer: http://127.0.0.1:8090/form.html' \
# --header 'Sec-Fetch-Dest: document' \
# --header 'Sec-Fetch-Mode: navigate' \
# --header 'Sec-Fetch-Site: same-origin' \
# --header 'Sec-Fetch-User: ?1' \
# --header 'Upgrade-Insecure-Requests: 1' \
# --header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36' \
# --header 'sec-ch-ua: "Chromium";v="130", "Google Chrome";v="130", "Not?A_Brand";v="99"' \
# --header 'sec-ch-ua-mobile: ?0' \
# --header 'sec-ch-ua-platform: "macOS"' \
# --data-urlencode 'name=12' \
# --data-urlencode 'email=1028630307@qq.com'