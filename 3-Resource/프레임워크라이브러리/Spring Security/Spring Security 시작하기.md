# Spring Security 시작하기

## 목표

- Spring Security 내부 구조를 이해한다.
- Spring Security 사용 방법을 이해한다.

## Filters

### Filter와 FilterChain

![](assets/Pasted%20image%2020240401010938.png)

- 클라이언트가 요청을 보내면, 서블릿 컨테이너에서 lazy하게 `FilterChain`를 생성한다.
	- `FilterChain`은 `Filter` 인스턴스들과 하나의 `Servlet`을 포함한다.
	- Spring MVC를 사용 중이라면 `Servlet`은 `DispatcherServlet`이 된다.
- `Filter`는 `HttpServletRequest`, `HttpServletResponse`를 수정한다.
- `Filter`는 호출될 때 `FilterChain`을 파라미터로 함께 받아서 다음 `Filter`를 연쇄적으로 호출한다.

```java
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
	// do something before the rest of the application
    chain.doFilter(request, response); // invoke the rest of the application
    // do something after the rest of the application
}
```

### DelegatingFilterProxy와 FilterChianProxy

![](assets/Pasted%20image%2020240401012303.png)

- Spring은 `Filter`의 구현체인 `DelegatingFilterProxy`를 제공한다.
- 서블릿 컨테이너는 Spring Bean을 인식하지 못하기 때문에 `ApplicationContext`에 접근해서 동작이 필요한 경우에는, `DelegatingFilterProxy`를 통해 Bean으로 정의된 `Filter`에게 작업을 위임하는 방법을 사용한다.
- 아래는 `DelegatingFilterProxy`의 수도 코드다.

```java
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
	Filter delegate = getFilterBean(someBeanName);
	delegate.doFilter(request, response);
}
```

![](assets/Pasted%20image%2020240401020940.png)

- `FilterChainProxy`는 Spring Security에서 제공하는 특수 필터로, `SecurityFilterChain`을 통해 여러 필터 인스턴스에 위임할 수 있다.
	- `FilterChianProxy`는 Bean이기 때문에 `DelegatingFilterProxy`로 래핑된다.
	- `FilterChainProxy`는 `RequestMatcher` 인터페이스를 사용해 `HttpServletRequest`로부터 사용할 `SecurirtyFilterChain`을 선택할 수 있다.

## 인증(Authentication)

### SecurityContextHolder

![](assets/Pasted%20image%2020240401025726.png)

- `SecurityContextHolder`는 `SecurityContext`를 포함하고 있다.
	- 기본적으로 `SecurityContextHolder`는 `ThreadLocal` 을 사용해서 저장한다.
	- `ThreadLocal` 을 사용하고 싶지 않으면 `SecurityContextHolder`에 다른 전략을 사용해야된다.
- `Authentication` 인터페이스는 2가지 목적으로 사용된다.
	- 사용자가 인증을 위해 `AuthenticationManager`에 `credentials`를 제공한다. `credentials`는 주로 비밀번호다. 이때 `isAuthenticated()`는 `false`를 반환한다.
	- 현재 인증된 유저를 나타낸다. 인증되어 있으면 `SecurityContext`에 `Authentication`이 존재한다.
		- `principal`: 식별된 유저. 주로 `UserDetails`의 인스턴스다.
		- `authirities`: 유저에게 주어진 권한. roles, scopes 등이 있다.

### AuthenticationManager

![](assets/Pasted%20image%2020240401031232.png)

- Spring Security의 필터가 인증을 수행하는 방법을 정의하는 API
- 반환된 `Authentication`은 `SecurityContextHodler`에 설정된다.
- `AuthenticationManager`의 가장 흔히 사용되는 구현체는 `ProviderManager`이다.
- `ProviderManager`는 `AuthenticationProvider`의 리스트로 위임한다.
- `AuthenticationProvider`는 인증을 성공, 실패, 다음 `AuthenticationProvider`에게 결정하도록 허용할 수 있다.

### AbstractAuthenticationProcessingFilter

- 사용자의 credentials를 인증하기 위한 베이스 `Filter`
- `AuthenticationEntryPoint`를 사용해서 credentials를 요청할 수 있다.
- 인증 과정
	1. credentials를 제출하면, `AbstractAuthenticationProcessingFilter`는 `HttpServletRequest`로 부터 `Authentication`를 만든다.
		- 예시: 서브 클래스인 `UsernamePasswrodAuthenticationFilter`의 경우는 username과 password로 `UsernamePasswordAuthenticationToken`를 만든다.
	2. `AuthenticationManager`에 `AuthenticationManager`가 전달된다.
	3. 인증에 실패한 경우
		1. `SecurityContextHolder`가 clear 된다.
		2. `RememberMeServices.loginFail`이 호출된다.
		3. `AuthenticationFailureHandler`가 호출된다.
	4. 인증에 성공한 경우
		1. `SessionAuthenticationStrategy`에 새로운 로그인 알림을 받는다.
		2. `Authentication`이 `SecurityContextHolder`에 설정된다.
		3. `RememberMeServices.loginSuccess`가 호출된다.
		4. `ApplicationEventPublisher`가 `InteractiveAuthenticationSuccessEvent`를 발행한다.
		5. `AuthenticationSuccessHandler`가 호출된다.
- ![](assets/Pasted%20image%2020240401033503.png)
