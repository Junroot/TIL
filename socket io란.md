---
tags:
  - Nodejs
title: socket io란
---


## socket.io란?

- WebSocket 등으로 양방향 통신을 가능하게 해주는 라이브러리다.
- 2가지 주요 기능으로 분류할 수 있다.
    - Node.js 서버를 위한 라이브러리
    - 클라이언트의 JavaScript 라이브러리
- socket.io는 JavaScript뿐만아니라 Java, C++, Swift 등의 다양한 언어를 지원해준다.

## socket.io의 주요 기능

- HTTP long-polling fallback: 브라우저가 WebSocket 연결에 실패할 경우 long polling 방식으로 통신을 하도록 만들어준다.
- Automatic reconnection: heartbeat 매커니즘으로 연결 상태를 확인하고, 연결이 끊겼을 때 자동으로 재연결한다.
- Broadcasting: 서버에서 연결되어 있는 모든 클라이언트에게 이벤드를 보낼 수 있다.

## 기본 API

- 3000번 포트를 사용하는 Node.js HTTP 서버에 [socket.io](http://socket.io/) 연결한다.
    - express는 Node.js에서 사용하는 웹 프레임워크다.

```jsx
const app = require('express')();
const server = require('http').createServer(app); // express를
const io = require('socket.io')(server);

server.listen(3000);
```

- 클라이언트와 서버에서 connection을 생성한다.

```jsx
io.on('connection', (socket) => {
  console.log('a user connected');
});

```

- disconnect에 대한 처리는 아래와 같이할 수 있다.

```jsx
io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
});

```

- socket.io의 특징인 이벤트 발생이다. 모든 사람에게 이벤트를 발생시킨다. 이벤트를 보낼 때 아래와 같이 임의의 메시지도 함께 보낼 수 있다.

```jsx
io.emit('some event', { someProperty: 'some value', otherProperty: 'other value' }); // This will emit the event to all connected sockets
```

- 특정 소켓을 제외하고 나머지에게 이벤트를 보낼 수도 있다.

```jsx
io.on('connection', (socket) => {
  socket.broadcast.emit('hi');
});
```

## 참고 자료

[https://jangstory.tistory.com/12](https://jangstory.tistory.com/12)[https://socket.io/get-started/chat](https://socket.io/get-started/chat)[https://socket.io/docs/v4/](https://socket.io/docs/v4/)
