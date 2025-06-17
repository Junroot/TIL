---
title: JMX와 VisualVM으로 remote 환경에 있는 앱 성능 분석
tags:
  - Java
---
## 목표

- stage 환경에서 Spring 애플리케이션이 컨테이너로 실행되고 있다.
- 해당 애플리케이션의 특정 API의 응답 속도가 늦어져서 원인을 파악한다.

## JMX

- JMX: JVM 애플리케이션을 관리하고 모니터링하기 위해 제공되는 API

### JMX 아키텍처

- JMX는 3개의 계층으로 구성되어 있다.
	- Instrumentation layer: 
		- 애플리케이션에서 관리하고자 하는 자원을 표현하는 `MBean` 객체를 관리
		- JVM에서 기본적으로 제공하는 `MBean`들이 있음
			- `ThreadMXBean`: 스레드 수, 스레드별 CPU 시간, 스레드들의 stack trace 정보 등을 제공
			- `MemoryMXBean`: 메모리 사용량 제공
	- JMX agent layer:
		- `MBeanServer` 존재
		- `MBean` 객체들을 등록, 괸리하고 이를 접근할 수 있도록 인터페이스 제공
	- Remote management layer:
		- JConsole, VisualVM 같은 툴을 가리키는 클라이언트 영역

## VisualVM

- JVM 애플리케이션을 모니터링 하기 위한 툴
- jstatd, JMX 등의 방식으로 JVM 애플리케이션과 통신해서 여러 메트릭 정보 확인 가능

## Remote 환경의 컨테이너를 VisualVM으로 모니터링 하기

- VisualVM을 JVM 애플리케이션과 JMX 연결하여 모니터링 할 수 있다.

### 컨테이너 실행 시 설정

- 그러기 위해서는 jar 파일을 실행할 때 아래와 같은 옵션을 추가해야 된다.
	- `-Dcom.sun.management.jmxremote`
		- JMX 원격 관리 에이전트를 활성화 한다.
	- `-Dcom.sun.management.jmxremote.port`
		- JMX RMI(Remote Method Invocation) 레지스트리에서 사용할 포트
		- JMX RMI 레지스트리: RMI 통신을 할 때 어떤 객체의 어떤 메서드를 호출할 지에 대한 매핑 정보
	- `-Dcom.sun.management.jmxremote.rmi.port`
		- JMXConnectorServer가 사용할 포트
		- JMXConnectorServer: RMI를 통해 `MBeanServer`로 들어오는 요청을 처리하는 역할
		- JMX RMI 레지스트리 포트와 동일하게 사용 가능하다.
	- `-Dcom.sun.management.jmxremote.authenticate`
		- JMX 연결 시 사용자 인증 비활성화
	- `-Dcom.sun.management.jmxremote.ssl`
		- JMX RMI 통신에 SSL 암호화 비활성화
	- `-Dcom.sun.management.jmxremote.local.only`
		- 원격에 있는 agent가 RMI 레지스트리로 접속 허용
	- `-Djava.rmi.server.hostname`
		- RMI 레지스트리에서 자신을 구분하기 위한 호스트명 또는 IP 주소

```sh
-Dcom.sun.management.jmxremote=true
-Dcom.sun.management.jmxremote.port=<port>
-Dcom.sun.management.jmxremote.rmi.port=<port>
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
-Dcom.sun.management.jmxremote.local.only=false
-Djava.rmi.server.hostname=<docker ip>
```

### VisualVM 설정

- 아래 사진과 같이 JMX Connection을 추가한다.
	- ![](assets/Pasted%20image%2020250617204944.png)
- sampler를 통해 샘플링을 시작하고, 원하는 API를 호출한 다음 샘플링을 멈추면 아래 사진과 같이 메서드 호출 경로와 메서드 실행 시간을 확인할 수 있다.
	- Time: 하위 메서드를 포함한 현재 메서드의 실행 시간 (I/O 작업으로 발생하는 blocking 시간 포함)
	- Time(CPU): 하위 메서드를 포함한 현재 메서드의 CPU 실행 시간
	- Self time: 하위 메서드를 제외한 현재 메서드의 실행 시간 (I/O 작업으로 발생하는 blocking 시간 포함)
	- Self time(CPU): 하위 메서드를 제외한 현재 메서드의 CPU 실행 시간
	- ![](assets/Pasted%20image%2020250617205258.png)

### VisualVM이 샘플링하는 원리

- VisualVM Sampler는 주기적으로 (ms 단위, 설정 가능) JMX 커넥션을 통해서 `MBeanServer`와 통신한다.
- `MBeanServer`는 `MBean`들을 관리하고 있고, `MBean` 들은 JVM의 네이티브 메서드를 호출하고 있다.
- VisualVM Sampler는 이를 통해 주기적으로 스레드들의 stack trace를 확인하고, 집계하여 각 메서드별 호출 시간을 집계한다.

## 참고 자료

- https://www.baeldung.com/java-management-extensions
- https://www.baeldung.com/visualvm-jmx-remote
- https://gogetem.tistory.com/entry/Java-RMI-Remote-Method-Invokation%EC%9D%84-%EC%95%8C%EC%95%84%EB%B3%B4%EC%9E%90
- https://stackoverflow.com/questions/23850407/why-does-java-cpu-profile-using-visualvm-show-so-many-hits-on-a-method-that-do
- https://openjdk.org/groups/serviceability/svcjdk.html
