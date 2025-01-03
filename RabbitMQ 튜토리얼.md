---
tags:
  - RabbitMQ
title: RabbitMQ 튜토리얼
---


## 용어 정리

- produce: 메시지를 보내는 행위. 메시지를 보내는 프로그램을 producer라고 한다.
- consume: 메시지를 받는 행위. 메시지를 받는 프로그램을 consumer라고 한다.
- queue: 큰 메시지 버퍼. 호스트의 메모리 및 디스크에 의해 제한될 수 있다. 많은 프로듀서가 하나의 큐에 메시지를 보낼 수도 있고, 많은 컨슈머가 하나의 큐에서 받을 수도 있다. 하나의 프로그램이 프로듀서이자 컨슈머 일 수도 있다.

## Java Client 사용해보기

1. 종속성 추가

```xml
<dependency>  
   <groupId>com.rabbitmq</groupId>  
   <artifactId>amqp-client</artifactId>  
   <version>5.16.0</version>  
</dependency>
```

2. Producer
	- `Connection`: 소켓 커넥션의 추상화
	- `Connection`과 `Channel`은 `Autoclosable`의 구현체
	- `channel.queueDeclare()`: 큐를 선언한다. 이 함수는 멱등성을 가지기 때문에 존재하지 않는 경우에만 새로 생성된다.
	- 메시지는 byte array이므로 원하는대로 인코딩하면 된다.

```java
ConnectionFactory factory = new ConnectionFactory();
factory.setHost("localhost");
try (Connection connection = factory.newConnection();
     Channel channel = connection.createChannel()) {
	String QUEUE_NAME = "hello";
	channel.queueDeclare(QUEUE_NAME, false, false, false, null);
	String message = "Hello World!";
	channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
	System.out.println(" [x] Sent '" + message + "'");
}
```

3. Consumer
	- consumer는 비동기적으로 메시지가 도착할 때까지 기다리는 동안 프로세스가 유지되기를 원하기 때문에 try-with-resource를 사용하지 않는다.
	- `DeliverCallback`: 큐에서 메시지가 전송되면 비동기적으로 처리되기 때문에 콜백 인터페이스로 메시지를 받았을 때의 동작을 구현한다.

```java
ConnectionFactory factory = new ConnectionFactory();
factory.setHost("localhost");
Connection connection = factory.newConnection();
Channel channel = connection.createChannel();

channel.queueDeclare(QUEUE_NAME, false, false, false, null);
System.out.println(" [*] Waiting for messages. To exit press CTRL+C");
DeliverCallback deliverCallback = (consumerTag, delivery) -> {
    String message = new String(delivery.getBody(), "UTF-8");
    System.out.println(" [x] Received '" + message + "'");
};
channel.basicConsume(QUEUE_NAME, true, deliverCallback, consumerTag -> { });
```

## Work Queues

- Work Queues(또는 Task Queues)라는 에제를 통해 RabbitMQ의 특징을 알아본다.
- Work Queues: 리소스를 많이 사용하는 작업을 즉시 수행하지 않고, 작업이 완료되기 까지 대기하는 것을 방지하기 위해 작업들을 담아두는 큐. 
	- 백그라운드에서 Worker 프로세스가 큐에서 pop하여 작업을 수행한다.
	- 한 번에 여러개의 Worker 프로세스를 둬서 병렬적으로 처리할 수도 있다.

![](assets/Pasted%20image%2020230309144227.png)

### 준비

- 리소스가 많은 작업처럼 보이기 위해서 `Thread.sleep()`을 사용한다.
- `Consumer.kt` (Worker 역할): 메시지를 받으면 메시지에 포함된 `.` 문자의 개수만큼 sleep 된다. 
	- `autoAck` 은 아래에서 다룸

