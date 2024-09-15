---
tags:
  - Vuejs
title: vue-router에서 뒤로가기 구현 방법
---


## 목표

- vue-router에서 뒤로가기 구현 방법을 이해한다.

## vue-router의 2가지 모드

### hash mode

- url에 '#'을 사용해서 URL이 변경되어도 페이지가 리로딩되지 않도록 하는 모드

### history mode

- `history.pushState`를 사용해서 URL이 변경되어도 페이지가 리로딩되지 않도록 하는 모드
	- 참고: https://developer.mozilla.org/en-US/docs/Web/API/History/pushState
- 서버 설정에 따라, 404 에러가 발생할 수 있으므로 웹 서버 설정을 확인해봐야된다.

## 뒤로가기 구현법

- `this.$router.push`: 히스토리 스택에 새로운 경로로 이동할 수 있다.
- `this.$router.go`: 히스토리 스택을 이동할 수 있다.

```js
// go forward by one record, the same as router.forward()
router.go(1)

// go back by one record, the same as router.back()
router.go(-1)

// go forward by 3 records
router.go(3)

// fails silently if there aren't that many records
router.go(-100)
router.go(100)
```

## 참고 자료

- https://router.vuejs.org/guide/essentials/navigation.html#traverse-history
