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
    echo "처리 중: $ASSETS_DIR"

    # assets 디렉토리 내의 모든 파일을 순회합니다
    find "$ASSETS_DIR" -type f | while read -r FILE; do
        # 파일 이름만 추출합니다
        FILENAME=$(basename "$FILE")
        DESTINATION="$TOP_LEVEL_ASSETS/$FILENAME"

        # 파일 이름 충돌 처리
        if [ -e "$DESTINATION" ]; then
            # 파일명에 숫자 접미사를 추가하여 충돌 방지
            COUNT=1
            EXTENSION="${FILENAME##*.}"
            BASENAME="${FILENAME%.*}"
            NEW_FILENAME="${BASENAME}_$COUNT.$EXTENSION"
            DESTINATION="$TOP_LEVEL_ASSETS/$NEW_FILENAME"
            while [ -e "$DESTINATION" ]; do
                COUNT=$((COUNT + 1))
                NEW_FILENAME="${BASENAME}_$COUNT.$EXTENSION"
                DESTINATION="$TOP_LEVEL_ASSETS/$NEW_FILENAME"
            done
            echo "파일 이름 충돌로 인해 '$FILENAME'을 '$NEW_FILENAME'으로 변경합니다."
        fi

        # 파일을 이동합니다
        mv "$FILE" "$DESTINATION"
    done

    # 빈 assets 디렉토리를 삭제합니다
    rmdir "$ASSETS_DIR"
done