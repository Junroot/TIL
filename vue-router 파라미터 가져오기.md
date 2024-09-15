---
tags:
  - Vuejs
title: vue-router 파라미터 가져오기
---


## 방법

- `$route.params`를 통해 가져올 수 있다.

| pattern                        | matched path             | `$route.params`                        |
| ------------------------------ | ------------------------ | -------------------------------------- |
| /users/:username               | /users/eduardo           | { username: 'eduardo' }                |
| /users/:username/posts/:postId | /users/eduardo/posts/123 | { username: 'eduardo', postId: '123' } |

## 참고 자료

- https://router.vuejs.org/guide/essentials/dynamic-matching.html
