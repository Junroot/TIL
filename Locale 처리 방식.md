---
tags:
  - Spring-MVC
title: Locale 처리 방식
---


## 목표

- locale이 무엇인지 이해한다.
- Spring에서 locale을 어떻게 처리하는지 이해한다.

## Locale

- 지리적, 문화적, 정치적 지역을 나타내는 역할을 가지는 클래스
- 언어, 국가 등을 표현한다. 

## Spring에서 Locale 처리 방법

- Spring 애플리케이션에서 요청자의 지역에 따라 다른 언어를 표시하기 위해서는 현재 Locale을 결정하는 방법이 있어야 된다.
- `DispatcherServlet`은 locale resolver를 찾고, 찾은 locale resolver를 통해서 locale을 지정하려고 시도한다.
	- `RequestContext.getLocale()` 메서드 호출을 통해 locale resolver가 설정한 locale을 확인해 볼 수 있다.

### LocaleResolver

- `LocaleResolver`: locale을 선택하기 위한 전략을 나타내는 전략 인터페이스
- 대표적인 기본 구현체
	- `AcceptHeaderLocaleResolver`: HTTP 요청의 `Accept-Language` 헤더를 통해 locale을 선택한다. 해당 locale resolver는 locale을 직접 수정할 수는 없다.
	- `CookieLocaleResolver`: 클라이언트에 있는 쿠키 값을 확인해서 locale을 확인할 수 있다. 이 때, 사용할 cookie 이름은 자유롭게 수정할 수 있다.
	- `SessionLocaleResolver`: `HttpSession` 의 attribute를 통해서 locale을 확인한다.
- Spring boot는 기본적으로 `AccepHeaderLocaleResolver`를 사용하고 다른 구현체를 사용하려면 bean으로 등록하면 된다.

### LocaleChangeInterceptor

- `LocaleChangeInterceptor`를 통해 request paramter에 따라 `Locale` 설정이 가능하도록 구성할 수 있다.
	- 아래와 같이 bean으로 등록하고 `WebMvcConfigurer` 인터페이스인 config 클래스에 등록하면, `lang` request parameter에 지정된 값에 따라 자동으로 locale이 변경된다.

```java
@Bean
public LocaleChangeInterceptor localeChangeInterceptor() {
    LocaleChangeInterceptor lci = new LocaleChangeInterceptor();
    lci.setParamName("lang");
    return lci;
}

@Override
public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(localeChangeInterceptor());
}
```

## 참고 자료

- https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-servlet/localeresolver.html
- https://www.baeldung.com/spring-boot-internationalization
