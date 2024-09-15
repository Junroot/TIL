---
tags:
  - Spring-AOP
title: Pointcut Designators
---


## 목표

- pointcut을 표현할 수 있는 pointcut designators를 알아본다.

## this, target

- `this`: 현재 호출되는 joinpoint의 위치를 제한할 때 사용
- `target`: 메서드를 호출하는 대상 객체를 제한할 때 사용

```kotlin
@Pointcut("target(com.baeldung.pointcutadvice.dao.BarDao)")
@Pointcut("this(com.baeldung.pointcutadvice.dao.FooDao)")
```

## args

- 호출하는 메서드의 파라미터를 제한할 때 사용
- 메서드 명이 find로 시작하고, `Long` 타입 파라미터 하나만 있는 경우

```kotlin
@Pointcut("execution(* *..find*(Long))")
```

- 메서드 명이 find로 시작하고, 파라미터 개수는 상관없지만 첫 번째 파라미터가 `Long`인 경우

```kotlin
@Pointcut("execution(* *..find*(Long,..))")
```

## @target

- 호출된 객체의 클래스에 지정된 어노테이션이 있는 경우로 제한할 때 사용

```kotlin
@Pointcut("@target(org.springframework.stereotype.Repository)")
```

## @args

- 인자에 어노테이션이 있는 joinpoint로 제한할 떄 사용
- 아래와 같이 인자를 갖고 올 수 있다.

```java
@Before("methodsAcceptingEntities()") 
public void logMethodAcceptionEntityAnnotatedBean(JoinPoint jp) { logger.info("Accepting beans with @Entity annotation: " + jp.getArgs()[0]); }
```

## @within

- 지정된 어노테이션이 있는 클래스에서 선언된 메서드로만 제한
- @target의 경우는 자신의 부모 클래스에도 영향이 있지만, @within은 자신에게 선언된 메서드에만 영향을 준다.

```kotlin
@Pointcut("@within(org.springframework.stereotype.Repository)")
```

## @annotation

- 메서드에 지정된 어노테이션이 있는 경우만으로 제한

```java
@Pointcut("@annotation(com.baeldung.pointcutadvice.annotations.Loggable)") 
public void loggableMethods() {}
```

## 참고 자료

- https://www.baeldung.com/spring-aop-pointcut-tutorial
- https://docs.spring.io/spring-framework/reference/core/aop/ataspectj/pointcuts.html#aop-pointcuts-designators
