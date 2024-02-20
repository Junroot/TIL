# KafkaProducer 기본 구성 요소

## 목표

- client에서 KafkaProducer가 메시지지를 produce하는 과정을 이해한다.

## Spring 에서 KafkaTemplate 호출시 동작

- `KafkaTemplate.doSend()` 메서드 호출시 `KafkaProducer.send()` 메서드를 내부에서 호출하고 있다.
- `send()` 메서드 호출 시 파라미터로 전송할 `ProducerRecord`와 `Callback` 파라미터를 넘겨준다.

## KafkaProducer의 기본 구성 요소

- `KafkaProducer`: 사용자가 직접 사용하는 클래스. `send()` 메서드를 호출하면 `Record`를 전송한다.
- `RecordAccumulator`: 사용자가 `KafkaProducer::send()` 메서드를 호출하면 `Record`가 바로 전송되는 것이 아니라 `RecordAccumulator`에 저장된다. 그리고 실제로 Broker에 저장되는 것은 이후에 비동기적으로 이루어진다.
- `Sender`: `KafkaProducer`는 별도의 Sender Thread를 생성한다. Sender Thread는 `RecordAccumulator`에 저장된 `Record`들을 Broker로 전송하는 역할을 한다. 그리고 Broker의 응답을 받아서 사용자가 `Record` 전송 시 설정한 콜백이 있으면 실행하고, Broker로부터 받은 응답 결과를 `Future`를 통해서 사용자에게 전달한다.

![](assets/Pasted%20image%2020240220192544.png)

## 참고 자료

- https://d2.naver.com/helloworld/6560422
- https://serverwizard.tistory.com/274
