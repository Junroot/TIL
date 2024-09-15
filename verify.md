---
tags:
  - Mockito
title: verify
---


## 목표

- mockito의 `verify()` 메서드를 통해 검증할 수 있는 내용들을 알아본다.

## 호출된 횟수 검증

```kotlin
List<String> mockedList = mock(MyList.class); 
mockedList.size(); 
verify(mockedList, times(1)).size();
```

## 호출되지 않음을 검증

```kotlin
List<String> mockedList = mock(MyList.class); 
mockedList.size(); 
verify(mockedList, never()).clear();
```

## 호출되는 인자 매칭 커스터마이징

- 인자 매칭 기준이 복잡하다면 `ArgumentMatchers.argThat()` 을 통해서 매칭 기준을 커스터마이징할 수 있다.
- 인자로 `ArgumentMatcher`라는 함수형 인터페이스를 받고 있어서 람다로 구체적인 조건을 명시할 수 있다.

![](assets/Pasted%20image%2020230213185852.png)

![](assets/Pasted%20image%2020230213185929.png)

## 참고 자료

- https://www.baeldung.com/mockito-verify
- https://www.baeldung.com/mockito-argument-matchers
