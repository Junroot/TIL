---
tags:
  - Spring-Data-Redis
title: Spring redis로 pub sub 구현하기
---


## Redis 의존 추가

```sql
implementation 'org.springframework.boot:spring-boot-starter-data-redis'
```

spring-boot-starter-data-redis 의존을 통해 properties 파일로 설정이 가능하다.

## Bean 생성

```java
@Bean
public RedisTemplate<String, Object> redisTemplate(final RedisConnectionFactory connectionFactory) {
    final RedisTemplate<String, Object> template = new RedisTemplate<>();
    template.setConnectionFactory(connectionFactory);
    template.setKeySerializer(new StringRedisSerializer());
    template.setValueSerializer(new Jackson2JsonRedisSerializer<>(Object.class));

    return template;
}
```

pubish 하기위한 `RedisTemplate`다.

```java
@Bean
RedisMessageListenerContainer redisContainer(final MessageListener messageListener) {
    RedisMessageListenerContainer container = new RedisMessageListenerContainer(); 
    container.setConnectionFactory(jedisConnectionFactory()); 
    container.addMessageListener(messageListener, topic()); 
    return container; 
}
```

메시지 수신에 대한 비동기 처리를 하기위해서는 `RedisMessageListenerContainer` 에 `MessageListener`를 추가하면 된다.

```java
@Override
public void onMessage(final Message message, final byte[] pattern) {
    try {
        EntryResponse response = objectMapper.readValue(message.getBody(), EntryResponse.class);
        messagingTemplate.convertAndSend(String.format("/topic/rooms/%s/users", response.getRoomId()), response.getSessionsResponse());
    } catch (IOException e) {
        throw new BabbleIllegalArgumentException("읽을 수 없는 메시지 형태 입니다.");
    }
}
```

message 처리 내용은 다음과 같이 지정할 수 잇다.

```java
redisTemplate.convertAndSend(topic.getTopic(), message);
```

메시지 전송은 다음과 같이 할 수 잇다.

## 참고 자료

[https://www.baeldung.com/spring-data-redis-properties](https://www.baeldung.com/spring-data-redis-properties)

[https://www.baeldung.com/spring-data-redis-pub-sub](https://www.baeldung.com/spring-data-redis-pub-sub)

[https://daddyprogrammer.org/post/4731/spring-websocket-chatting-server-redis-pub-sub/](https://daddyprogrammer.org/post/4731/spring-websocket-chatting-server-redis-pub-sub/)

[https://wedul.site/696](https://wedul.site/696)
