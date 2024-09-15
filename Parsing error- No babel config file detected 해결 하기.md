---
tags:
  - npm
title: Parsing error- No babel config file detected 해결 하기
---


## 배경

- vscode로 vue.js 프로젝트를 열었는데, eslint와 prettier가 적용되지 않고 제목과 같은 오류가 발생했다.

## 해결 방법

- vscode에서 `eslintrc.js` 설정 파일을 자동으로 찾지 못 하고있다. 

- vscode에서는 기본적으로 열어 놓은 디렉토리의 최상단에서 설정 파일을 찾는다.

- vscode에서 별도의 설정이 필요했다.

  - `settings.json`

    ```json
    "eslint.workingDirectories": [
      {        
        "mode": "auto"
      }
    ]
    ```

## 참고 자료

- https://stackoverflow.com/questions/71271760/parsing-error-no-babel-config-file-detected-when-ide-not-open-at-vue-projects
