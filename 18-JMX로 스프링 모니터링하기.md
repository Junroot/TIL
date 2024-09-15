---
tags:
  - 도서/Spring-in-Action
title: 18-JMX로 스프링 모니터링하기
---



- JMX(Java Management Extensions): 자바 애플리케이션을 모니터링하고 관리하는 표준 방법
	- JMX는 MBeans(managed beans) 컴포넌트를 노출함으로써 외부의 JMX 클라이언트는 오퍼레이션 호출, 속성 검사, MBeans의 이베트 모니터링을 통해 애플리케이션을 관리할 수 있다.
- JMX는 스프링 부트 애플리케이션에 기본적으로 자동 활성화된다. 이예 따라 모든 액추에이터 엔드포인트는 MBeans로 노출된다.
	- 또한, 스프링 애플리케이션 컨텍스트의 어떤 다른 빈도 MBeans로 노출할 수 있게 했다.

## 액추에이터 MBeans 사용하기

- 스프링 부트는 /heapdump를 제외한 모든 액추에이터 엔드포인트가 HTTP처럼 명시적으로 포함시킬 필요 없이 기본으로 MBeans로 노출되어 있다.
- 따라서 JConsole과 같은 JMX 클라이언트를 사용하면 바로 확인할 수 있다.
	- ![](assets/Pasted%20image%2020231121032124.png)
- 일부만 노출하고 싶으면, `management.endpoint.jmx.exposure.include`와 `management.endpoints.jmx.exposure.exclude`를 설정하면 된다.
	- ![](assets/Pasted%20image%2020231121032203.png)

## 우리의 MBeans 생성하기

- 스프링은 우리가 원하는 어떤 bean도 JMX MBeans로 쉽게 노출한다.
- 빈 클래스에 `@ManagedResource` 애노테이션을 지정하고 메서드에는 `@ManagedOperation`을, 속성에는 `@ManagedAttribute`만 지정하면 된다.
	- ![](assets/Pasted%20image%2020231121033854.png)
	- ![](assets/Pasted%20image%2020231121033902.png)
- 기본적으론 MBeans의 오퍼레이션과 속성은 pull 방식을 사용한다.
	- 즉, MBeans 속성의 값이 변경되더라도 알려주지 않으므로 JMX 클라이언트를 통해 봐야만 알 수 있다.
	- MBeans를 JMX 클라이언트에 알림을 push 할 수 있는 방법이 있다.

## 알림 전송하기

- 스프링의 `NotifiactionPublisher`를 사용하면 MBeans가 JMX 클라이언트에 알림을 푸시할 수 있다.
	- https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/jmx/export/notification/NotificationPublisher.html
	- `NotificationPublisher`는 하나의 `sendNotification()` 메서드를 갖는다. 이 메서드는 `Notification` 객체를 인자로 받아서 MBean을 구독하는 JMX 클라이언트에게 발행한다.
- MBeans가 알림을 발행하려면 `NotoficationPublisherAware` 인터페이스의 `setNotifiactionPublisher()` 메서드를 구현해야 한다.
	- ![](assets/Pasted%20image%2020231121034639.png)
	- ![](assets/Pasted%20image%2020231121034645.png)
