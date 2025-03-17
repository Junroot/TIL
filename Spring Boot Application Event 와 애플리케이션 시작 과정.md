---
title: Spring Boot Applicatoin Event 와 애플리케이션 시작 과정
tags:
  - Spring-Boot
---
## 배경

- [SpringApplicationEvent](https://junroot.github.io/blog/posts/springapplicationevent/) 에서 Spring 프레임워크가 애플리케이션에 관련된 이벤트를 발행하는 것을 이해할 수 있었다.
- Spring Boot에서 어떤 이벤트를 전송하고 있는지 이해한다.

## 이벤트 목록

애플리케이션 실행 시 아래 순서대로 이벤트가 발생한다.

1. `ApplicatoinStartingEvent`: 애플리케이션 실행 이전에 발생한다.
	- `ApplicationContextInitializer` 들과 `ApplicationListener` 들의 등록을 제외한 모든 처리 이전에 발생한다.
	- `ApplicationContextInitializer`: `ApplicationContext`가 초기화되기 전에 실행되어야 하는 로직이 있을 때 정의하는 콜백 인터페이스
	- `ApplicationListener`: 애플리케이션에서 발생하는 이벤트를 감지하고 처리하는 역할의 인터페이스
2. `ApplicationEnvironmentPreparedEvent`: `Environment`가 준비 되었지만, `ApplicationContext`가 생성되기 전에 발생한다.
	- `Environment`: 애플리케이션의 profile과 properties를 관리하는 인터페이스
	- 일반적으로 `ApplicationContext` 에서 `Environment`를 필드로 가지고 있다.
3. `ApplicationContextInitializedEvent`: `ApplicationContext` 가 생성되고, `ApplicationContextInitializer` 들이 호출되었지만 bean definition이 로드되기 전에 발생한다.
	-  bean definition은 bean에 대한 메타 데이터라서, bean이 초기화되는 것은 아니다.
4. `ApplicationPreparedEvent`: bean definition이 로드되고 `ApplicationContext`가 refresh 되기 전에 발생한다.
	- `ApplicationContext`의 refresh 단계에서 bean definition을 기준으로 bean 초기화가 이루어진다.
	- component scan으로 bean definition을 추가로 로드하고, 초기화하는 과정도 refresh에서 이루어진다.
	- `ApplicationContext`의 refresh 단계에서 동작 과정은 복잡하니 아래의 글의 참고한다.
		- https://mangkyu.tistory.com/214
	- refresh 단계의 간단한 과정은 아래 순서와 같다.
		- `BeanFactoryPostProcessor` 들을 실행한다.
			- `BeanFactoryPostProcessor` 구현체 중에 `ConfigurationClassPostProcessor`에 의해서 component-scan이 이루어지고, 스캔이 된 bean들의 definition을 로드한다.
		- `BeanPostProcessor`를 등록한다.
			- `BeanPostProcessor`는 `@Value`, `@PostConstruct`, `@Autowired` 같이 bean을 생성하고 나서 추가로 처리해줘야되는 작업을 처리해준다.
		- 로드한 bean definition을 바탕으로 인스턴스화 한다.
			- 생성자로 인스턴스가 생성되면 `@Value`, `@Autowired` 같은 프로퍼티는 null이 되고, 등록해둔 `BeanPostProcessor`를 통해 값을 추가해준다.
5. `ApplicationStartedEvent`: `ApplicationContext`가 refresh 된 후 command-line runner 들이 호출되기 전에 발생한다.
6. `AvailabilityChangeEvent`: 애플리케이션이 live 상태로 간주됨을 나타내기 위해 `LivenessState.CORRECT` 로 발생한다.
7. `ApplicationReadyEvent`: command-line runner 들이 호출되고 발생한다.
8. `AvailabilityChangeEvent`: 애플리케이션이 요청을 받을 수 있는 상태를 나타내기 위해 `ReadinessState.ACCEPTING_TRAFFIC`로 발생한다.
9. `ApplicationFailedEvent`: 애플리케이션 시작 과정에서 예외가 던져지면 발생한다.

## 참고 자료

- https://docs.spring.io/spring-boot/reference/features/spring-application.html#features.spring-application.application-events-and-listeners
- https://mangkyu.tistory.com/214
