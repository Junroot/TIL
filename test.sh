#!/bin/bash

# 루트 디렉토리를 현재 디렉토리로 설정하거나 필요한 경로로 변경하세요
ROOT_DIR="."

# 최상위 assets 디렉토리 경로
TOP_LEVEL_ASSETS="$ROOT_DIR/assets"

# 최상위 assets 디렉토리가 없으면 생성합니다
if [ ! -d "$TOP_LEVEL_ASSETS" ]; then
    mkdir "$TOP_LEVEL_ASSETS"
    echo "최상위 assets 디렉토리를 생성했습니다: $TOP_LEVEL_ASSETS"
fi

# 하위 디렉토리에서 assets 디렉토리를 찾습니다 (최상위 디렉토리는 제외)
find "$ROOT_DIR" -type d -name "assets" ! -path "$TOP_LEVEL_ASSETS" | while read -r ASSETS_DIR; do
    # 하위 assets 디렉토리의 상대 경로를 구합니다
    RELATIVE_PATH="${ASSETS_DIR#$ROOT_DIR/}"
    
    # assets 디렉토리의 부모 디렉토리로부터 상대 경로를 만듭니다
    PARENT_DIR=$(dirname "$RELATIVE_PATH")
    
    # 최상위 assets 디렉토리 내에 하위 디렉토리 구조를 재현합니다
    TARGET_DIR="$TOP_LEVEL_ASSETS/$PARENT_DIR"
    mkdir -p "$TARGET_DIR"
    
    echo "복사 중: $ASSETS_DIR/* -> $TARGET_DIR/"
    
    # 파일들을 이동하거나 복사합니다 (여기서는 이동)
    mv "$ASSETS_DIR/"* "$TARGET_DIR/" 2>/dev/null
    
    # 빈 assets 디렉토리를 삭제합니다
    rmdir "$ASSETS_DIR"
done