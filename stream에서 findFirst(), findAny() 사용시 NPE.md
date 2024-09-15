---
tags:
  - Java
title: stream에서 findFirst(), findAny() 사용시 NPE
---


## 배경

- null 값을 가지고 있는 stream에서 `findFirst()` 메서드를 호출하니 `NullPointerException`이 발생했다.
	- ![](assets/Pasted%20image%2020231025195210.png)
	- ![](assets/Pasted%20image%2020231025195233.png)

## 원인

- 공식 문서를 읽어보니 선택된 요소가 `null`이면 `NullPointerException`이 발생한다.
	- ![](assets/Pasted%20image%2020231025195111.png)
- 비어있는 `Optional`이 반환되는 경우는 stream이 비어있는 경우만 해당된다.

## 참고 자료

- https://docs.oracle.com/javase/10/docs/api/java/util/stream/Stream.html#findFirst()
