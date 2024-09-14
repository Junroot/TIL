---
tags:
  - Spring-Framework
---
# WebClient로 URL parameter 보내기

## 목표

- Spring 에서 제공하는 `WebClient`로 HTTP 요청을 보낼 때, URL parameter를 전송하는 방법을 알아본다.

## parameter 보내기

```java
webClient.get()
  .uri(uriBuilder - > uriBuilder
    .path("/products/")
    .queryParam("name", "{name}")
    .build("asdf+asdf"))
  .retrieve()
  .bodyToMono(String.class)
  .onErrorResume(e -> Mono.empty())
  .block();
```

- 위와 같이 작성하면 `/products?name=asdf%2asdf` 로 요청이 보내지는 것을 확인할 수 있다.

## 주의점

- 아래와 같이 쿼리 파라미터를 넘기면 예상치 못한 방식으로 URL 인코딩이 될 수 있기 때문에 주의해야된다.
- 아래와 같이 요청을 보내면 '+' 문자가 URL 인코딩 되지 않고 요청이 보내진다.
	- `/products%3Fname=asdf+asdf`
	- 반대로 '?' 문자는 인코딩 되어버린다.

```java
webClient.get()
  .uri("/products?name=asdf+asdf")
  .retrieve()
  .bodyToMono(String.class)
  .onErrorResume(e -> Mono.empty())
  .block();
```

- 아래와 같이 요청을 보내면 '+' 문자가 URL 인코딩 되지 않고 요청이 보내진다.
	- `/products?name=asdf+asdf`

```java
webClient.get()
  .uri(uriBuilder - > uriBuilder
    .path("/products/")
    .queryParam("name", "asdf+asdf")
    .build())
  .retrieve()
  .bodyToMono(String.class)
  .onErrorResume(e -> Mono.empty())
  .block();
```

- `queryParam()` 메서드의 javadoc을 읽어보면, 파라미터의 이름과 값 부분에 '=', '&', '+' 같이 허용되지 않는 문자를 인코딩한다는 내용을 볼 수 있다.
	- ![](assets/Pasted%20image%2020240626135532.png)
- '+'를 인코딩하지 않고 요청을 보냈을 때 문제점
	- application/x-www-form-urlencoded 형식에서는 공백 문자를 %20 대신 '+'로 인코딩하기 때문에 공백 문자로 디코딩될 수 있다.
	- https://www.baeldung.com/java-urlencoder-translate-space-characters
	- 따라서, 요청받은 서버에서는 `/products?asdf asdf`로 처리될 수 있다는 뜻이다.

## 참고 자료

- https://www.baeldung.com/java-urlencoder-translate-space-characters
- https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-uri-building.html
- https://www.baeldung.com/webflux-webclient-parameters