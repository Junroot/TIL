

# Deque 사용하기

## 목표

- kotlin에서 deque을 사용하는 방법을 알아본다.

## ArrayDeque

- kotlin에서 제공하는 배열기반의 `Deque` 구현체다.
- `LinkedList`와 비교했을 때 메모리 오버헤드가 적고 런타임 속도가 더 빠르다.

### 사용법

- 생성

```kotlin
val deque = ArrayDeque(listOf(1, 2, 3, 4))
```

- 추가

```kotlin
deque.addFirst(1) // 앞
deque.addLast(5) // 뒤
```

- 제거
	- `removeFirst`, `removeLast`의 경우 요소가 존재하지 않으면 `NoSuchElementException` 예외가 발생한다.
```kotlin
deque.removeFirst()
deque.removeLast()
deque.removeFirstOrNull()
deque.removeLastOrNull()
```

## 참고 자료

- https://www.baeldung.com/kotlin/arraydeque