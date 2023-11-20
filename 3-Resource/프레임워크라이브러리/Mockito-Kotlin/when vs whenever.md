# when vs whenever

## 배경

- 테스트 코드를 보니 원래 알고있던 `when()`함수가 아니라 `whenever()`함수를 사용하고 있었다.

## Kotlin에서 when을 사용하면 문제점

- Kotiln에는 이미 `when`이라는 예약어가 있기 때문에 백틱을 사용해서 호출해야된다.
```kotlin
val mockBookService = Mockito.mock(BookService::class.java) Mockito.`when`(mockBookService. inStock(100)).thenReturn(true)
```

- mockito-kotlin 라이브러리에서 이것이 번거롭기 때문에 `whenever`라는 함수를 제공해주고 있다.
```kotlin
whenever(mockBookService.inStock(100)).thenReturn(true)
```

## 참고 자료

- https://www.baeldung.com/kotlin/mockito