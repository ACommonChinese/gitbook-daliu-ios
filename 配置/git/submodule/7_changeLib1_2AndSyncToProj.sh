#!/bin/zsh

echo "================================================"
echo "(2.6)在project2中修改lib1和lib2并同步到project2"
echo "================================================"

# 在lib1中添加一个文件：README，用来描述lib1的功能
# 在lib2中的lib2-features文件中添加一些文字
cd ~/submd/ws/project2/libs/lib1
echo "lib1 readme contents" > README
git add README
git commit -m "add file README"
git push

# submodule 更改之后还需要回到主项目更新主项目引用的submodule的commit-id
cd ~/submd/ws/project2
git status
# 位于分支 master
# 您的分支与上游分支 'origin/master' 一致。

# 尚未暂存以备提交的变更：
#   （使用 "git add <文件>..." 更新要提交的内容）
#   （使用 "git restore <文件>..." 丢弃工作区的改动）
#         修改：     libs/lib1 (新提交)
git add libs/lib1
git commit -m "update lib1 to lastest commit id"
# git push: 暂时不push到仓库，等待和lib2的修改一起push

cd libs/lib2
echo "学习Git submodule的修改并同步功能" >> lib2-features
git add lib2-features
git commit -m "添加文字：学习Git submodule的修改并同步功能"
git push

git status
# 位于分支 master
# 您的分支领先 'origin/master' 共 1 个提交。
#   （使用 "git push" 来发布您的本地提交）
# 尚未暂存以备提交的变更：
#   （使用 "git add <文件>..." 更新要提交的内容）
#   （使用 "git restore <文件>..." 丢弃工作区的改动）
#         修改：     libs/lib2 (新提交)

git add libs/lib2
git commit -m "update lib2 to lastest commit id"
git status
# 位于分支 master
# 您的分支领先 'origin/master' 共 2 个提交。
#   （使用 "git push" 来发布您的本地提交）
git push、

echo "================================================"
echo "   同步project2对lib1和lib2的修改到 project1"
echo "================================================"

cd ~/submd/ws/project1
git pull
# 已经是最新的。# 这说明什么都没有更新到
# 这是因为在project2中的lib1和lib2是master分支, 而当前project1不在任何一个分支上
cd ~/submd/ws/project1/libs/lib1
git checkout master
git pull
cd ~/submd/ws/project1/libs/lib2
git checkout master
git pull

# 更新了project1的lib1和lib2的最新版本，现在要把最新的commit id保存到project1中以保持最新的引用
git status
# 位于分支 master
# 您的分支与上游分支 'origin/master' 一致。

# 尚未暂存以备提交的变更：
#   （使用 "git add <文件>..." 更新要提交的内容）
#   （使用 "git restore <文件>..." 丢弃工作区的改动）
#         修改：     libs/lib1 (新提交)
#         修改：     libs/lib2 (新提交)

git diff
# diff --git a/libs/lib1 b/libs/lib1
# index aa6b494..a52b472 160000
# --- a/libs/lib1
# +++ b/libs/lib1
# @@ -1 +1 @@
# -Subproject commit aa6b4948404f9709fbd6d5ccf92b4f37c6f094b0
# +Subproject commit a52b47284cd1db50fdb7f9b8c602014935ff917d
# diff --git a/libs/lib2 b/libs/lib2
# index e64aba0..3ccd2dd 160000
# --- a/libs/lib2
# +++ b/libs/lib2
# @@ -1 +1 @@
# -Subproject commit e64aba0b18df5afb1aeb397fffea663826cdd197
# +Subproject commit 3ccd2ddab261ad164bee3bf2b61a930422e1b88d

cd ~/submd/ws/project1
git commit -a -m "update lib1 and lib2 commit id to new version"
git push