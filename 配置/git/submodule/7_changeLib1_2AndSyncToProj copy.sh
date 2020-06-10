#!/bin/zsh

echo "=================================================="
echo "(2.6)在project2中修改lib1和lib2 并同步到 project2"
echo "=================================================="

# 在lib1中添加一个文件：README，用来描述lib1的功能
# 在lib2中的lib2-features文件中添加一些文字

echo "修改lib1并提交"
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

echo "修改lib2并提交"
cd libs/lib2
echo "学习Git submodule的修改并同步功能" >> lib2-features
git add lib2-features
git commit -m "添加文字：学习Git submodule的修改并同步功能"
git push

# submodule 更改之后还需要回到主项目更新主项目引用的submodule的commit-id
git add lib2-features
git commit -m "update lib2 to lastest commit id"
git status
git push


echo "=================================================="
echo "     同步project2的lib1和lib2的修改到project1"
echo "=================================================="
