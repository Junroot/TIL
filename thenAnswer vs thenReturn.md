---
tags:
  - Mockito
title: thenAnswer vs thenReturn
---


## 목표

- `thenAnswer`와 `thenReturn`의 차이를 알아본다.

## 차이점

- `thenReturn`은 정적인 반환 값을 설정할 때 사용한다.
- `thenAnswer`은 호출에 대한 추가적은 작업이 필요하거나, 동적인 반환 값이 필요할 때 사용한다.

## thenAnswer

- `thenAnswer`는 `Answer` 타입의 인자를 갖는다.
- `Answer`는 함수형 인터페이스이다.

![](assets/Pasted%20image%2020230210204936.png)

- 아래 사진처럼 `Answer`의 메서드의 인자인 `InvocationOnMock`은 호출한 메소드의 인자를 반환하거나, 해당 메소드를 반환, mocking한 대상 객체를 반환도 할 수 있어서 유연하게 사용할 수 있다.

![](assets/Pasted%20image%2020230210205208.png)

## 참고 자료

- https://stacktraceguru.com/unittest/thenreturn-vs-thenanswer
- https://www.baeldung.com/mockito-additionalanswers
- https://javadoc.io/static/org.mockito/mockito-core/3.1.0/org/mockito/invocation/InvocationOnMock.html
