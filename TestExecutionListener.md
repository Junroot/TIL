---
tags:
  - Spring-Test
title: TestExecutionListener
---


## 목표

- `TestExecutionListner`가 무엇인지 이해한다.
- `TestExecutionListner`의 사용법을 이해한다.

## TestExecutionListner

- Junit의 `@BeforeEach`, `@AfterEach`, `@BeforeAll`, `@AfterAll` 같이 테스트 라이프사이클에 추가적으로 동작해야 되는 내용이 있을 때 사용할 수 있다.
- Spring test에서 제공하는 인터페이스로 이를 상속해서 구현할 수 있다.

## 인터페이스

```java
public interface TestExecutionListener {
    default void beforeTestClass(TestContext testContext) throws Exception {};
    default void prepareTestInstance(TestContext testContext) throws Exception {};
    default void beforeTestMethod(TestContext testContext) throws Exception {};
    default void afterTestMethod(TestContext testContext) throws Exception {};
    default void afterTestClass(TestContext testContext) throws Exception {};
}
```

- beforeTestClass: 클래스 내의 모든 테스트를 실행하기 전에 실행한다.
- prepareTestInstance: 테스트 인스턴스를 준비하는 시점에 실행한다.
- beforeTestMethod: 테스트 메서드를 실행하기 전에 실행한다.
- afterTestMethod: 테스트 메서드를 실행한 후에 실행한다.
- afterTestClass: 클래스 내의 모든 테스트를 실행한 후에 실행한다.
- 이 외에 beforeTestExecution, afterTestExecution 등이 있다.

## 기본 구현체

- Spring에서 아래와 같은 `TestExecutionListener`를 기본으로 제공한다.
- `ServletTestExecutionListener`: `WebApplicationContext`의 Servlet API mock과 관련된 설정을 한다.
- `DirtiesContextBeforeModesTestExecutionListener`: before 모드에 대한 `@DirtiesContext`를 처리한다.
- `DependencyInjectionTestExecutionListener`: 테스트 인스턴스에 DI를 제공한다.
- `DirtiesContextTestExecutionListener`: after 모드에 대한 `@DirtiesContext` 어노테이션을 핸들링한다.
- `TransactionalTestExecutionListener`: transactional 테스트 실행에 기본적으로 롤백이 되도록 제공한다.
- `SqlScriptsTestExecutionListener`: `@Sql` 어노테이션을 사용해서 SQL 스크립트를 실행한다.

## 사용 방법

- `TestExecutionListener` 의 구현체를 `@TestExecutionListener` 어노테이션으로 등록할 수 있다.

```java
@RunWith(SpringRunner.class)
@TestExecutionListeners(value = {
  CustomTestExecutionListener.class,
  DependencyInjectionTestExecutionListener.class
})
@ContextConfiguration(classes = AdditionService.class)
public class AdditionServiceUnitTest {
    // ...
}
```

- 만약 기본으로 제공하는 어노테이션에 커스텀 구현체를 추가로 등록하고 싶다면 아래와 같이 가능하다.

```java
@TestExecutionListeners(
  value = { CustomTestExecutionListener.class }, 
  mergeMode = MergeMode.MERGE_WITH_DEFAULTS)
```

- Listner간의 처리 순서가 중요하면, 아래와 같이 `Ordered` 인터페이스를 상속해서 사용하면 된다.

```java
public class CustomTestExecutionListener implements TestExecutionListener, Ordered {
    // ...
    @Override
    public int getOrder() {
        return Integer.MAX_VALUE;
    };
}
```

## 참고 자료

- https://www.baeldung.com/spring-testexecutionlistener
