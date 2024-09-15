---
tags:
  - Java
title: TreeSet
---

지속적으로 정렬 상태를 유지하면서, 새로운 데이터가 추가/삭제가 자주 일어나는 경우가 있었다. 쉽게 말해서 균형 잡힌 이진 트리인 레드 블랙 트리를 사용해야 됐다. `TreeSet`은 `Set` 인터페이스의 구현체다.

![Untitled](assets/Untitled-4550196.png)

## 대표 메서드

`TreeSet`에서 사용되는 대표적인 메서드를 정리해본다.

- `E floor(E e)`: e 이하인 객체 중 가장 큰 값을 리턴한다. 없으면 `null`이 리턴된다. O(log n)
- `E ceiling(E e)`: e 이상인 객체 중 가장 작은 값을 리턴한다. 없으면 `null`이 리턴된다. O(log n)
- `E higher(E e)`: e 초과인 객체 중 가장 작은 값을 리턴한다. 없으면 `null`이 리턴된다. O(log n)
- `E lower(E e)`: e 미만인 객체 중 가장 큰 값을 리턴한다. 없으면 `null`이 리턴된다. O(log n)
- `E first()`: 가장 작은 값을 리턴한다. O(1)
- `E last()`: 가장 큰 값을 리턴한다. O(1)
- `boolean add(E e)`: e를 추가한다. 이미 존재하면 `false`가 리턴된다. O(log n)

## 참고 자료

[https://www.geeksforgeeks.org/treeset-in-java-with-examples/](https://www.geeksforgeeks.org/treeset-in-java-with-examples/)

[https://lordofkangs.tistory.com/80](https://lordofkangs.tistory.com/80)
