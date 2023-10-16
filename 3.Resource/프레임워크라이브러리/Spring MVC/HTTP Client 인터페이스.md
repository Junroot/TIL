# HTTP Client 인터페이스

## 목표

- Spring 6의 HTTP Client 인터페이스가 무엇인지 이해한다.
- Spring 6의 HTTP Client 인터페이스의 사용법을 이해한다.

## HTTP Client 인터페이스

- Spring Framework 6와 Spring Boot 3부터 사용 가능한 기능
- Feign과 같은 클라이언트 라이브러리와 같이 인터페이스를 기반으로 HTTP 요청을 보내고 응답을 받을 수 있는 기능을 제공한다.

## 사용법

### 인터페이스 정의

- 인터페이스 메소드에 어노테이션을 붙이면 된다.
- 사용 가능한 파라미터
	- `URI`: 요청에 대한 URL을 동적으로 설정한다.
	- `HttpMethod`: 요청에 대한 HTTP 메서드를 동적으로 설정한다.
	- `@RequestHeader`: 요청 헤더 
	- `@RequestBody`: 요청 바디
	- `@RequestParam`: 요청 매개변수
	- `@CookieValue`: 쿠키 이름과 값
- 사용 가능한 반환 타입
	- `void`, `Mono<Void>`
	- `HttpHeaders`, `Mono<HttpHeaders>`
	- `<T>`, `Mono<T>`
	- `<T>`, `Flux<T>`
	- `ResponseEntity<T>`, `Mono<ResponseEntity<T>>`
	- `Mono<ResponseEntity<Flux<T>>`

```java
interface BooksService {

    @GetExchange("/books")
    List<Book> getBooks();

    @GetExchange("/books/{id}")
    Book getBook(@PathVariable long id);

    @PostExchange("/books")
    Book saveBook(@RequestBody Book book);

    @DeleteExchange("/books/{id}")
    ResponseEntity<Void> deleteBook(@PathVariable long id);
}
```

### 클라이언트 생성

- `HttpServiceProxyFactory` 를 통해서 클라이언트를 생성한다.

```java
WebClient webClient = WebClient.builder()
  .baseUrl(serviceUrl)
  .build();
  
HttpServiceProxyFactory httpServiceProxyFactory = HttpServiceProxyFactory
  .builder(WebClientAdapter.forClient(webClient))
  .build();
  
booksService = httpServiceProxyFactory.createClient(BooksService.class);
```

- 아래와 같이 상태 코드에 따른 예외처리도 가능하다.
	- 따로 설정하지않으면 4xx 또는 5xx 응답 코드에 대해서 `WebClientResponseException`을 발생시킨다.

```java
BooksClient booksClient = new BooksClient(WebClient.builder()
  .defaultStatusHandler(HttpStatusCode::isError, resp ->
    Mono.just(new MyServiceException("Custom exception")))
  .baseUrl(serviceUrl)
  .build());
```

## 참고 자료

- https://www.baeldung.com/spring-6-http-interface