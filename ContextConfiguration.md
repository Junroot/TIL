---
tags:
  - Spring-Test
title: ContextConfiguration
---


## 목표

- `@ContextConfiguration`의 용도를 이해한다.

## @ContextConfiguration의 용도

- 테스트에서 context initializer를 사용해서 `ApplicationContext`를 구성할 때 사용한다.
- context를 로드하기 위해 필요한 컴포넌트는 `locations`로 xml 설정 파일을 지정하거나, `classes`로 `@Configuration` 클래스를 지정할 수 있다.

```kotlin
@ContextConfiguration("/test-config.xml") 
class XmlApplicationContextTests {
	// class body...
}
```

```kotlin
@ContextConfiguration(classes = [TestConfig::class]) 
class ConfigClassApplicationContextTests {
	// class body...
}
```

- `ApplicationContextInitializer`의 구현체를 사용해 구성하고 싶다면, `initializers` 프로퍼티로 등록할 수 있다.
	- `ApplicationContextInitializer`: Spring이 `ApplicationContext`를 초기화 전에 실행하는 콜백 인터페이스

```kotlin
@ContextConfiguration(initializers = [CustomContextInitializer::class]) 
class ContextInitializerTests {
	// class body...
}
```

- `@ContextConfiguration`이 제공하는 기본 loader가 `locations`, `classes`, `initializer` 속성을 가져와서 `ApplicationContext`를 구성하지만 loader의 커스텀이 필요한 경우가 있다.

```kotlin
@ContextConfiguration("/test-context.xml", loader = CustomContextLoader::class) 
class CustomLoaderXmlApplicationContextTests {
	// class body...
}
```

## 참고 자료

- https://docs.spring.io/spring-framework/reference/testing/testcontext-framework/ctx-management/initializers.html
- https://docs.spring.io/spring-framework/reference/testing/annotations/integration-spring/annotation-contextconfiguration.html
- https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/ApplicationContext.html
