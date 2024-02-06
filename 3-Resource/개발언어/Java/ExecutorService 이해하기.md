# ExecutorService 이해하기

## 목표

- `ExecutorService`의 역할을 이해한다.
- `ExecutorService`의 대표적인 메서드를 이해한다.

## Runnable

- 스레드에 의해 실행될 작업을 나타내는 함수형 인터페이스
- `void run()` 메서드를 가지고 있다.

## Executor

- `Runnable` 작업을 실행시켜주는 인터페이스
- 실행 작업과 각 작업이 실행되는 메커니즘(스레드 사용, 스케쥴링 등)을 decoupling 시켜주는 인터페이스이다.
- 일반적으로 executor에서 실행되는 작업은 다른 스레드에서 실행된다.

```java
class ThreadPerTaskExecutor implements Executor {
	public void execute(Runnable r) {
		new Thread(r).start();
	}
}
```

- 하지만 `Executor`의 구현체가 항상 비동기나 다른 스레드로 실행되어야 한다는 제한은 없다.

```java
class DirectExecutor implements Executor {
	public void execute(Runnable r) {
		r.run();
	}
}
```

## Future

- 비동기 작업의 결과를 나타낸다.
- 작업이 완료되었는지 체크하고, 완료될 때 까지 기다리고, 작업의 결과를 조회하는 메서드를 제공한다.
	- `cancel()`, `isCancle()`, `isDone()`, `get()` 메서드 등이 있다.

## ExecutorService

- `Executor` 를 확장한 인터페이스다.
- 비동기 작업의 종료를 관리하는 메서드를 제공한다.
- 비동기 작업의 진행 상태를 추적할 수 있는 `Future`를 생성해주는 메서드를 제공한다.
- `ExecutorService`는 shut down 되면, 새로운 작업을 받지 않는다.
	- `shutdown()` 메서드를 호출하면 종료하기 전에 제출된 작업들이 실행되도록 허용한다.
	- `shutdownNow()` 메서드는 대기 중인 작업이 시작되지 않도록 하고, 현재 실행 중인 작업을 중지하려고 시도한다.
- `submit()` 메서드를 통해 `Executor.execute()`로 실행되는 작업을 취소하고 기다릴 수 있는 `Future` 를 생성한다.

## 참고 자료

- https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html
- https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Executor.html
- https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/concurrent/Future.html
- https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/concurrent/ExecutorService.html
