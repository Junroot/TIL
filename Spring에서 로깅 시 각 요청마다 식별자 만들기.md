---
title: Spring에서 로깅 시 각 요청마다 식별자 만들기
tags:
  - Spring-MVC
  - Logback
---
## 배경

- 로그 모니터링할 때 각 로그가 서로 연관이 있는지, 한 요청에 대해서 어떤 순서로 로그가 남았는지 확인이 필요한 상황이 있었다.
- 로그를 남길 때 요청마다 고유한 식별자를 만들어서 로그에 같이 남도록 구현한다.
- 현재 프로젝트는 Logback을 사용해 로그를 남기고 있다.

## MDC

- MDC는 log4j나 logback이 로그를 남길 때 Appedner가 접근할 수 있는 데이터로 Map과 같은 구조로 작성할 수 있다.
- MDC의 고주논 `ThreadLocal`을 사용하여 실행 중인 스레드에 내부적으로 연결된다.
- 아래 사진과 같이 `MDC` 클래스 내에는 `MDCAdapter` 라는 인터페이스의 static 필드를 가지고 있다.
	- ![](assets/Pasted%20image%2020250220203335.png)
- `MDCAdapter`의 구현체인 `LogbackMDCAdapter`는 `ThreadLocal<Map<String, String>>` 필드가 존해하고, put 할 때 `readWriteThreadLocalMap`에 put하는 것을 확인할 수 있다.
	- ![](assets/Pasted%20image%2020250220203432.png)
	- ![](assets/Pasted%20image%2020250220203509.png)
- `MDC` 는 `ThreadLocal`을 이용해 구현한 경우가 많은데, 이 때문에 clear해주는 작업을 유의해서 해야된다.
	- 1번 request가 thread pool에서 A 스레드를 할당 받고 MDC로 데이터 추가
	- 2번 request가 thread pool에서 다시 A 스레드를 할당 받았을 때 1번 request가 추가했던 데이터가 로그에 남을 수 있음

## Spring에서 구현 해보기

- MDC를 이용해 logback에 requestId를 남겨보자
- 필터를 통해서 요청이 들어올 때 랜덤 UUID를 생성하고, 요청을 처리하고 나서 `MDC.clear`를 호출해준다.
	- ![](assets/Pasted%20image%2020250220204330.png)
- appender 종류에 따라 MDC의 데이터를 로그에 남기는 방법이 다를 수 있는데, Console 로그에서는 아래와 같이 "%X{키 값}" 형태로 로그를 남기면 확인할 수 있다.
	- ![](assets/Pasted%20image%2020250220204535.png)
	- ![](assets/Pasted%20image%2020250220204854.png)

## 참고 자료

- https://www.baeldung.com/mdc-in-log4j-2-logback
- https://mangkyu.tistory.com/266
