#!/bin/bash

# 检查文件是否存在
if [ ! -f urlsToDeal ]; then
    echo "Error: urls file not found in the current directory."
    exit 1
fi

# 逐行读取文件中的 URL
while IFS= read -r url
do
    # 对每个 URL 执行操作
    echo "Processing URL: $url"
    you-get -i $url |grep download-with |tail -n 1
    # 执行 you-get -i $url 命令并捕获输出
    output=$(you-get -i "$url" 2>&1)
    # 检查输出中是否包含 "download-with"
    if echo "$output" | grep -q "download-with"; then
        # 提取带 "download-with" 的最后一行
        last_line_with_download_with=$(echo "$output" | grep "download-with" | tail -n 1)
        format=$(echo "$last_line_with_download_with" | awk -F '--format=' '{split($2, a, " "); print a[1]}')
	if [ -n "$format" ]; then
            echo "format for $url: $format"
            # 用format下载视频
            echo "you-get --format=$format $url"
	    you-get --format=$format $url
	else
            echo "No format found for $url"
        fi
    else
        echo "No 'download-with' information found for $url"
    fi
done < urlsToDeal

echo "remove xml files and video files..."
# 定义要删除的文件模式
mp4_pattern='[00].mp4'
xml_pattern='*.xml'
# 检查当前目录下的文件
echo "Searching for files matching patterns: $mp4_pattern and $xml_pattern"
# 删除匹配的文件
find . -type f \( -name "$mp4_pattern" -o -name "$xml_pattern" \) -exec rm -v {} \;
echo "Cleanup completed."

# 检查 ffmpeg 是否已安装
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install ffmpeg first."
    exit 1
fi

# 遍历当前目录下的所有 .mp4 文件
for mp4_file in *.mp4; do
    # 检查文件是否存在
    if [ -f "$mp4_file" ]; then
        # 获取不带扩展名的文件名
        filename_without_extension="${mp4_file%.*}"
        
        # 转换为 mp3 文件
        echo "Converting $mp4_file to $filename_without_extension.mp3"
        ffmpeg -i "$mp4_file" -vn -acodec libmp3lame "$filename_without_extension.mp3"
        
        # 删除原始的 mp4 文件
        echo "Deleting $mp4_file"
        rm "$mp4_file"
    fi
done

echo "All mp4 files have been converted to mp3 and the original mp4 files have been deleted."
echo "All URLs have been processed."
