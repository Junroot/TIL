---
tags:
  - Kotlin
  - Java
---
# Kotlin과 Java 혼용시 Checked Exception 알려주기

## 상황

- 코틀린에서는 Checked Exception을 따로 처리해주지 않는다.
- 자바에서 Checked Exception을 catch 해서 처리해주고 싶은데 이가 문제가 되었다.

## 해결 방법

- 코틀린에 `@Throws` 어노테이션을 사용하면 자바에서 checked exception 처리가 가능해진다.

```kotlin
@Throws(IOException::class)
fun foo() {
    throw IOException()
}
```

## 참고 자료

- https://kotlinlang.org/docs/java-to-kotlin-interop.html#checked-exceptions
- https://stackoverflow.com/questions/36528515/throws-exception-in-a-method-with-kotlin