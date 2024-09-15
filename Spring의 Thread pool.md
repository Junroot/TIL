---
tags:
  - Spring-Boot
title: Spring의 Thread pool
---


## 목표

- Thread pool의 사용 목적을 이해한다.
- Spring boot에서 Tomcat의 Thread pool 설정 방법을 이해한다.

## Thread Pool

- DB, 웹 서버 등의 프로그램에서 요청이 도착할 떄마다 새 스레드를 생성하는 방법은 문제점이 있다.
	- 요청을 처리할 때마다 스레드를 생성하고 삭제하는 것은 많은 시간과 시스템 리소스를 사용한다.
	- 너무 많은 요청이 오면, 동시에 너무 많은 스레드가 생성되어 시스템 리소스가 부족해질 수 있다. 스레드 수를 제한할 필요가 있다.
- 이 문제를 해결하기 위해서 이전에 미리 생성된 스레드를 재사용하기 위한 Thread pool을 사용한다.
	- thread pool을 나타내는 대표적인 구현체는 `ThreadPoolExecutor`가 있고 `ExecutorService` 인터페이스를 구현하고 있다.

![](assets/Pasted%20image%2020240411200502.png)

## Tomcat의 요청 처리 방식

![](assets/Pasted%20image%2020240411193420.png)

- Tomcat은 모든 요청이 `Connector`를 통해서 들어온다.
- `Service`는 하나의 `Engine`과 여러 개의 `Connector`를 매핑시켜준다.
	- `Service` 내에는 `Executor`라는 thread pool이 존재한다.
	- 예전에는 커넥터 하나 당 하나의 thread pool을 들고 있었지만, 지금은 Tomcat 내 컴포넌트 간에 thread pool을 공유하고 있다.
- `Engine`은 `Connector`로 부터 온 모든 요청을 처리한다.
- `Host`는 가상 호스트를 나타낸다. 가상 호스트에 대한 `Context`를 매핑하고 있다.
- `Context`가 가상 호스트에 대한 웹 애플리케이션을 나타낸다. 요청이 들어오면 정의된 `Servlet` 매핑에 따라 `Servlet`을 선택한다.

## Spring boot에서 thread pool 설정하는 방법

- Spring Boot에서는 properties 파일을 통해 tomcat의 thread pool을 설정할 수 있다.
	- `server.tomcat.thread.min-spare`: thread의 최소 개수
	- `server.tomcat.thread.max`: thread의 최대 개수
- 주의점: tomcat의 최대 thread 수가 한 번에 맺을 수 있는 최대 connection 수가 아니다.
	- Tomcat 7 이전 버전에서는 BIO(blocking I/O) 방식으로 하나의 connection이 하나의 thread를 할당했다.
	- 이후에는 NIO(non-blocking I/O) 방식으로 thread 개수보다 connection의 개수가 많아질 수 있다.
	- Java NIO의 간단한 설명: buffer를 만들어두고 읽을 수 있는 데이터가 있을 때 thread를 할당해 처리하는 방식

## 참고 자료

- https://tomcat.apache.org/tomcat-9.0-doc/config/executor.html
- https://www.baeldung.com/java-web-thread-pool-config
- https://www.baeldung.com/spring-boot-configure-tomcat
