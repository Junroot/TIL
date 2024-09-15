---
tags:
  - React
title: state, props
---


- state와 props 둘 다 react의 구성요소인 컴포넌트를 렌더링하기 위한 정보를 담고 있다.
- state는 컴포넌트 안에서 관리되는 반면, props는 컴포넌트에게 정보를 전달하는 용도로 사용한다.

## setState()

- `setState()` 함수를 이용해서 state의 값을 변경하면 컴포넌트가 리렌더링된다.
- `setState()` 함수는 비동기로 처리되기때문에, 이 함수를 호출했다고 바로 state가 변경될거라고 생각하면 안된다.
- state의 이전값을 기준으로 값을 변경하고 싶다면 아래와 같이 함수를 전달하는 방식으로 구현해야된다.

    ```jsx
    this.setState((state) => {
      // 중요: 값을 업데이트할 때 `this.state` 대신 `state` 값을 읽어옵니다.
      return {count: state.count + 1}
    });
    ```

## 참고 자료

[https://ko.reactjs.org/docs/faq-state.html](https://ko.reactjs.org/docs/faq-state.html)
