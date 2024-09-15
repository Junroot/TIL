---
tags:
  - Java
title: Thread pool 생성
---


## 배경

- `Executors.newFixedThreadPool(10)`의 의미를 알아본다.

## Executors.newFixedThreadPool()

- 고정된 개수의 스레드를 가지는 스레드풀을 생성한다.
- 반환 값은 `ExecutorService`이다.

```java
ExecutorService executor = Executors.newFixedThreadPool(10);
```

## ExecutorService

- `ExecutorService`는 인터페이스이며, `execute()` 메서드를 통해 파라미터로 `Callable`이나 `Runnable`을 넘겨주면 스레드풀에서 해당 작업을 할당해 실행해준다.

```java
executorService.execute(runnableTask);
```

- `ExecutorService`는 수동으로 소멸시켜줘야된다.
	- `shutdown()` 메소드는 즉시 소멸되지 않고, 현재 실행 중인 스레드가 모드 완료되고 소멸된다.
	- `shutdownNow()`: 현재 실행중인 스레드들을 즉시 멈추고 소멸시킨다. 또한, 실행 중이던 작업들을 반환한다.

```java
executorService.shutdown();
List<Runnable> notExecutedTasks = executorService.shutDownNow();
```

## 참고 자료

- https://www.baeldung.com/java-executor-service-tutorial