```kotlin
fun main() {  
   val queueName = "task_queue"  
   val factory = ConnectionFactory()  
   factory.host = "localhost"  
   val connection = factory.newConnection()  
   val channel = connection.createChannel()  
  
   val durable = true // 아래에서 다룸  
   channel.queueDeclare(queueName, durable, false, false, null)  
   channel.basicQos(1) // 아래에서 다룸  
   println(" [*] Waiting for messages. To exit press CTRL+C")  
   val deliverCallback = DeliverCallback { consumerTag: String?, delivery: Delivery ->  
      val message = String(delivery.body, Charsets.UTF_8)  
      try {  
         doWork(message)  
      } finally {  
         println(" [x] Received '$message'")  
      }  
   }  
   val autoAck = true // 아래에서 다룸  
   channel.basicConsume(queueName, autoAck, deliverCallback) { consumerTag -> }  
}  
  
fun doWork(task: String) {  
   for (ch in task.toCharArray()) {  
      if (ch == '.') {  
         Thread.sleep(1000)  
      }  
   }  
}
```

- `Producer.kt`: 문자열을 큐에 메시지로 보낸다.

```kotlin
fun main(args: Array<String>) {  
   val queueName = "taks_queue"  
   val message = args.joinToString(" ")  
   val factory = ConnectionFactory()  
   factory.host = "localhost"  
   factory.newConnection().use { connection ->  
      connection.createChannel().use { channel ->  
         val durable = true // 아래에서 다룸  
         channel.queueDeclare(queueName, durable, false, false, null)  
         channel.basicPublish(
	        "",  
            queueName,  
            MessageProperties.PERSISTENT_BASIC,  
            message.toByteArray()  
         )  
         println(" [x] Sent '$message'")  
      }  
   }
}
```

### 라운드로빈 dispatching

- RabbitMQ에서 consumer를 여러개 둘 수 있다는 점을 이용해서, worker들이 병렬적으로 task를 처리할 수 있다.
- RabbitMQ는 기본적으로 consumer들에게 라운드 로빈 방식으로 메시지를 보낸다.
- 아래는 consumer 2개, producer 1개를 실행한 결과다.
- consumer 1

```shell
$java -cp kotlin-playground-1.0-SNAPSHOT.jar ConsumerKt
 [*] Waiting for messages. To exit press CTRL+C
 [x] Received 'message1.'
 [x] Received 'message3...'
 [x] Received 'message5.....'
```

- consumer 2

```shell
$java -cp target/kotlin-playground-1.0-SNAPSHOT.jar ConsumerKt 
 [*] Waiting for messages. To exit press CTRL+C
 [x] Received 'message2..'
 [x] Received 'message4....'
```

- producer

```shell
$java -cp target/kotlin-playground-1.0-SNAPSHOT.jar ProducerKt "message1."
 [x] Sent 'message1.'
$java -cp target/kotlin-playground-1.0-SNAPSHOT.jar ProducerKt "message2.."
 [x] Sent 'message2..'
$java -cp target/kotlin-playground-1.0-SNAPSHOT.jar ProducerKt "message3..."
 [x] Sent 'message3...'
$java -cp target/kotlin-playground-1.0-SNAPSHOT.jar ProducerKt "message4...."
 [x] Sent 'message4....'
$java -cp target/kotlin-playground-1.0-SNAPSHOT.jar ProducerKt "message5....."
 [x] Sent 'message5.....'
```

### Message acknowledgment

- 하나의 컨슈머가 메시지를 받아서 작업을 수행하다가 죽어버리면, 그 작업은 완료하지 못 했으므로 큐에 유지되어야한다.
- 이런 상황을 대비해서 RabbitMQ에서는 컨슈머가 메시지 처리를 무사히 완료했으면 ack을 보내도록 하고 있다.
- 기본적으로 코드를 통해 수동으로 ack을 보내야된다.
- timeout(기본값은 30분)이 발생하면, ack이 도착하지 않은 메시지는 제대로 처리하지 못한 것으로 간주하고 메시지 큐에 유지한다.
- `channel.basicConsume()` 함수에 `autoAck` 옵션이 존재한다. 이 값이 `true` 면, 메시지를 소비하는 순간에 ack이 보내져서 실제로 작업을 완료하지 못해도 큐에서 메시지가 사라질 수 있다.

### Message durability(영속성)

- RabbitMQ 서버가 중간에 멈춰버리면 모든 메시지를 잃어버릴 수 있다.
- 메시지 큐를 선언할 때 `durable` 속성을 `true`로 주면, 해당 큐는 영속성을 가지게 된다.
	- 이미 존재했던 큐에 대해서는 `durable` 속성을 바꿀 수 없다.

