---
tags:
  - Spring-MVC
---
# Spring으로 WebSocket 시작하기

## Spring으로 WebSocket 시작하기(STOMP)

### Maven 의존성 추가

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-websocket</artifactId>
    <version>5.2.2.RELEASE</version>
</dependency>

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-messaging</artifactId>
    <version>5.2.2.RELEASE</version>
</dependency>
```

최신 버전은 [여기서](https://mvnrepository.com/)

또한 JSON 사용하여 메시지를 전달 하려면 Jackson 의존을 추가해야된다. Spring Boot의 경우에는 추가할 필요 없을 것으루 추정된다.

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-core</artifactId>
    <version>2.10.2</version>
</dependency>

<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId> 
    <version>2.10.2</version>
</dependency>
```

### Spring에서 WebSocket 활성화

`AbstractWebSocketMessageBrokerConfigurer` 클래스를 상속하고 `@EnableWebSocketMessageBroker` 어노테이션을 붙여준다.

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig extends AbstractWebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
         registry.addEndpoint("/chat");
         registry.addEndpoint("/chat").withSockJS();
    }
}
```

- `enableSimpleBroker()`: 클라이언트가 서버로부터 메시지를 받기위한 URL의 prefix 설정
- `setApplicationDestinationPrefixes()`: 클라이언트가 서버에게 메시지를 보내기 위한 URL의 prefix 설정
- `addEndpoint()`: 클라이언트와 서버가 connection(handshake)을 만들기 위한 endpoint 설정. `/app`으로 시작하는 URL의 요청은 `@Controller` 클래스의 `@MessageMapping` 메소드로 전달된다.
- `withSocketJS()`: SockJS fallback options 을 가능하게 해주는 설정.

<aside>
💡 fallback이란: 어떤 기능이 제대로 동작하지 않을 경우, 대처해주는 기능
STOMP란: WebSocket은 양방향 통신 프로토콜일 뿐, 메시지의 형식과 규칙을 정의하지는 않는다. STOMP는 이 메시지 형식과 규칙을 정의하는 프로토콜이다.

</aside>

### 메시지 DTO 만들기

```java
public class Message {

    private String from;
    private String text;

    // getters and setters
}
```

### 메시지 컨트롤러 만들기

```java
@MessageMapping("/chat")
@SendTo("/topic/messages")
public OutputMessage send(Message message) throws Exception {
    String time = new SimpleDateFormat("HH:mm").format(new Date());
    return new OutputMessage(message.getFrom(), message.getText(), time);
}
```

- `@MessageMapping("/chat")`: connection을 위한 엔드포인트 지정
- `@SendTo("/topic/messages")`: 메시지를 보낼 URL 지정

### 클라이언트 사용 예시

```html
<html>
    <head>
        <title>Chat WebSocket</title>
        <script src="resources/js/sockjs-0.3.4.js"></script>
        <script src="resources/js/stomp.js"></script>
        <script type="text/javascript">
            var stompClient = null;
            
            function setConnected(connected) {
                document.getElementById('connect').disabled = connected;
                document.getElementById('disconnect').disabled = !connected;
                document.getElementById('conversationDiv').style.visibility 
                  = connected ? 'visible' : 'hidden';
                document.getElementById('response').innerHTML = '';
            }
            
            function connect() {
                var socket = new SockJS('/chat');
                stompClient = Stomp.over(socket);  
                stompClient.connect({}, function(frame) {
                    setConnected(true);
                    console.log('Connected: ' + frame);
                    stompClient.subscribe('/topic/messages', function(messageOutput) {
                        showMessageOutput(JSON.parse(messageOutput.body));
                    });
                });
            }
            
            function disconnect() {
                if(stompClient != null) {
                    stompClient.disconnect();
                }
                setConnected(false);
                console.log("Disconnected");
            }
            
            function sendMessage() {
                var from = document.getElementById('from').value;
                var text = document.getElementById('text').value;
                stompClient.send("/app/chat", {}, 
                  JSON.stringify({'from':from, 'text':text}));
            }
            
            function showMessageOutput(messageOutput) {
                var response = document.getElementById('response');
                var p = document.createElement('p');
                p.style.wordWrap = 'break-word';
                p.appendChild(document.createTextNode(messageOutput.from + ": " 
                  + messageOutput.text + " (" + messageOutput.time + ")"));
                response.appendChild(p);
            }
        </script>
    </head>
    <body onload="disconnect()">
        <div>
            <div>
                <input type="text" id="from" placeholder="Choose a nickname"/>
            </div>
            <br />
            <div>
                <button id="connect" onclick="connect();">Connect</button>
                <button id="disconnect" disabled="disabled" onclick="disconnect();">
                    Disconnect
                </button>
            </div>
            <br />
            <div id="conversationDiv">
                <input type="text" id="text" placeholder="Write a message..."/>
                <button id="sendMessage" onclick="sendMessage();">Send</button>
                <p id="response"></p>
            </div>
        </div>

    </body>
</html>
```

## 참고 자료

[https://www.baeldung.com/websockets-spring](https://www.baeldung.com/websockets-spring)

[https://www.section.io/engineering-education/getting-started-with-spring-websockets/](https://www.section.io/engineering-education/getting-started-with-spring-websockets/)

[https://ratseno.tistory.com/71](https://ratseno.tistory.com/71)

[https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#websocket-stomp](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#websocket-stomp)

---

## Spring으로 WebSocket 시작하기

### Websocket Handler 작성

웹소켓 서버는 `WebSocketHandler` 를 구현하거나 `TextWebSocketHandler`나 `BinaryWebSocketHandler`를 상속함으로써 만들 수 있다.

```java
public class WebSockChatHandler extends TextWebSocketHandler {

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        log.info("payload {}", payload);
        TextMessage textMessage = new TextMessage("Welcome chatting sever~^^");
        session.sendMessage(textMessage);
    }
}
```

### Websocket Config 작성

위에서 작성한 Websocket Handler를 URL 매핑을 하기위해서는 `WebSocketConfig` 를 구현하면된다.

```java
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(webSocketHandler(), "/ws/chat").setAllowedOrigins("*");
    }

    @Bean
    public WebSocketHandler webSocketHandler(){
        return new WebSocketHandler();
    }
}
```

STOMP를 사용하는 것은 `WebSocketHandler`를 간접적으로 사용하는 것이다.

### STOMP가 더 좋다고 생각하는 개인적인 이유

- session을 직접 관리할 필요가 없다.
- 반환값을 사용자가 만든 DTO를 사용할 수 있다. 알아서 직렬화, 역직렬화 해준다.
- 메시지를 라우팅할 경로 쉽게 지정할 수 있다. ([https://stackoverflow.com/questions/42901062/spring-websockets-without-stomp-and-sockjs-but-with-message-broker-and-routing-s](https://stackoverflow.com/questions/42901062/spring-websockets-without-stomp-and-sockjs-but-with-message-broker-and-routing-s))

## 참고자료

[https://daddyprogrammer.org/post/4077/spring-websocket-chatting/](https://daddyprogrammer.org/post/4077/spring-websocket-chatting/)

[https://velog.io/@hanblueblue/번역-Spring-4-Spring-WebSocket](https://velog.io/@hanblueblue/%EB%B2%88%EC%97%AD-Spring-4-Spring-WebSocket)