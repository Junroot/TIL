#!/bin/bash

# 콘텐츠 디렉토리 설정 (필요에 맞게 수정)
CONTENT_DIR="."

# Markdown 파일을 재귀적으로 탐색
find "$CONTENT_DIR" -type f -name "*.md" | while IFS= read -r filepath; do
    # 첫 번째 h1 헤딩(# 제목)을 찾아 삭제
    sed -i '' 's/^# .*//' "$filepath"
    
    echo "Processed $filepath"
done