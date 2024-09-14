---
tags:
  - Spring-Framework
---
# OpenPerRequestFilter

## 배경

- 팀 코드에 `OpenPerRequestFilter`를 상속한 형태의 `Filter`가 존재했다. 이 클래스는 어떤 역할인지 확인할 필요가 있었다.

## 필요한 상황

- `Filter`는 서블릿 실행 전과 후에 호출된다.
- 요청이 서블릿으로 들어오면 서블릿은 다른 서블릿으로 포워딩 할 수도 있다.
- 이 과정에서 같은 필터를 여러 번 호출할 수도 있다.
- Spring은 이런 상황에서 필터가 한번만 호출되는 것을 보장시켜주기 위해 `OncePerRequestFilter`을 제공한다.

## 사용법

- `OncePerRequestFilter`를 상속한 클래스를 정의하고, `doFilterINternal()` 메소드를 override하면 된다.

```java
public class AuthenticationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws
            ServletException, IOException {
        String usrName = request.getHeader(“userName”);
        logger.info("Successfully authenticated user  " +
                userName);
        filterChain.doFilter(request, response);
    }
}
```

## 참고 자료

- https://www.baeldung.com/spring-onceperrequestfilter