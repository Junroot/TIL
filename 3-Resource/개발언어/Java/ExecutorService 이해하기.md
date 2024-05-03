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

![](assets/Pasted%20image%2020240411180119.png)

- `Executor` 를 확장한 인터페이스다.
- 비동기 작업의 종료를 관리하는 메서드를 제공한다.

### 인스턴스화 방법 

1. `Executors` 클래스의 팩토리 메서드 사용방법
	- 예시: `ExecutorService executor = Executors.newFixedThreadPool(10)`
	- 위 예시는 고정된 개수의 스레드 풀을 만들어서 사용한다.
	- 모든 스레드가 사용되고 있으면, 사용 가능한 스레드가 있을 때까지 큐에 넣고 대기한다.
2. 다른 구현체로 생성하는 방법
	- 대표적으로 `ThreadPoolExecutor` 가 있다.

### 태스크 실행

- `ExecutorService`는 `Runnable`과 `Callable`을 실행할 수 있다.
- 아래와 같은 코드가 있다고 가정한다.

```java
Runnable runnableTask = () -> {
    try {
        TimeUnit.MILLISECONDS.sleep(300);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
};

Callable<String> callableTask = () -> {
    TimeUnit.MILLISECONDS.sleep(300);
    return "Task's execution";
};

List<Callable<String>> callableTasks = new ArrayList<>();
callableTasks.add(callableTask);
callableTasks.add(callableTask);
callableTasks.add(callableTask);
```

- `execute()` 메서드는 `void` 리턴을 가진다.
	- `executorService.execute(runnableTask)`
- `submit()` 메서드는 `Future` 리턴을 가진다.
	- `Future<String> future = executorService.submit(callableTask)`
- `invokeAny()` 메서드는 태스크의 컬렉션을 실행시키고, 성공한 태스크 중 하나의 결과를 리턴한다.
	- `String result = executorService.invokeAny(callableTasks)`
- `invokeAll()` 메서드는 태스크의 컬렉션을 실행시키고, 모든 태스크에 대한 `Future` 컬렉션을 리턴한다.
	- `List<Future<String>> futures = executorService.invokeAll(callableTasks)`

### shutdown

- `ExecutorService`는 shutdown 하기 전까지 계속 JVM에서 실행되고 있다.
- `shutdown()` 메서드를 호출하면 종료하기 전에 제출된 작업들이 실행되도록 허용한다.
- `shutdownNow()` 메서드는 대기 중인 작업이 시작되지 않도록 하고, 현재 실행 중인 작업을 중지하려고 시도한다.

## ScheduledExecutorService

- 태스크를 고정된 지연이나 주기 이후에 실행하는 인터페이스
- `Executors`의 팩토리 메서드로 인스턴스화 가능하다.
	- `ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor()`
- 고정된 지연후에 실행하려면 `schedule()` 메서드를 호출하면 된다.
- 고정된 주기로 태스크를 실행하려면 `scheduleAtFixedRate()` 메서드를 호출하면 된다.
	- 이 때 할당된 태스크의 실행 시간이 주기보다 길면, 현재 태스크가 완료될 때 까지 다음 태스크는 기다린다.
- 앞 태스크가 끝난 시점과 지정한 태스크의 시작 시점 사이에 딜레이를 주고 싶다면 `scheduleWIthFixedDelay()` 메서드를 호출하면 된다.

## 참고 자료

- https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html
- https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Executor.html
- https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/concurrent/Future.html
- https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/concurrent/ExecutorService.html
- https://www.baeldung.com/java-executor-service-tutorial
