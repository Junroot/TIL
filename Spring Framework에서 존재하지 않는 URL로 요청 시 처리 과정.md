---
title: Spring Framework에서 존재하지 않는 URL로 요청 시 처리 과정
tags:
  - Spring-Boot
  - Spring-MVC
---
## 목표

- Spring Boot에서 존재하지 않는 URL로 요청 시 404 응답한다.
- 어떤 내부 동작으로 404 응답을 하게 되는지 이해한다.

##  `ResourceHttpRequestHandler`

- Spring Boot 기본 설정 기준으로 모든 요청에 대해서, 처리할 다른 핸들러가 없으면 `ResourceHttpRequestHandler`로 정적 리소스를 찾아서 반환하려고 시도한다.
- 해당 핸들러는 `spring.web.resources.add-mappings`를 `false`로 설정하는 등의 방법으로 사용하지 않게 설정하여, 정적 리소스를 응답하지 않도록 설정할 수 있다.
- 해당 핸들러 사용 유무에 따라 404 응답을 처리하는 위치가 달라진다.

## `ResourceHttpRequestHandler`를 사용하는 경우 처리 과정

### Spring Framework 6.1 이전

- 반환할 리소스가 없으면 항상 `HttpServletResponse.sendError(SC_NOT_FOUND)`를 호출해서 404 응답이 발생한다.
- 아래는 `ResourceHttpRequestHandler` 클래스 내부 코드이다.
	- ![](assets/Pasted%20image%2020241014201333.png)

### Spring Framework 6.1 부터

- 반환할 리소스가 없으면 `NoResourceFoundException` 예외를 던진다.
- `NoResourceFoundException` 예외를 던져서 Global Exception Handler 에서 해당 예외를 핸들링할 수 있도록 변경되었다.
- 아래는 `ResourceHttpRequestHandler` 클래스 내부 코드이다.
	- ![](assets/Pasted%20image%2020241014201512.png)

## `ResourceHttpRequestHandler`를 사용하는 경우 처리 과정

### Spring Framework 6.1 이전

- `ResourceHttpRequestHandler`을 사용하지 않는 경우에는 `DispatcherServlet`에러 에러를 던진다.
- `throwExceptionIfNoHandlerFound` 변수가 (기본값 false) true이면 현재 요청을 처리해줄 핸들러가 없을 때 `NoHandlerFoundException` 발생시켜 Global Exception Handler 에서 핸들링 가능하다. 
- `throwExceptionIfNoHandlerFound` 변수가 false이면 `HttpServletResponse.sendError(SC_NOT_FOUND)` 호출해서 Global Exception Handler 에서 핸들링 불가능하다. 

![](assets/Pasted%20image%2020241014202609.png)

- `throwExceptionIfNoHandlerFound` 변수는 `spring.mvc.throw-exception-if-no-handler-found=true` 로 프로퍼티를 수정하면 변경 가능하다.

### Spring Framework 6.1 부터

- `throwExceptionIfNoHandlerFound` 변수가 기본값이 true로 변경되어서, 기본적으로 `NoHandlerFoundException` 예외를 던진다.

## 참고 자료

- https://github.com/spring-projects/spring-framework/issues/29491
- https://www.baeldung.com/spring-mvc-static-resources
- https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/resource/NoResourceFoundException.html
- https://github.com/spring-projects/spring-boot/issues/13584
- https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-6.x/75bc31b9d8b3f86303830b9c2e65011c51b9881e
