function separateLine() {
    echo "-----------------------------"
}

function doubleSeparateLine() {
    echo "============================="
}

# 提交规则：
# 1. 先提交submodule本身
# 2. 再提交主工程对submodule的commit-id引用

# pull规则：
# 1. 先 pull 主工程
# 2. 再对submodule单独pull
# 3. 再更新主工程对submodule的commit-id的引用