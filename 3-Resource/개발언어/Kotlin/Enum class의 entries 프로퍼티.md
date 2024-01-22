# Enum class의 entries 프로퍼티

## 목표

- Enum 클래스의 `entries` 프로퍼티가 무엇인지 이해한다.
- 기존에 있던 Enum `values()` 메서드와 차이점을 이해한다.

## entries

- kotlin 1.9.0부터 enum 모든 값을 반복해서 처리하고 싶은 경우 `entries` 프로퍼티를 사용할 수 있다.

```kotlin
CardType.entries.forEach {  
    println(it.code)  
}
```

## values()와 차이점

### values()

- 호출시마다 배열을 생성하고 복제한다. (상대적으로 성능이 나쁨)
- mutable 하다.
- `Array` 타입 반환으로 kotlin의 확장 함수를 사용하기 불편하다.

### entries

- 미리 생성된 리스트를 반환한다.
- immutable
- `List`를 상속한 `EnumEntries`를 반환하여 kotlin의 확장 함수들을 사용하기 용이하다.

## 참고 자료

- https://www.baeldung.com/kotlin/enum
- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.enums/-enum-entries.html
- https://engineering.teknasyon.com/kotlin-enums-replace-values-with-entries-bbc91caffb2a