```kotlin
val durable = true  
channel.queueDeclare(queueName, durable, false, false, null)
```

- 이후에 메시지를 publish 할 때 `MessageProperties` 를 `PERSISTENT_TEXT_PLAIN` 로 설정해주면 메시지가 영속성을 가진다는 것을 표시한다.

```kotlin
channel.basicPublish("",  
   queueName,  
   MessageProperties.PERSISTENT_BASIC,  
   message.toByteArray()  
)
```

- 하지만 이는 모든 메시지가 손실되지 않는다고 보장하는 것은 아니다. 
	- RabbitMQ가 메시지를 받고 디스크에 저장하기까지 짧은 시간이 존재한다.
	- RabbitMQ가 모든 메시지에 대해 `fsync(2)`를 실행하지 않으며, 캐시에만 저장되고 실제로 디스크에 기록되지 않을 수 있다.

### Fair dispatch

- 아직 컨슈머가 메시지를 균등하게 처리하지 못한다.
- 첫번째 컨슈머가 작업을 끝냈고 두번째 컨슈머가 작업을 진행중인데, 다음 컨슈머 대상이 두번째면 첫번째 컨슈머가 쉬고 있는 상태에서도 두번째 컨슈머에게 메시지를 보낸다.
- `basicQos()` 메소드를 통해 컨슈머가 한 번에 받을 수 있는 메시지의 개수를 제한할 수 있다.

```kotlin
channel.basicQos(1)
```

## Publish/Subscribe

### Exchanges

![](assets/Pasted%20image%2020230309154114.png)

- RabbitMQ 메시지 모델의 핵심 아이디어는 프로듀서가 메시지를 큐에 직접 보내지 않는 것이다. 실제로 프로듀서는 메시지가 어떤 큐에 전달될지 전혀 알지 못하는 경우가 많다.
- 프로듀서는 exchange으로만 메시지를 보낼 수 있다.
- exchange는 프로듀서로부터 메시지를 수신하고, 큐에 메시지를 push한다.
- exchange 종류
	- direct: 라우팅 키와 바인딩 키가 정확히 일치한 큐에 binding하여 라우팅 된다.
	- topic: 라우팅 키를 기반으로 패턴이 일치하는 큐들로 binding하여 라우팅 된다.
	- headers: headers 테이블을 사용해 특정한 규칭의 라우팅을 처리한다.(별도 학습 필요)
	- fanout: binding되어있는 큐들에게 브로드캐스트된다. 라우팅 키를 계산할 필요가 없어서 성능적인 이점이 있다.
- 아래는 `logs`라는 이름의 exchange를 만든다.

```kotlin
channel.exchangeDeclare("logs", "fanout")
```

- 아래는 `logs`라는 exchange를 통해 메시지를 publish 하는 방법이다.

```kotlin
channel.basicPublish("logs", "", null, message.getBytes())
```

- 이전에는 첫번째 파라미터로 빈 문자열을 넣었는데, 이 경우는 default exchange(direct)를 사용한다. 
	- 두 번째 파라미터가 라우팅 키를 의미한다.

```kotlin
channel.basicPublish("", "hello", null, message.getBytes());
```

### Temporary queues

- `queueDeclare()` 메소드에서 파라미터가 없으면 임시 큐를 만들어준다.
	- 영속성이 없다.
	- 큐 이름은 다음과 같이 랜덤으로 나온다. `amq.gen-JzTY20BRgKO-HjmUJj0wLg`

```kotlin
val queuename:String = channel.queueDeclare().getQueue()
```

- fanout exchange를 사용할 때, binding할 큐를 지정할 수 있다.
	- publish는 프로듀서에서 진행하고, exhange와 queue 사이의 binding은 컨슈머에서 진행된다.

```kotlin
channel.queueBind(queueName, "logs", "")
```

## Routing

### Bindings

- binding은 exchange와 queue 사이의 관계다. 
- `queueBind()`를 호출할 때 3가지 파라미터를 넘겨준다.
	- queue 이름
	- exchange 이름
	- 바인딩 키: exchange 가 fanout 타입일 경우 바인딩 키는 무시된다.

```java
channel.queueBind(queueName, EXCHANGE_NAME, routingKey);
```

### Multiple bindings

- `direct` exchange에서 같은 라우팅 키를 여러 큐에 바인딩하는 것도 가능하다.

