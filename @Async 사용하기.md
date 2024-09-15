---
tags:
  - Spring-Framework
title: "@Async 사용하기"
---


## 목표

- `@Async`을 사용하는 이유를 이해한다.
- `@Async`의 사용 방법을 이해한다.

## `@Async`란?

- bean의 메소드에 `@Async`를 붙이면 별도의 스레드로 메소드가 실행된다.
- 호출한 쪽에서는 메소드 호출이 완료되기까지 기다리지 않는다.

## `@Async` 사용 방법

### configuration

- `@Async`를 사용하기 위해서는 configuration에 `@EnableAsync` 를 추가해야된다.

```kotlin
@EnableAsync  
@Configuration  
class AsyncConfig
```

- `@EnableAsync`의 옵션
	- `annotation`: 기본값으로는 `@Async`를 사용하지만 커스텀 애노테이션을 사요하고 싶을 때 사용할 수 있따.
	- `mode`: advice의 종류를 나타낸다. PROXY와 AspectJ가 있다.
	- `proxyTargetClass`: 프록시 모드를 사용할 때만 사용된다. CGLIB과 JDK가 있다.
	- `order`: `AsyncAnnotationBeanPostProcessor`가 적용될 순서를 설정한다. 기본값으로는 모든 프록시가 `@Async`를 적용할 수 있도록 마지막에 실행된다.
- 프록시를 사용하기 때문에 public 메소드에만 사용할 수 있고, self-invocation에서는 동작하지 않는다.

### void 리턴인 method

```java
@Async
public void asyncMethodWithVoidReturnType() {
    System.out.println("Execute method asynchronously. " 
      + Thread.currentThread().getName());
}
```

### 리턴 타입이 있는 method

- `Future` 타입으로 wrapping해서 반환해야된다.
- `AsyncResult`는 `Future`의 구현체다.

```java
@Async
public Future<String> asyncMethodWithReturnType() {
    System.out.println("Execute method asynchronously - " 
      + Thread.currentThread().getName());
    try {
        Thread.sleep(5000);
        return new AsyncResult<String>("hello world !!!!");
    } catch (InterruptedException e) {
        //
    }

    return null;
}
```

### Executor

- 스프링은 기본적으로 메소드를 비동기로 처리하기 위해 `SimpleAsyncTaskExecutor`를 사용한다. 하지만 애플리케이션 레벨과 메소드 레벨로 `Executor`를 오버라이딩 할 수 있다.
- 메소드 레벨: bean으로 등록해주면 쉽게 사용이 가능하다.
	- `@Async` 애노테이션에서 bean 이름을 명시하면 된다.

```java
@Configuration
@EnableAsync
public class SpringAsyncConfig {
    
    @Bean(name = "threadPoolTaskExecutor")
    public Executor threadPoolTaskExecutor() {
        return new ThreadPoolTaskExecutor();
    }
}
```

```java
@Async("threadPoolTaskExecutor")
public void asyncMethodWithConfiguredExecutor() {
    System.out.println("Execute method with configured executor - "
      + Thread.currentThread().getName());
}
```

- 애플리케이션 레벨: configuration 클래스가 `AsyncConfigurer` 인터페이스를 구현하도록 수정해야된다. `getAsyncExecutor()` 메소드를 구현하면, 애플리케이션 레벨의 `Executor`을 커스텀할 수 있다.

```java
@Configuration
@EnableAsync
public class SpringAsyncConfig implements AsyncConfigurer {
	@Override 
	public Executor getAsyncExecutor() { 
		ThreadPoolTaskExecutor threadPoolTaskExecutor = new ThreadPoolTaskExecutor(); 
		threadPoolTaskExecutor.initialize(); 
		return threadPoolTaskExecutor; 
	}
}
```

### 예외 처리

- 리턴 타입이 `Future`인 경우에는, `Future.get()`을 호출할 때 예외가 전파된다.
- 리턴 타입이 `void`인 경우에는 예외가 전파되지 않는다.
- `AsyncUncaughtExceptionHandler` 인터페이스를 구현해서 예외를 핸들링할 수 있다.

```java
public class CustomAsyncExceptionHandler
  implements AsyncUncaughtExceptionHandler {

    @Override
    public void handleUncaughtException(
      Throwable throwable, Method method, Object... obj) {
 
        System.out.println("Exception message - " + throwable.getMessage());
        System.out.println("Method name - " + method.getName());
        for (Object param : obj) {
            System.out.println("Parameter value - " + param);
        }
    }
    
}
```

- `AsyncUncaughtExceptionHandler` 구현체는 `AsyncConfigurer`의 `getAsyncUncaughtExceptionHandler()` 메소드를 오버라이드하여 등록해줘야된다.

```java
@Override
public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
    return new CustomAsyncExceptionHandler();
}
```

## 참고 자료

- https://www.baeldung.com/spring-async
