---
tags:
  - Kotlin
---
# Kotlin takeIf

## 목표

- `takeIf()` 함수의 목적을 이해한다.

## takeIf

```kotlin
inline fun <T> T.takeIf(predicate: (T) -> Boolean): T?
```

- `predicate`가 `true`면 `this`를 리턴하고, `false`면 `null`을 리턴한다.

## 참고 자료

- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/take-if.html