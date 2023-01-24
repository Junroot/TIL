# TCP 연결 종료는 연결 요청과 다르게 4-way 핸드셰이크인 이유

연결 과정에서는 3-way 핸드셰이크인데, 연결 종료시에는 왜 비효율적으로 4-way로 동작하는지 의문이 들었다. 

그 이유는 클라이언트가 서버에게 연결 종료 요청을 해도 서버는 클라이언트에게 보내야될 데이터가 남아 있을 수 있기 때문이다. 4-way 핸드셰이크의 과정을 상세히 적게된다면 아래와 같다.

1. 클라이언트가 서버에거 FIN 패킷을 보낸다.
2. 서버가 클라이언트에게 ACK 패킷을 보낸다.
3. 서버가 클라이언트에게 보내야 될 남은 데이터들을 보낸다.
4. 서버가 클라이언트에게 FIN 패킷을 보낸다.
5. 클라이언트가 서버에게 ACK 패킷을 보낸다.

## 참고 자료

[https://velog.io/@arielgv829/CS-network-TCP-3-way-handshake-4-way-handshake](https://velog.io/@arielgv829/CS-network-TCP-3-way-handshake-4-way-handshake)

[https://stackoverflow.com/questions/46212623/why-tcp-termination-need-4-way-handshake](https://stackoverflow.com/questions/46212623/why-tcp-termination-need-4-way-handshake)