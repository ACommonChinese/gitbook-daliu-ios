#!/bin/zsh

source ./common.sh

doubleSeparateLine
echo "      为project1添加lib1和lib2"
doubleSeparateLine

cd ~/submd/ws/project1
git submodule add ~/submd/repos/lib1.git libs/lib1
# 调用上面这一句代码, 会：
# 1. clone下来lib1.git到libs/lib1
# 2. 在当前目录project1下多了一个.gitmodules文件，文件内容如下：
# [submodule "libs/lib1"]
# 	path = libs/lib1
# 	url = /Users/liuweizhen/submd/repos/lib1.git
# 这个.gitmodules文件主要记录了本地和仓库的对应关系；
# 3. 对当前目录project1/.git/config文件进行了修改，添加了如下内容：
# [submodule "libs/lib1"]
# 	url = /Users/liuweizhen/submd/repos/lib1.git
# 	active = true
# 4. 在.git中多个modules/libs/lib1目录

git submodule add ~/submd/repos/lib2.git libs/lib2
# 调用上面这一句代码，会：
# 1. clone下来lib2.git到libs/lib2
# 2. 对已存在的.gitmodules文件进行修改，修改后内容如下（添加了一个submodule）
# [submodule "libs/lib1"]
# 	path = libs/lib1
# 	url = /Users/liuweizhen/submd/repos/lib1.git
# [submodule "libs/lib2"]
# 	path = libs/lib2
# 	url = /Users/liuweizhen/submd/repos/lib2.git
# 3. 对当前目录/.git/config文件进行了修改，添加了如下内容：
# [submodule "libs/lib2"]
# 	url = /Users/liuweizhen/submd/repos/lib2.git
# 	active = true

git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#   new file:   .gitmodules
#   new file:   libs/lib1
#   new file:   libs/lib2
#

git commit -a -m "add submodules[lib1,lib2] to project1"
# [master ef24818] add submodules[lib1,lib2] to project1
#  3 files changed, 8 insertions(+)
#  create mode 100644 .gitmodules
#  create mode 160000 libs/lib1
#  create mode 160000 libs/lib2
# 注意 libs/lib1 和 libs/lib2 记录的 mode 为 160000，
# 这是 Git 中的一种特殊模式，它意味着你是将一次提交记作一项独立的目录记录的，而非将它记录成一个子目录或者一个文件

git push
