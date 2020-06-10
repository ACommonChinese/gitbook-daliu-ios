#!/bin/zsh

echo "==========================================="
echo "     为project2添加submodule lib1和lib2"
echo "==========================================="

cd ~/submd/ws/project2

cd ~/submd/ws/project2
git submodule add ~/submd/repos/lib1.git libs/lib1
# 正克隆到 '/Users/liuweizhen/submd/ws/project2/libs/lib1'...
# 完成。
git submodule add ~/submd/repos/lib2.git libs/lib2
# 正克隆到 '/Users/liuweizhen/submd/ws/project2/libs/lib2'...
# 完成。
git status
# 位于分支 master
# 您的分支与上游分支 'origin/master' 一致。

# 要提交的变更：
#   （使用 "git restore --staged <文件>..." 以取消暂存）
#         新文件：   .gitmodules
#         新文件：   libs/lib1
#         新文件：   libs/lib2
git commit -a -m "add lib1 and lib2"
# [master b1daf4d] add lib1 and lib2
#  3 files changed, 8 insertions(+)
#  create mode 100644 .gitmodules
#  create mode 160000 libs/lib1
#  create mode 160000 libs/lib2
git push
# 枚举对象: 5, 完成.
# 对象计数中: 100% (5/5), 完成.
# 使用 4 个线程进行压缩
# 压缩对象中: 100% (4/4), 完成.
# 写入对象中: 100% (4/4), 467 字节 | 467.00 KiB/s, 完成.
# 总共 4 （差异 0），复用 0 （差异 0）
# To /Users/liuweizhen/submd/ws/../repos/project2.git
#    40b4a47..b1daf4d  master -> master
