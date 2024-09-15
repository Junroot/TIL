---
tags:
  - Mockito-Kotlin
title: mocking
---


- 아래와 같이 람다 형식으로 특정 모드를 mocking 할 수 있다.

```kotlin
val mock = mock<MyClass> {
	on { getText() } doReturn "text"
}
```

## 참고 자료

- https://github.com/mockito/mockito-kotlin