![](assets/Pasted%20image%2020230328181511.png)

## Topics

### Topic exchange

- topic은 점으로 구분된 단어의 리스트 형식으로 라우팅 라우팅 키가 표현된다.
	- `stock.usd.nysd`, `nyse.vmw` 등
- 바인딩 키는 두 가지 특수 문자가 존재한다.
	- `*`: 정확히 한 단어를 대체한다.
	- `#`: 0개 이상의 단어를 대체한다.

![](assets/Pasted%20image%2020230328183539.png)

- 위 예시의 경우 
	- `quick.ornage.rabbit`은 두 큐로 전송된다.
	- `quick.orange.fox`는 Q1로 전송된다.
	- `lazy.brown.rabbit`은 Q2로 한번만 전송된다.

## Remote procedure call(RPC)

### Callback queue

- rabbitMQ로 RPC를 구현하기 위해서는 메시지로 요청을 보낼 때, 콜백 큐를 보내야된다.
- `channel.basicPublish()`로 메시지를 보낼 때, 메시지의 프로퍼티를 함께 보낼 수 있다.
- AMQP 0-9-1 프로토콜에서는 14가지의 프로퍼티가 존재한다.
	- `deliveryMode`: 2로 설정하면 영속 상태, 나머지 값은 일시적인 상태가 된다.
	- `contentType`: 인코딩된 mime-type을 표현한다. 예) `application/json`
	- `replyTo`: 일반적으로 콜백 큐의 이름을 작성한다.
	- `correlationId`: RPC 요청과 응답의 연관관계를 표현할 때 사용한다.

### Correlation Id

- 일반적으로 클라이언트당 하나의 콜백 큐가 있는 것이 좋다.
- 그러면 해당 대기열에서 응답을 받으면 해당 응답이 어떤 요청에 속하는지 명확하지 않다.
- `correlationId` 프로퍼티를 사용해서 어떤 요청에 속하는지 구분할 수 있게 된다.

![](assets/Pasted%20image%2020230329155401.png)

### 코드

- client

```kotlin
fun main() {  
   val rpcClient = RPCClient()  
   rpcClient.use {  
      for (i in 0..32) {  
         println(" [x] Requesting fib($i)")  
         val response = rpcClient.call(i.toString())  
         println(" [.] Got '${response}'")  
      }  
   }  
}  
  
class RPCClient : AutoCloseable {  
   private val connection: Connection  
   private val channel: Channel  
   private val requestQueueName = "rpc_queue"  
   private val replyQueueName = "reply_queue"  
  
   init {  
      val factory = ConnectionFactory()  
      factory.host = "localhost"  
  
      connection = factory.newConnection()  
      channel = connection.createChannel()  
      channel.queueDeclare(replyQueueName, false, false, false, null)  
   }  
  
   fun call(message: String): String {  
      val correlationId = UUID.randomUUID().toString()  
  
      val props = BasicProperties.Builder()  
         .correlationId(correlationId)  
         .replyTo(replyQueueName)  
         .build()  
  
      channel.basicPublish("", requestQueueName, props, message.toByteArray(Charsets.UTF_8))  
  
      val response = CompletableFuture<String>()  
  
      val ctag = channel.basicConsume(  
         replyQueueName,  
         true,  
         { _, delivery ->  
            if (delivery.properties.correlationId.equals(correlationId)) {  
               response.complete(String(delivery.body, Charsets.UTF_8))  
            }  
         },  
         { _: String -> }  
      )  
  
      val result = response.get()  
      channel.basicCancel(ctag)  
      return result  
   }  
  
   override fun close() {  
      connection.close()  
   }  
}
```

- server

