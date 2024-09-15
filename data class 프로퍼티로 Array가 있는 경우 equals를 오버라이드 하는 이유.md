---
tags:
  - Kotlin
title: data class 프로퍼티로 Array가 있는 경우 equals를 오버라이드 하는 이유
---


## 상황

- data 클래스에 `Array` 타입의 프로퍼티가 있을 경우에 IDE에서 `equals()`와 `hashCode()`를 오버라이드 하라는 알림이 나온다.
	- ![](assets/Pasted%20image%2020231027164746.png)
## 원인

- data 클래스는 `equals()`를 자동 생성할 때, 각 프로퍼티의 `equals()` 메소드를 호출하여 동등성을 비교한다.
- 아래 사진은 위의 `SomeClass`를 자바로 디컴파일 한 코드다.
	- ![](assets/Pasted%20image%2020231027165039.png)
- `Instrinsics.areEqual()` 코드를 살펴보면 두 객체의 `equals()`를 호출하는 것을 확인할 수 있다.
	- ![](assets/Pasted%20image%2020231027165143.png)
- `Array` 타입은 `equals()` 메소드가 구현되어 있지 않으므로, 오버라이드 해줘야된다.
- 만약 `List` 를 사용할 수 있는 상황이라면 `Array` 대신 `List`로 대체하는 방법도 있다.

## 참고 자료

- https://stackoverflow.com/questions/37524422/equals-method-for-data-class-in-kotlin
