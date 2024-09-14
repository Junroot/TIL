#!/bin/bash

# 루트 디렉토리를 현재 디렉토리로 설정하거나 필요한 경로로 변경하세요
ROOT_DIR="."

# 마크다운 파일들을 순회합니다
find "$ROOT_DIR" -type f -name "*.md" | while read -r FILE_PATH; do
    # 파일의 상대 경로를 구합니다
    RELATIVE_PATH="${FILE_PATH#$ROOT_DIR/}"

    # 상대 경로를 '/'로 분할하여 배열로 만듭니다
    IFS='/' read -r -a PATH_PARTS <<< "$RELATIVE_PATH"

    # 배열의 길이를 구합니다
    PARTS_COUNT=${#PATH_PARTS[@]}

    # 직속 디렉토리 이름을 가져옵니다
    if [ "$PARTS_COUNT" -ge 2 ]; then
        PARENT_INDEX=$((PARTS_COUNT - 2))
        PARENT_DIR="${PATH_PARTS[$PARENT_INDEX]}"
        # 디렉토리 이름의 공백을 '-'로 대체합니다
        TAG="${PARENT_DIR// /-}"

        # 파일의 첫 번째 줄을 읽어서 프론트매터 여부 확인
        FIRST_LINE=$(head -n 1 "$FILE_PATH")
        if [ "$FIRST_LINE" == "---" ]; then
            # 프론트매터가 존재하는 경우
            awk -v tag="$TAG" '
            BEGIN {FS=OFS="\n"; in_front_matter=0}
            {
                if (NR==1 && $1=="---") {
                    in_front_matter=1
                    front_matter_lines[front_matter_line_count++] = $0
                    next
                }
                else if (in_front_matter && $1=="---") {
                    in_front_matter=0
                    front_matter_lines[front_matter_line_count++] = $0

                    # 프론트매터에서 tags 항목을 덮어씁니다
                    tags_written=0
                    for (i=0; i<front_matter_line_count; i++) {
                        if (front_matter_lines[i] ~ /^tags:/) {
                            front_matter_lines[i] = "tags:\n  - " tag
                            tags_written=1
                        }
                    }
                    if (!tags_written) {
                        # tags 항목이 없으면 추가
                        front_matter_lines[front_matter_line_count++] = "tags:\n  - " tag
                    }

                    # 업데이트된 프론트매터 출력
                    for (i=0; i<front_matter_line_count; i++) {
                        print front_matter_lines[i]
                    }
                    next
                }
                else if (in_front_matter) {
                    # tags 항목을 제외하고 프론트매터를 저장
                    if ($0 !~ /^tags:/ && $0 !~ /^  - /) {
                        front_matter_lines[front_matter_line_count++] = $0
                    }
                    next
                }
                print $0
            }
            ' "$FILE_PATH" > "$FILE_PATH.tmp" && mv "$FILE_PATH.tmp" "$FILE_PATH"
        else
            # 프론트매터가 없는 경우, 새로운 프론트매터를 파일의 맨 위에 추가
            # 임시 파일 생성
            {
                echo "---"
                echo "tags:"
                echo "  - $TAG"
                echo "---"
                cat "$FILE_PATH"
            } > "$FILE_PATH.tmp" && mv "$FILE_PATH.tmp" "$FILE_PATH"
        fi

    else
        echo "스킵: $FILE_PATH (직속 디렉토리 없음)"
    fi
done