```kotlin
val rpcQueueName = "rpc_queue"  
  
fun main() {  
   val factory = ConnectionFactory().apply {  
      host = "localhost"  
   }  
   val connection = factory.newConnection()  
   val channel = connection.createChannel()  
   channel.queueDeclare(rpcQueueName, false, false, false, null)  
   channel.queuePurge(rpcQueueName)  
  
   channel.basicQos(1)  
  
   println(" [x] Awaiting RPC requests")  
  
   val deliverCallback = DeliverCallback{ _, delivery ->  
      val replyProps = BasicProperties.Builder()  
         .correlationId(delivery.properties.correlationId)  
         .build()  
  
      val request = String(delivery.body, Charsets.UTF_8).toInt()  
      val response = RPCServer.fib(request)  
      println(" [.] Sending '${request}' -> ${response}'")  
      channel.basicPublish("", delivery.properties.replyTo, replyProps, response.toString().toByteArray(Charsets.UTF_8))  
      channel.basicAck(delivery.envelope.deliveryTag, false)  
   }  
  
   channel.basicConsume(rpcQueueName, false, deliverCallback) { _ -> }  
}  
  
class RPCServer {  
  
   companion object {  
      fun fib(n: Int): Int {  
         if (n == 0) return 0  
         if (n == 1) return 1  
         return fib(n - 1) + fib(n - 2)  
      }  
   }  
}
```

## Publisher Confirms

- publisher confirms를 통해 publish한 메시지가 브로커에 안전하게 도달했는지 확인하는 방법을 살펴본다.

### 채널에서 Publisher Confirms 활성화

- Publisher confirms는 AMQP 0.9.1 프로토콜에대한 RabbitMQ의 확장이다.
- 기본적으로 비활성화되어 있고, `confirmSelect` 메소드를 통해 활성화 시켜줘야된다.
- publisher confirms을 활성화하면, 클라이언트가 publish하는 메시지가 브로커에의해 비동기적으로 confirm된다.

```java
Channel channel = connection.createChannel();
channel.confirmSelect();
```

### 전략 1: 메시지 하나씩 publish

```java
while (thereAreMessagesToPublish()) {
    byte[] body = ...;
    BasicProperties properties = ...;
    channel.basicPublish(exchange, queue, properties, body);
    // uses a 5 second timeout
    channel.waitForConfirmsOrDie(5_000);
}
```

- `channel.waitForConfirmsOrDie(long)` 메소드는 메시지가 confirm 되자마자 리턴된다. 
- 타임아웃이 발생하거나 nack이 될 경우 예외를 던진다.
- 이 방식은 메시지는 하나의 메시지가 confirm 되기까지 다른 메시지를 블락킹되므로 상당히 느리다.

### 전략2: batch로 메시지 publish

```java
int batchSize = 100;
int outstandingMessageCount = 0;
while (thereAreMessagesToPublish()) {
    byte[] body = ...;
    BasicProperties properties = ...;
    channel.basicPublish(exchange, queue, properties, body);
    outstandingMessageCount++;
    if (outstandingMessageCount == batchSize) {
        channel.waitForConfirmsOrDie(5_000);
        outstandingMessageCount = 0;
    }
}
if (outstandingMessageCount > 0) {
    channel.waitForConfirmsOrDie(5_000);
}
```

- 여전히 동기식이지만, 전략1보다는 빠르다.
- 메시지가 실패하면 어떤 메시지의 실패인지 구분할 수 없다.

### 전략3: 비동기적으로 publisher confirm 처리

```java
Channel channel = connection.createChannel();
channel.confirmSelect();
channel.addConfirmListener((sequenceNumber, multiple) -> {
    // code when message is confirmed
}, (sequenceNumber, multiple) -> {
    // code when message is nack-ed
});
```

- 각 콜백에는 2개의 파라미터가 있다.
	- `sequenceNumber`: confirm되었거나 nack된 메시지의 id. 
	- `multiple`: 메시지가 1개면 `false`, 2개 이상이면 `true`
- publish하기전에 `Channel.getNextPublishSeqNo()` 메서드로 메시지의 sequecne number를 확인할 수 있다.

```java
int sequenceNumber = channel.getNextPublishSeqNo());
ch.basicPublish(exchange, queue, properties, body);
```

## 참고 자료

- https://www.rabbitmq.com/tutorials/tutorial-one-java.html
- https://www.rabbitmq.com/tutorials/tutorial-two-java.html
- https://www.rabbitmq.com/tutorials/tutorial-three-java.html
- https://rabbitmq.com/tutorials/tutorial-four-python.html
- https://rabbitmq.com/tutorials/tutorial-five-java.html
- https://rabbitmq.com/tutorials/tutorial-six-java.html
- https://rabbitmq.com/tutorials/tutorial-seven-java.html
