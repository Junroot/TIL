---
tags:
  - npm
---
# webpack에서 오류 발생시 화면 가리지 않도록 하기

## 배경

- webpack에서는 기본적으로 오류가 발생하면 화면을 가려서 사용하지 못 하도록한다.

- 빠른 개발을 위해서 이를 비활성화 하기 위해서 아래와 같은 설정을 했지만 적용되지 않았다.

  - `vue.config.js`

    ```javascript
    module.exports = {
      devServer: {
        overlay: false,
      },
    };
    ```

## 문제 해결

- webpack 버전이 올라가면서 사양이 바뀌었다.

  - `vue.config.js`

    ```javascript
    module.exports = {
      devServer: {
        client: {
          overlay: false,
        },
      },
    };
    ```

- `vue.config.js` 파일은 vue-cli에서 프로젝트에서 webpack에 대한 설정을 추가할 수 있기 때문에 `webpack.config.js`를 사용하지 않아도 된다. 따라서, vue-cli보다 webpack 문서를 읽어보는 것이 더 정확하다.

  - https://cli.vuejs.org/config/#vue-config-js
  - https://webpack.js.org/configuration/dev-server/

## 참고 자료

- https://webpack.js.org/configuration/dev-server/#devserverclient