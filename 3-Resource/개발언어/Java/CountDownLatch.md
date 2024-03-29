# CountDownLatch

## 목표

- CountDownLatch가 무엇인지 이해한다.

## CountDonwLatch

- 다른 스레드가 주어진 작업을 완료할 때까지 현재 스레드를 블락하기 위해서 사용할 수 있다.
- `counter` 필드를 가지고 있고, 상황에 따라 이를 감소시킬 수 있다.
- `counter` 필드가 0이 될 때까지, 호출한 스레드에서는 블락된다.

## 예제 코드

- 테스트 코드에서는 `assertThat`을 호출하기 전에 5개의 `Worker` 가 모두 동작이 끝나기를 기다려야된다.
- 테스트 코드에서 `CountDownLatch(5)`로 선언하고, 각 `Worker`에서 1씩 감소시키는 방식으로 대기를 시킨다.

```java
public class Worker implements Runnable {
    private List<String> outputScraper;
    private CountDownLatch countDownLatch;

    public Worker(List<String> outputScraper, CountDownLatch countDownLatch) {
        this.outputScraper = outputScraper;
        this.countDownLatch = countDownLatch;
    }

    @Override
    public void run() {
        doSomeWork();
        outputScraper.add("Counted down");
        countDownLatch.countDown();
    }
}
```

```java
@Test
public void whenParallelProcessing_thenMainThreadWillBlockUntilCompletion()
  throws InterruptedException {

    List<String> outputScraper = Collections.synchronizedList(new ArrayList<>());
    CountDownLatch countDownLatch = new CountDownLatch(5);
    List<Thread> workers = Stream
      .generate(() -> new Thread(new Worker(outputScraper, countDownLatch)))
      .limit(5)
      .collect(toList());

      workers.forEach(Thread::start);
      countDownLatch.await(); 
      outputScraper.add("Latch released");

      assertThat(outputScraper)
        .containsExactly(
          "Counted down",
          "Counted down",
          "Counted down",
          "Counted down",
          "Counted down",
          "Latch released"
        );
    }
```

## 시간 제한 두기

- 위 예시 코드에서 `countDownLatch.await()` 은 영원히 blocking 될 가능성이 있다.
	- `Worker` 에서 `countDownLatch.countDown()` 을 호출하기 전에 예외 발생 등으로 종료되어 버리면, 테스트 코드는 무한정 기다리게 된다.
- 이를 해결하기 위해서 timeout 을 지정하고 기다리게 할 수 있다.

```java
boolean completed = countDownLatch.await(3L, TimeUnit.SECONDS);
assertThat(completed).isFalse();
```

## 참고 자료

- https://www.baeldung.com/java-countdown-latch