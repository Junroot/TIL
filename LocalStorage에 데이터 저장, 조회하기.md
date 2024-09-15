---
tags:
  - JavaScript
title: LocalStorage에 데이터 저장, 조회하기
---


## 데이터 저장

```jsx
window.localStorage.setItem('myCat', 'Tom');
```

## 데이터 조회

```jsx
const cat = localStorage.getItem('myCat') // 없으면 null
```

## 데이터 삭제

```jsx
localStorage.removeItem('myCat');
```

## 데이터 전체 삭제

```jsx
localStorage.clear();
```

## 참고 자료

[https://developer.mozilla.org/ko/docs/Web/API/Window/localStorage](https://developer.mozilla.org/ko/docs/Web/API/Window/localStorage)
