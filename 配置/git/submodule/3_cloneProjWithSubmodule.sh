#!/bin/zsh

source ./common.sh

doubleSeparateLine
echo "新用户 clone 带有 submodule 的仓库 project1 --> project1-b"
doubleSeparateLine

cd ~/submd/ws
git clone ../repos/project1.git project1-b
echo "git clone 带有 submodule 的项目所做的事情"
echo "1. 把项目clone下来"
echo "2. 把 .gitmoduels 也 clone 了下来，里面记录了 submodule 的本地路径和仓库信息"
echo "3. 记录了 submodule 的 commit-id 信息"
echo "4. 不会把 submodule 的内容 clone 下来，因此 .git/config 没有记录 submodule 的相关信息，submodule 此时内容是空的"

# 这并不会把 submodule 的内容 clone 下来，而只会在内部记录一个 submodule 的 commit-id

separateLine

echo "查看submodule"
cd project1-b
git submodule
# -ee9aa81a66fdc5d6d6919262f237f6e46f6933e2 libs/lib1
# -f40869b0db30971870b9977693430e8c0eaa5c20 libs/lib2
# "-" 代码子模块还没有被检出

separateLine
echo ".git/config"
cat .git/config
# 可以看到.git/config中没有submodule的注册信息
# [core]
# 	repositoryformatversion = 0
# 	filemode = true
# 	bare = false
# 	logallrefupdates = true
# 	ignorecase = true
# 	precomposeunicode = true
# [remote "origin"]
# 	url = /Users/liuweizhen/submd/ws/../repos/project1.git
# 	fetch = +refs/heads/*:refs/remotes/origin/*
# [branch "3"]
# 	remote = origin
# 	merge = refs/heads/master

separateLine

echo "git submodule init 检出 submodule"
echo "这会往 .git/config 文件中写入 submodule 的相关信息，即：submodule进行注册"
git submodule init
# 子模组 'libs/lib1'（/Users/liuweizhen/submd/repos/lib1.git）已对路径 'libs/lib1' 注册
# 子模组 'libs/lib2'（/Users/liuweizhen/submd/repos/lib2.git）已对路径 'libs/lib2' 注册

separateLine

echo "再次查看.git/config"

# [core]
#         repositoryformatversion = 0
#         filemode = true
#         bare = false
#         logallrefupdates = true
#         ignorecase = true
#         precomposeunicode = true
# [remote "origin"]
#         url = /Users/liuweizhen/submd/ws/../repos/project1.git
#         fetch = +refs/heads/*:refs/remotes/origin/*
# [branch "master"]
#         remote = origin
#         merge = refs/heads/master
# [submodule "libs/lib1"]
#         active = true
#         url = /Users/liuweizhen/submd/repos/lib1.git
# [submodule "libs/lib2"]
#         active = true
#         url = /Users/liuweizhen/submd/repos/lib2.git

separateLine

echo "注册后 project1-b/libs/lib1 和 project1-b/libs/lib1 下依然没有文件，需要调用 git submodule update" 
echo "clone 下来 sub module"
echo "上面 git clone 时已记录下来 submodule 的 commit-id, 此处git submodule update就会根据这个commit-id拉下来submoduel的代码"

git submodule update

echo "但是调用 git submodule update只会根据commit-id下载下来最新内容，并不关心哪个分支，即不会切换分支"
echo "不过 master 分支的commit-id和HEAD是保持一致的"
# 在project1中push之后其实就是更新了引用的commit id，
# 然后project1-b在clone的时候获取到了submodule的commit id，
# 然后当执行git submodule update的时候git就根据gitlink获取submodule的commit id，
# 最后获取submodule的文件，所以clone之后不在任何分支上；
# 但是master分支的commit id和HEAD保持一致
# % cat .git/HEAD
cat .git/HEAD 
# ref: refs/heads/master

separateLine

cd ~/submd/ws/project1-b/libs/lib1
git status
echo "切换到master分支"
git checkout master
git status

cd ~/submd/ws/project1-b/libs/lib2
git status
echo "切换到master分支"
git checkout master
git status

separateLine
