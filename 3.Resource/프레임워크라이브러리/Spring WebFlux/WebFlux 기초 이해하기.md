# WebFlux 기초 이해하기

## 목표

- 리액티브 프로그래밍을 이해한다.
- Spring WebFlux 내부 동작 방식을 이해한다.

## 리액티브 프로그래밍

### 리액티브 프로그래밍

- 비동기 이벤트 처리와 데이터 스트림에 대한 아이디어를 기반으로 한다.
- 비동기 이벤트 처리는 다른 이벤트 처리를 차단하지 않는다는 것을 의미한다.
- 이벤트 큐와 병렬 이벤트 처리를 도입하여 성능과 확장성을 향상시킨다.
- 기본적으로 리액티브 프로그래밍은 3가지 구성요소를 가진 옵저버 패턴이다.(RxJava 기준)
	- `Observable`: 데이터 스트림을 표현한다. 한 스레드에서 다른 스레드로 전달할 수 있는 데이터를 담는다.
	- `Observer`: `Observable`이 방출하는 데이터 스트림을 소비한다. `Observable`이 데이터를 방출할 때마다 데이터를 통해 작업을 수행하거나 예외를 던진다.
	- `Scheduler`: `Observable`과 `Observer`가 어떤 스레드에서 실행해야할지 알려주는 구성요소다.

### 리액티브 스트림

- 위 3가지 구성요소를 가진 방식에는 문제점이 있다.
	- `Observable`에 발생 시키는 이벤트의 수나 타이밍을 제어할 수 없기 때문에, 예측할 수 없는 부하를 관리할 수 없다.
- 리액티브 스트림은 non-blocking backpressure를 사용해서 위 문제를 해결한 표준을 제공한다.
- 리액티브 스트림은 4개의 인터페이스인 `Publisher`, `Subscriber`, `Subscription`, `Processor`로 요약할 수 있다.
- `Publisher`는 하나의 `Subscription`당 하나의 `Subscriber`에 발행하는 데이터는 생성한다.
- `Publisher` 인터페이스에는 `Subscriber`가 `Publisher`를 구독 신청할 수 있는 `subscribe()` 메서드 한 개가 선언되어 있다.
	- ![](assets/Pasted%20image%2020231019210802.png)
- `Subscriber`가 구독 신청되면 `Publisher`로부터 이벤트를 수신할 수 있다.
	- `Subscriber`가 수신할 첫 번째 이벤트는 `onSubsribe()` 호출을 통해 이루어진다.
	- `Publisher`가 `onSubsribe()`를 호출할 때 이 메서드의 인자로 `Subscription` 객체를 `Subscriber`에 전달한다.
	- `Subscriber`는 `Subscription` 객체를 통해서 구독을 관리할 수 있다.
	- ![](assets/Pasted%20image%2020231019210816.png)
- `Subscriber`는 `Subscription`의 `request()`를 호출하여 전송되는 데이터를 요청하거나, 또는 더 이상 데이터를 수신하지 않고 취소한다는 것을 나타내기 위해 `cancel()`을 호출할 수 있다.
	- `request()`를 호출할 때 `Subscriber`는 받고자 하는 데이터 항목 수를 나타내는 `long` 타입의 값을 인자로 전달한다. 바로 이것이 ***백 프레셔***이며, `Subscriber`가 처리할 수 있는 것보다 더 많은 데이터를 `Publisher`가 전송하는 것을 막아준다.
	- 요청된 수의 데이터를 `Publisher`가 전송한 후에 `Subscriber`는 다시 `request()`를 호출하여 더 많은 요청을 할 수 있다.
	- ![](assets/Pasted%20image%2020231019210829.png)
- `Subscriber`의 데이터 요청이 완료되면 데이터가 스트림을 통해 전달되기 시작한다. 이 때 `onNext()` 메서드가 호출되어 `Publisher`가 전송하는 데이터가 `Subscriber`에게 전달되며, 만일 에러가 생길 떄는 `onError()`가 호출된다.
- `Publisher`에서 전송할 데이터가 없고 더 이상의 데이터를 생성하지 않는다면 `Publisher`가 `onComplete()`를 호출하여 작업이 끝났다고 `Subscriber`에게 알려준다.
- `Processor` 인터페이스는 `Subscriber` 인터페이스와 `Publisher` 인터페이스를 결합한 것이다.
	- `Subscriber` 역할로 `Processor`는 데이터를 수신하고 처리한다. 그다음에 역할을 바꾸어 `Publisher` 역할로 처리 결과를 자신의 `Subscriber` 들에게 발행한다.
	- ![](assets/Pasted%20image%2020231019210839.png)
- 리액티브 스트림의 구현체로 RxJava, Reactor 등이 존재한다.
	- Reactor의 `Flux`, `Mono`가 `Publisher` 인터페이스의 구현체다.

## 참고 자료

- https://www.baeldung.com/cs/reactive-programming
- https://medium.com/@kevalpatel2106/what-is-reactive-programming-da37c1611382
- https://stackoverflow.com/questions/34387153/whats-the-difference-between-reactive-and-reactive-streams
- https://www.codemotion.com/magazine/backend/benefits-of-reactive-programming-codemotion-magazine/