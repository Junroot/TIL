---
tags:
  - Spring-MVC
---
# Interceptor

## 특정 IP만 접근 허용하기

```java
@Override
public boolean preHandle(final HttpServletRequest request, final HttpServletResponse response, final Object handler) {
			String clientIp = request.getRemoteAddr();
      administratorService.validateIp(clientIp);
}
```

`getRemoteAddr()` 를 통해 현재 요청을 보낸 client의 IP를 확인할 수 있다.

## 특정 HTTP Method만 허용하기

```java
@Override
public boolean preHandle(final HttpServletRequest request, final HttpServletResponse response, final Object handler) {
		if (!"GET".equals(request.getMethod())) {
				throw new IllegalArugmentException();
    }
}
```

`getMethod()` 메소드를 통해 현재 요청을 보낸 HTTP 메소드를 알 수 있다.