#!/bin/zsh

source ./common.sh

doubleSeparateLine
echo "为project1添加lib1和lib2"
doubleSeparateLine

cd ~/submd/ws/project1
echo "为project1添加submodule lib1"
git submodule add ~/submd/repos/lib1.git libs/lib1

separateLine

echo "为project1添加submodule lib2"
git submodule add ~/submd/repos/lib2.git libs/lib2
git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#   new file:   .gitmodules
#   new file:   libs/lib1
#   new file:   libs/lib2
#

separateLine

echo "查看.gitmodules"
cat .gitmodules
# .gitmodules记录了每个submodule的引用信息，在当前项目的位置(path)以及仓库的位置(url)
# [submodule "libs/lib1"]
#         path = libs/lib1
#         url = /Users/liuweizhen/submd/repos/lib1.git
# [submodule "libs/lib2"]
#         path = libs/lib2
#         url = /Users/liuweizhen/submd/repos/lib2.git
#
# 注：使用git submodule add xxx 会把submodule clone下来

separateLine

echo "git submodule add 会 clone 下来submodule的内容，因此需求提交到仓库"
echo "把 git submodule add ... 命令 clone 下来的内容提交到仓库 project1"
git commit -a -m "add submodules[lib1,lib2] to project1"
git push

separateLine

echo "git submodule add 做了以下事："
echo "1. 在 .gitmodules 和 .git/config 中 记录submodule相关信息"
echo "2. clone 下来 submodule 的内容"
