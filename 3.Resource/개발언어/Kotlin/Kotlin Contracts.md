# Kotlin Contracts

## 목표

- Kotlin contracts가 무엇인지 이해한다.
- Kotlin contracts의 사용법을 이해한다.

## 배경

- 아래 사진과 같이 `validate()` 함수에서 `request`의 null 검사를 했음에도 불구하고, `process`는 다른 함수여서 스마트 캐스트가 이루어지지 않는다.
- Kotlin contracts를 사용하면 이 문제를 해결할 수 있다.
	- Kotlin contracts는 컴파일러에게 함수의 동작을 알려준다.

![](assets/Pasted%20image%2020230427114443.png)

## 스마트 캐스트

- `contract()` 메서드를 호출되는 함수에 선언하고, 내부에 함수의 동작을 명시한다.
- `returns()`: 함수가 정상적으로 리턴되는 경우를 의미한다.
- `implies()`: 파라미터로 받은 `booleanExpression`이 항상 참임을 보장한다.
- 실험적인 단계의 contract API를 사용하는 함수에는 `@OptIn(ExperimentalContracts:class)`를붙여주거나 컴파일 인자로 `-opt-in=kotlin.contracts.ExperimentalContracts`를 사용해야 된다.

![](assets/Pasted%20image%2020230427115336.png)

- 아래 코드와 같이 타입을 스마트 캐스트하는 것도 가능하다.

```kotlin
data class MyEvent(val message: String)


fun processEvent(event: Any?) {
    if (isInterested(event)) {
        println(event.message) 
    }
}

@OptIn(ExperimentalContracts::class)
fun isInterested(event: Any?): Boolean {
    contract { 
        returns(true) implies (event is MyEvent)
    }
    return event is MyEvent
}
```

## 그 외 API

- `callsInPlace()`: 인자로 받은 함수형 인터페이스가 다름 함수에 전달되지 않고, 자기 자신에서만 호출된다는 것을 보장한다.
- `InvocationKind.EXACTLY_ONCE`: 함수 내에서 정확히 한번만 호출됨

```kotlin

fun callsInPlace() {
    val i: Int
    myRun {
        i = 1
    }
    println(i) // 1이라는 것이 보장됨
}

@ExperimentalContracts
inline fun <R> myRun(block: () -> R): R {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    return block()
}
```

## 참고 자료

- https://www.baeldung.com/kotlin/contracts#2-making-guarantees-about-a-functions-usage
- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.contracts/