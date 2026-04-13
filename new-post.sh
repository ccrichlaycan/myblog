#!/bin/bash
# Hugo 新文章创建脚本

echo "请输入文章标题（中文）："
read title

# 生成文件名（使用拼音或时间戳）
filename=$(date +%Y%m%d-%H%M%S)

# 创建文章
cd ~/myblog
hugo new content/posts/${filename}.md

echo "✓ 文章已创建: content/posts/${filename}.md"
echo "请用 VS Code 打开编辑，完成后运行 ./deploy.ps1 发布"
