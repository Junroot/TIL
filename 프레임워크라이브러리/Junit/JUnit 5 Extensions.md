# JUnit 5 Extensions

## 목표

- `@ExtendWith` 애노테이션의 역할을 알아본다.

## JUnit 5 Extension

- JUnit 5에서는 테스트 클래스나 메소드의 동작을 확장하기 위해서 extension을 제공해주고 있다.
- extension points: 테스트 실행에서 발생할 수 있는 이벤트 지점. 이 지점에서 등록된 extension을 호출할 수 있따.
- extension point의 5가지 종류: 괄호 안은 구현해야되는 인터페이스
	- 테스트 인스턴스 후처리(`TestInstancePostProcessor`): 일반적으로 의존성 주입할 때 사용한다.
	- 조건부 테스트 실행( `ExecutionCondition`): 조건에 따라 테스트 실행 여부를 설정할 수 있다.
	- 라이프사이클 콜백: 테스트 라이프사이클에 행동을 추가할 수 있다.
		- `BeforeAllCallback`, `AfterAllCallback`: 모든 테스트 메소드를 실행하기 전과 후에 실행
		- `BeforeEachCallBack`, `AfterEachCallbacl`: 각 테스트 메소드를 실행하기 전과 후에 실행
		- `BeforeTestExecutionCallback`, `AfterTestExecutionCallback`: 테스트 메소드를 실행하기 직전과 직후에 실행
		- 아래 사진에 실행 순서가 있다.
	- 매개변수 확인(`ParameterResolver`): 테스트 코드 생성자와 메소드에서 파라미터를 받을 때 사용한다.
	- 예외 처리(`TestExecutionExceptionHandler`): 예외가 발생했을 때 테스트의 동작을 정의한다.

![](assets/Pasted%20image%2020230314131108.png)

- 다음과 같이 정의한 extension들을 등록할 수 있다.

```java
@ExtendWith({ EnvironmentExtension.class, EmployeeDatabaseSetupExtension.class, EmployeeDaoParameterResolver.class })
```

- 아래 사진과 같이 `SpringExtension`도 앞에서 나열한 인터페이스들을 구현하고 있다.
	- https://github.com/spring-projects/spring-framework/blob/main/spring-test/src/main/java/org/springframework/test/context/junit/jupiter/SpringExtension.java

![](assets/Pasted%20image%2020230314131806.png)

## 참고 자료

- https://www.baeldung.com/junit-5-extensions