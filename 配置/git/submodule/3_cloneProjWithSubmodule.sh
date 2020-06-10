#!/bin/zsh

source ./common.sh

doubleSeparateLine
echo "      新用户 clone 带有 submodule 的仓库 project1 --> project1-b"
doubleSeparateLine

cd ~/submd/ws
git clone ../repos/project1.git project1-b
# 调用上一句代码，会：
# 把项目clone下来（包括.gitmoduels）, 查看 .gitmodules:
# [submodule "libs/lib1"]
# 	path = libs/lib1
# 	url = /Users/liuweizhen/submd/repos/lib1.git
# [submodule "libs/lib2"]
# 	path = libs/lib2
# 	url = /Users/liuweizhen/submd/repos/lib2.git
# 但是，并没有同步 project1/.git/config 中的内容, 查看 project-b/libs/lib1 和 project-b/libs/lib2 都是空目录，
# project1-b/.git/config 中并不存在submodule的相关信息，project1-b/.git下也不存在modules目录， 也就是说：
# git clone 把主项目中的内容都 clone 下来了，但是并没有拉下来submodul的内容

echo "查看submodule"
cd project1-b
git submodule
# -e16ce1a4424c15b84197e15108f85597f3e2b8a4 libs/lib1
# -64abef790b73d6bf0c9d4ace2c29df06445a6ffb libs/lib2
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

# -------------------------------------------------------------------------

git submodule init
# 子模组 'libs/lib1'（/Users/liuweizhen/submd/repos/lib1.git）已对路径 'libs/lib1' 注册
# 子模组 'libs/lib2'（/Users/liuweizhen/submd/repos/lib2.git）已对路径 'libs/lib2' 注册
# 调用上面命令 git submodule init 会检出 submodule"
# 这会往 .git/config 文件中写入 submodule 的相关信息，即：submodule进行注册
# 即：git submodule init就是在.git/config中注册子模块的信息
# 再次查看 .git/config
# 就有了 submodule 的相关信息
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

# -------------------------------------------------------------------------

# 注册后 project1-b/libs/lib1 和 project1-b/libs/lib1 下依然没有文件，需要调用 git submodule update
# clone 下来 sub module
# 上面 git clone 时已记录下来 submodule 的 commit-id, 此处 git submodule update 就会根据 submodule 的 commit-id
# 拉下来 submoduel 的代码
git submodule update
# % git submodule update
# 正克隆到 '/Users/liuweizhen/submd/ws/project1-b/libs/lib1'...
# 完成。
# 正克隆到 '/Users/liuweizhen/submd/ws/project1-b/libs/lib2'...
# 完成。
# Submodule path 'libs/lib1': checked out 'e16ce1a4424c15b84197e15108f85597f3e2b8a4'
# Submodule path 'libs/lib2': checked out '64abef790b73d6bf0c9d4ace2c29df06445a6ffb'

# 简化操作，上面的流程是:
# 1. git clone ../repos/project1.git project1-b
# 2. git submodule init
# 3. git submodule update
# 可以把上面三个命令简化成一个，如果给 git clone 命令传递 --recurse-submodules 选项，它就会自动初始化并更新仓库中的每一个子模块， 包括可能存在的嵌套子模块:
# git clone --recurse-submodules ../repos/project1.git project1-b
# 正克隆到 'project1-b'...
# 完成。
# 子模组 'libs/lib1'（/Users/liuweizhen/submd/repos/lib1.git）已对路径 'libs/lib1' 注册
# 子模组 'libs/lib2'（/Users/liuweizhen/submd/repos/lib2.git）已对路径 'libs/lib2' 注册
# 正克隆到 '/Users/liuweizhen/submd/ws/project1-b/libs/lib1'...
# 完成。
# 正克隆到 '/Users/liuweizhen/submd/ws/project1-b/libs/lib2'...
# 完成。
# Submodule path 'libs/lib1': checked out 'ea5be6be202d15e9969cef8a7d8b9df7b5b890b2'
# Submodule path 'libs/lib2': checked out '2f76a08c832c70bbf4cf289c2c7483035645842b'

# -------------------------------------------------------------------------

echo "但是调用 git submodule update只会根据commit-id下载下来最新内容，并不关心哪个分支，即不会切换分支"
echo "不过 master 分支的commit-id和HEAD是保持一致的"
# 在project1中push之后其实就是更新了引用的commit id，
# 然后project1-b在clone的时候获取到了submodule的commit id，
# 然后当执行git submodule update的时候git就根据gitlink获取submodule的commit id，
# 最后获取submodule的文件，所以clone之后不在任何分支上；
# 但是master分支的commit id和HEAD保持一致
# cat .git/modules/libs/lib1/HEAD
# cat .git/modules/libs/lib1/refs/heads/master
# From https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97
# 如果你已经克隆了项目但忘记了 --recurse-submodules，
# 那么可以运行 git submodule update --init 将 git submodule init 和 git submodule update 合并成一步。
# 如果还要初始化、抓取并检出任何嵌套的子模块， 请使用简明的 git submodule update --init --recursive

echo "切换submodule到master分支上"
cd ~/submd/ws/project1-b/libs/lib1
git status
echo "lib1切换到master分支"
git checkout master
git status

cd ~/submd/ws/project1-b/libs/lib2
git status
echo "lib2切换到master分支"
git checkout master
git status

