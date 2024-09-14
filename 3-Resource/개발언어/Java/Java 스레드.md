---
tags:
  - Java
---
# Java 스레드

## 기본 소개

- Java에서는 경합 상태일 때 데이터의 정합성을 보장하기 위해 스레드 동기화로 한 번에 하나의 스레드만 공유 자원에 접근할 수 있도록 한다. 이를 구현하기위해 Java에서는 각 인스턴스들이 자신의 Monitor를 가지게하고, 스레드가 이 인스턴스를 사용할 때 Monitor를 점유하도록 한다. 이 Monitor는 하나의 스레드만 점유할 수 있기때문에, 다른 스레드들은 Wait Queue에서 기다리게 된다. (synchronized 키워드를 사용하면 점유하게된다)
- Java 스레드에는 ‘데몬 스레드(daemon thread)’와 ‘일반 스레드(non-daemon thread)’가 있다.
    - 데몬 스레드: 백그라운드로 실행되고, 일반 스레드가 모두 종료되면 데몬 스레드의 의미가 사라지기 때문에 강제적으로 자동 종료된다. 대표적으로 가비지 컬렉션, 화면 자동갱신 등이 있다.
    - 일반 스레드: 사용자가 직접 생성한 스레드로 대표적으로 `static void main(String[] args)’가 실행되는 스레드가 일반 스레드다.
- 우선순위
    - Java는 스레드 스케줄링에 우선순위 방식과 라운드 로빈 방식을 사용한다. 즉, 우선순위가 높은 스레드가 더 많은 실행을 할 수 있도록 스케줄링한다. 우선순위는 1~10으로 1이 가장 낮은 우선순위고, 10이 가장 높다.

## 구현하기

`Thread` 클래스를 상속해서 실행하는 방법이 있다.

```java
public class NewThread extends Thread {
    public void run() {
        long startTime = System.currentTimeMillis();
        int i = 0;
        while (true) {
            System.out.println(this.getName() + ": New Thread is running..." + i++);
            try {
                //Wait for one sec so it doesn't print too fast
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            ...
        }
    }
}
```

```java
public class SingleThreadExample {
    public static void main(String[] args) {
        NewThread t = new NewThread();
        t.start();
    }
}
```

하지만 이 방법은 스레스 생성과 제거 비용이 상당히 크기 때문에 별도의 스레드풀을 만들어 둬야된다.

```java
ExecutorService executor = Executors.newFixedThreadPool(10);
...
executor.submit(() -> {
    new Task();
});
```

이때, `execute` 메소드는 아무 반환 값이 없고, `submit` 은 실행 결과를 `Future`로 반환한다.