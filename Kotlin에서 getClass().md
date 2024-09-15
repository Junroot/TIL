---
tags:
  - Kotlin
title: Kotlin에서 getClass()
---


## 배경

- Java에서 `Class<T>` 타임을 파라미터로 받는 메서드를 코틀린에서 사용할 필요가 있었다.

## KClass

- 코틀린에서는 `Class<T>`와 비슷하게 `KClass<T>`를 제공하고 있다.

![](assets/Pasted%20image%2020230221223252.png)

- 아래와 같은 방식으로 타입을 얻을 수 있지만 `Class<T>`와는 같지 않다.

```kotlin
String::class
```

- 자바의 타입을 얻고 싶다면, 아래와 같이 `kotlin.jvm`에서 제공하고 있는 확장 프로퍼티를 이용할 수 있다.

```kotlin
String::class.java
```

![](assets/Pasted%20image%2020230221223656.png)
