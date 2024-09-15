---
tags:
  - Spring-AOP
title: Spring AOP 시작하기
---


## 목표

- AOP가 무엇인지 이해한다.
- Spring AOP를 사용하는 방법을 이해한다.
- Spring AOP의 내부 구조를 이해한다.

## AOP(Aspect-Oriented Programming)

### Cross-Cutting Concern

- concern: 기능에 따라 분리한 시스템의 동작
- concern의 2가지 종류
	- core concern: 주요 요구사항에 대한 기능
	- cross-cutting concern: 보조되는 또는 시스템 전반적인 요구 사항
		- 예시: 로깅, 보안, 데이터 전송 등
- aspect: cross-cutting concern을 모듈화한 것

![](assets/Pasted%20image%2020230330132003.png)

### AOP

- cross-cutting concern을 분리하여 모듈성을 높이는 것을 목표로하는 프로그래밍 패러다임
- 새로운 동작이 필요하면, 기존 코드에 추가하지 않고 분리된 새로운 코드를 선언할 수 있다.

### AOP는 안티패턴?

- AOP는 'Action at a distance' 라는 안티 패턴을 가지게 된다.
- action at a distance: 코드에서 어떤 위치에서 동작이 있을 때, 그로부터 멀리 떨어져 있는 다른 동작을 식별하기 어려운 안티 패턴
	- 이를 피하기 위해서는 전역 변수 사용을 피하고, 순수 함수형 프로그래밍 스타일을 사용해야된다.
- 그렇다고 AOP가 항상 사용하면 안된다는 뜻이 아니라, 신중하게 사용해야된다.
	- 같은 aspect를 일부는 AOP로 일부는 일반 코드로 구현하는 경우를 피해야된다.
	- 현재 aspect가 정말 cross-cutting concern이 맞는지, core concern은 아닐지 신중히 고민해야된다.

## Spring AOP 사용하는 방법

### AOP 용어 설명

![](assets/Pasted%20image%2020230330152510.png)

- joinpoint: 프로그램을 실행하면서 '메소드 실행'이나 '예외 핸들링' 같은 특정 지점을 말한다. 
	- Spring AOP에서는 '메소드 실행'만 joinpoint로 사용한다.
- pointcut: advice와 joinpoint의 매칭.
	- 일반적으로 Pointcut expression을 사용한다.
- advice: 특정 joinpoint에서 aspect로 부터 실행할 동작.
	- advice 종류: around, before, after
	- Spring에서는 advice가 인터셉터로 모델링되어 joinpoint 주변에 인터셉터 체인을 유지한다.

### @AspectJ 지원

- AOP 라이브러리에는 Spring AOP 뿐만아니라 AspectJ도 존재한다.
- AspectJ 5부터 @AspectJ 스타일만 따로 사용할 수 있도록 제공해주고 있다.
- Spring은 AspectJ 5의 애노테이션을 사용해서 AOP 기능을 제공하고 있고, 이 때는 AspectJ 컴파일러나 weaver가 아닌 순수한 Spring AOP로 동작한다.
- https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj

### Spring AOP with @AspectJ로 구현해보기

```kotlin
@Component  
@Aspect  
class GetAspect {  
  
   @Pointcut("@annotation(org.springframework.web.bind.annotation.GetMapping)")  
   fun pointCut() {}  
  
   @AfterReturning(pointcut = "pointCut()", returning = "returnValue")  
   fun afterReturn(returnValue: Any) {  
      println(returnValue)  
   }  
}
```

- 빈으로 등록되는 클래스에 `@AspectJ`를 붙여주면 Spring에서 자동으로 감지하여 Spring AOP를 구성하는데 사용한다.
- 메서드 위에 `@Pointcut` 애노테이션과 함께 Pointcut expression을 작성하면 pointcut을 정의할 수 있다. 이 때 메서드의 리턴 타입은 `void`를 가져야한다.
	- pointcut expression: https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-pointcuts-designators
- advice에는 `@Around`, `@Before`, `@After`, `@AfterReturning`, `@AfterThrowing`가 있다.
	- advice 애노테이션 파라미터로 pointcut 이름(메서드명)을 쓰거나, pointcut expression을 직접 사용할 수도 있다.
	- 여기서 `returning` 속성은 `@AfterReturning`에만 있는 것으로 advice 메소드의 파라미터 이름을 작성한다.

## Spring AOP 내부 구조 

### Weaving

- Spring AOP의 동작 방식을 이해하기 위해서는 weaving을 먼저 이해해야된다.
- weaving: aspect와 이 aspect의 advice를 적용할 대상 객체를 연결시켜주는 과정
- weaving의 종류
	- compile-time weaving: aspect의 코드와 애플리케이션 코드를 입력으로 받아서, weaving된 클래스파일로 컴파일한다.
	- post-compile weaving: aspect 코드를 먼저 컴파일하여, 클래스 파일이나 jar 파일을 사용해 weaving한다. binary weaving이라고도 불린다.
	- load-time weaving: binary weaving 방식과 동일하지만, 클래스 로더가 클래스 파일을 JVM에 로드할 때까지 위빙이 연기된다.
	- runtime weaving: 애플리케이션이 실행되고 있는 중에 weaving이 일어난다.
- AspectJ는 compile-time, load-time weaving을 사용하고, Spring AOP는 runtime weaving을 사용한다.

### Spring AOP의 runtime weaving

![](assets/Pasted%20image%2020230330164020.png)

- 대싱 객체의 프록시를 만들어 runtime weaving을 구현했다.
- 프록시는 JDK dynamic proxy와 CGLIB proxy를 사용한다.
	- JDK dyanamic proxy: 대상 객체가 하나의 인터페이스라도 구현하고 있을 때 사용한다. Spring AOP에서 선호하는 방법이다.
	- CGLIB proxy: 대상 객체가 구현하고 있는 인터페이스가 없을 때 사용한다.
- 프록시 방식을 사용하므로 대상 객체에서 자기 자신의 다른 메소드를 호출할 때는 advice가 동작하지 않는다.
- 또한, private 메소드에서도 adivce가 동작하지 않는다.
- CGLIB을 사용하는 경우는 대상 객체를 상속하는 방식이므로 `final` 메서드나 클래스에서는 사용할 수 없다.

## 참고 자료

- https://stackoverflow.com/questions/23700540/cross-cutting-concern-example
- https://en.wikipedia.org/wiki/Action_at_a_distance_(computer_programming)
- https://stackoverflow.com/questions/35909928/what-is-action-at-a-distance-in-this-jep
- https://stackoverflow.com/questions/232884/aspect-oriented-programming-vs-object-oriented-programming
- https://www.baeldung.com/spring-aop
- https://engkimbs.tistory.com/746
- https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj
- https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-proxying
