---
title: Kotlin Couroutine 기본 개념
tags:
  - Kotlin
---
## 목표

- 코루틴의 기본 개념을 이해한다.
- 코투린을 사용하기 위한 기본 kotlin 문법을 이해한다.

## 코루틴

- 특정 코드 블럭을 다른 커드와 동시에 실행한다는 점에서 스레드와 비슷하다.
- 하지만 코루틴은 특정 스레드에 바인딩되지 않는다.
	- 한 스레드에서 실행을 일시 중지했다가 다른 스레드에서 다시 시작할 수 있다.
	- 스레드를 사용하면 메모리를 많이 소모하게되지만, 코루틴은 JVM에서 사용 가능한 메모리 제한에 부딪히지 않고 표현할 수 있다.

```kotlin
fun main() = runBlocking { // this: CoroutineScope
    launch { // launch a new coroutine and continue
        delay(1000L) // non-blocking delay for 1 second (default time unit is ms)
        println("World!") // print after delay
    }
    println("Hello") // main coroutine continues while a previous one is delayed
}
```

- `launch()`: 코루틴 빌더이다. 코드 블럭을 이후에 있는 코드와 동시에 실행하도록 코루틴을 실행한다.
- `delay()`: 특정 시간 동안 코루틴을 일시 중단 시키는 함수다. 코루틴을 일시 중단해도 기본 스레드가 차단되지는 않지만 다른 코루틴이 실행되어 코드에 기본 스레드를 사용할 수 있다.
- `runBlocking()`: 코루틴이 아닌 영역과 코루틴 내의 코드를 연결해준다. `runBlocking` 의 중괄호 내에서 사용하는 코드는 `CoroutineScope` 내에서 실행된다.
	- 만약 `runBlocking()` 없이 `launch()`를 실행하면 에러가 발생한다. `launch()`는 `CoroutineScope` 내에서만 호출할 수 있다.
	- `runBlocking` 이름 그대로 내부에 있는 모든 코루틴일 완료될 때 까지 블로킹된다.
	- `runBlocking`은 애플리케이션의 최상위 수준에서만 사용되며 실제 코드 내부에서는 거의 사용되지 않는다. 스레드를 블로킹하는 것은 비효율적이기 때문이다.
- 코루틴은 structured concurrency 원칙을 따른다.
	- structured concurrency: 코루틴은 `CoroutineScope` 안에서만 실행될 수 있도록한다.
	- 이를통해 코루틴의 수명을 쉽게 관리할 수 있다.
	- 장점:
		- 모든 자식 코루틴이 끝날 때까지 부모가 종료되지 않아, 실행 중인 코루틴을 놓치지 않도록 할 수 있다.
		- 에러가 발생하면 확실하게 감지가 가능하다.

## suspend 함수

- 코루틴 내에서 함수를 호출하려면 `suspend` 제어자가 필요하다.
- `suspend` 함수는 다른 `suspend` 함수(에: `delay` 함수)를 사용하여 코루틴의 실행을 중지할 수 있다.

```kotlin
fun main() = runBlocking { // this: CoroutineScope
    launch { doWorld() }
    println("Hello")
}

// this is your first suspending function
suspend fun doWorld() {
    delay(1000L)
    println("World!")
}
```

## Scope builder

- `coroutineScope()`를 사용해서 자신만의 스코프를 선언할 수 있다.
	- 이 함수는 코루틴 스코프를 만들고, 자식 코루틴이 완료될 때 까지 자신도 완료되지 않는다.
- `runBlocking()`과 차이점
	- `runBlocking`은 현재 스레드를 블로킹하지만, `coroutineScope`는 현재 스레드가 다른 곳에 사용될 수 있도록 release 한다.

```kotlin
fun main() = runBlocking {
    doWorld()
}

suspend fun doWorld() = coroutineScope {  // this: CoroutineScope
    launch {
        delay(1000L)
        println("World!")
    }
    println("Hello")
}
```

## Job

- `launch()`는 `Job`을 반환하는데, `Job`을 통해 명시적으로 반환할 때 까지 기다리는 데 사용할 수 있다.

```kotlin
val job = launch { // launch a new coroutine and keep a reference to its Job
    delay(1000L)
    println("World!")
}
println("Hello")
job.join() // wait until child coroutine completes
println("Done") 
```

## 참고 자료

- https://kotlinlang.org/docs/coroutines-basics.html#structured-concurrency
