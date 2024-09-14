---
tags:
  - Kotlin
---
# List에서 element 개수 Map으로 만들기

## 목표

- \[1, 1, 2, 2, 3, 4, 4, 4, 5, 5, 5, 5, 5\]의 경우, {1=2, 2=2, 3=1, 4=3, 5=5} 로 만들어주는 로직이 필요했다.

## `groupingBy`

- 코틀린 확장 함수
- `keySelector`라는 함수를 함수를 명시해서 각 element에 key를 추출한다.
- key별로 그룹핑한 값들을 `Grouping<T, K>` 클래스로 래핑한다. `T`가 원래 타입, `K`가 key의 타입이 된다.
- `Grouping<T, K>` 클래스에서 `eachCount()`를 호출하면 각 그룹의 element 개수를 `Map<K, Int>` 형태로 반환한다.

```kotlin
val words = "one two three four five six seven eight nine ten".split(' ')
val frequenciesByFirstChar = words.groupingBy { it.first() }.eachCount()
println("Counting first letters:")
println(frequenciesByFirstChar) // {o=1, t=3, f=2, s=2, e=1, n=1}
```

## 참고 자료

- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/grouping-by.html
- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/each-count.html