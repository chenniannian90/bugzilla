#!bin/python

import time


def handle_line(line):
    line = line.strip()
    if all(['export' in line, 'at' in line]):
        start = line.index('export')
        end = line.rindex('at')
        if 0 < start < end:
            print(line[start:end])


def tail_f(filename):
    with open(filename, 'r') as f:
        # 移动到文件末尾
        f.seek(0, 2)  # 2表示从文件末尾开始计算

        while True:
            line = f.readline()
            if not line:  # 如果没有新行，则等待
                time.sleep(0.5)  # 等待一段时间后再检查
                continue

            # 处理新读取的行
            handle_line(line)  # 输出新行，end='' 防止多余换行


if __name__ == "__main__":
    log_file = '/var/log/apache2/error.log'  # 替换为你的文件名
    tail_f(log_file)
