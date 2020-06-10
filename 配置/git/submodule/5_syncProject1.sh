#!/bin/zsh

source ./common.sh

doubleSeparateLine
echo "      更新主项目project1"
doubleSeparateLine

cd ~/submd/ws/project1
git pull
# remote: 枚举对象: 5, 完成.
# remote: 对象计数中: 100% (5/5), 完成.
# remote: 压缩对象中: 100% (3/3), 完成.
# remote: 总共 3 （差异 0），复用 0 （差异 0）
# 展开对象中: 100% (3/3), 完成.
# 来自 /Users/liuweizhen/submd/ws/../repos/project1
#    3c7dcfa..3868341  master     -> origin/master
# Fetching submodule libs/lib1
# 来自 /Users/liuweizhen/submd/repos/lib1
#    2796dbc..850b44c  master     -> origin/master
# 更新 3c7dcfa..3868341
# Fast-forward
#  libs/lib1 | 2 +-
#  1 file changed, 1 insertion(+), 1 deletion(-)

git status
# 位于分支 master
# 您的分支与上游分支 'origin/master' 一致。

# 尚未暂存以备提交的变更：
#   （使用 "git add <文件>..." 更新要提交的内容）
#   （使用 "git restore <文件>..." 丢弃工作区的改动）
# 	修改：     libs/lib1 (新提交)

# 可以看到，git pull 之后调用git status查看，竟然有东西被修改了需要提交，使用git diff查看一下：
git diff
# diff --git a/libs/lib1 b/libs/lib1
# index 850b44c..2796dbc 160000
# --- a/libs/lib1
# +++ b/libs/lib1
# @@ -1 +1 @@
# -Subproject commit 850b44c451e2dd0e8590e928ce09ff2a9a5fdb42
# +Subproject commit 2796dbc23b55a3b9170b6937f12010ab5d9bfc32

# 从diff的结果分析出来时因为submodule的commit id更改了, 即git pull会把主项目的内容pull下来，但是
# 对于submodule, 它记录了一个submodule的最新的commit id，需要我们手动更新submodule
# 前面讲了要在主项目(上面的project1-b)更新submodule的内容首先要提交submdoule的内容，
# 然后再更新主项目中引用的 submodule 的 commit id
# 现在我们看到的不同就是因为刚刚更改了project1-b的submodule commit-id

# 接下来调用命令更新 submodule
git submodule update

git status
# 位于分支 master
# 您的分支与上游分支 'origin/master' 一致。
# 无文件要提交，干净的工作区