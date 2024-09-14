---
tags:
  - Vuejs
---
# vue-router로 컴포넌트 이동시 이전 컴포넌트 상태 유지

## 방법

- `<KeepAlive>` 컴포넌트를 사용하면, 이전 컴포넌트의 상태를 캐싱했다가 뒤로돌아가도 유지된다.
- https://vuejs.org/guide/built-ins/keep-alive.html#basic-usage

## KeepAlive의 상태 유지 방법

- `KeepAlive` 컴포넌트 레벨에서 캐싱이 이루어지고 있다.
- 만약 중간에 `KeepAlive` DOM이 사라지면 캐싱이 지워진다.
- https://github.com/vuejs/vue/blob/dev/src/core/components/keep-alive.js#L90

## 참고 자료

- https://stackoverflow.com/questions/41764825/preserve-component-state-with-vue-router
- https://stackoverflow.com/questions/71145498/where-does-vuejs-store-the-cached-component-when-using-keep-alive
