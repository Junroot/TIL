---
tags:
  - 도서/Spring-in-Action
---

# 리액티브 API 개발하기

- 스프링 WebFlux: 스프링 5의 새로운 리액티브 웹 프레임워크

## 스프링 WebFlux 사용하기

- 스프링MVC 같은 전형적인 서블릿 기반의 웹 프레임워크는 스레드 블로킹과 다중 스레드로 수행된다.
	- 기본적으로 하나의 요청 당 하나의 스레드가 처리하고, 하나의 스레드 내에서 대부분의 상호 작용이 블록킹된다.
	- ![](assets/Pasted%20image%2020230904210443.png)
- 블로킹 웹 프레임워크는 요청량의 증가에 따른 확장이 어렵다.
	- 처리가 느린 작업 스레드로 인해 스레드 풀로 반환되어 또 다른 요청 처리를 준비하는 데 많은 시간이 걸린다.
- 비동기 웹 프레임워크는 적은 수의 스레드로 더 높은 확장성을 성취한다. 
	- 이벤트 루핑(event looping)이라는 기법을 적용한 프레임워크는 한 스레드당 많은 요청을 처리할 수 있어서 한 연결당 소요 비용이 더 경제적이다.
	- 데이터베이스나 네트워크 작업과 같은 집중적인 작업의 콜백과 요청들은 모두 이벤트로 처리된다.
	- 비용이 드는 작업이 필요할 때 이벤트 루프는 해당 작업이 콜백을 등록하여 병행으로 수행되게하고 다른 이벤트 처리로 넘어간다.
	- ![](assets/Pasted%20image%2020230904204146.png)

### 스프링 WebFlux 개요

- WebFlux는 리액티브 프로그래밍 모델을 스프링 MVC에 억지로 집어넣는 대신에 가능한 많은 것을 스프링 MVC로부터 가져와서 별도의 리액티브 웹 프레임워크를 만들기로 결정했다.
- ![](assets/Pasted%20image%2020230906210559.png)
	- 왼쪽이 스프링 MVC 스택, 오른쪽이 스프링 WebFlux 스택
	- 스프링 WebFlux는 서블릿 API에 연결되지 않으므로 실행하기 위해 서블릿 컨테이너를 필요하지 않는다. 대신에 블로킹이 없는 어떤 웹 컨테이너도 실행될 수 있다.
	- 스프링 MVC 애노테이션들은 WebFlux와 공유된다.
	- RouterFunction은 애노테이션 대신 함수형 프로그래밍 패러다임으로 컨트롤러를 정의하는 대안 프로그래밍 모델이다.
	- WebFlux를 사용할 때는 기본적인 내장 서버가 톰캣 대신 Netty가 된다.
		- Netty는 몇 안되는 비동기적인 이벤트 중심의 서버 중 하나며, 리액티브 웹 프레임워크에 잘 맞는다.
	- 컨트롤러 메서드는 도메인 타입이나 컬렉션 대신 `Mono`나 `Flux`같은 리액티브 타입을 인자로 받거나 반환한다. 또한 `Observable`, `Single`, `Completable` 과 같은 RxJava 타입도 처리할 수 있다.
- 스프링 MVC도 컨트롤러 메서드로 `Mono`나 `Flux`를 반환할 수 있다. 
	- 하지만 WebFlux는 요청이 이벤트 루프로 처리되는 반면,
	- 스프링 MVC는 다중 스레드에 의존하여 다수의 요청을 처리하는 서블릿 기반 웹 프레임워크다.

### 리액티브 컨트롤러 작성하기

- 의존성 추가

```xml
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-webflux</artifactId>  
</dependency>
```

- 아래 사진과 같이 `Flux` 반환 타입을 가진 컨트롤러의 메서드를 추가할 수 있다.
	- ![](assets/Pasted%20image%2020230906212910.png)
	- 이 때 `TacoRepository`는 `ReactiveCrudRepository`를 상속하도록 해야된다.
		- ![](assets/Pasted%20image%2020230906213010.png)
		- ![](assets/Pasted%20image%2020230906220304.png)
	- `@RestController`와 `@GetMapping`을 그대로 사용할 수 있다는 것을 확인할 수 있다.
- 리액티브하게 입력 처리하기
	- ![](assets/Pasted%20image%2020230906221426.png)
	- `saveAll()`메서드는 `Mono`나 `Flux`를 포함해서 리액티브 스트림의 `Publisher` 인터페이스를 구현한 어떤 타입도 인자로받을 수 있다.
	- `saveAll()` 메서드는 `Mono<Taco>`를 입력으로 받으므로 요청 몸체로부터 `Taco` 객체가 분석되는 것을 기다리지 않고 즉시 호출된다. 그리고 리퍼지터리 또한 리액티브이므로 `Mono`를 받아 즉시 `Flux<Taco>`를 반환한다.
	- 이전 Spring MVC의 입력이었을 경우
		- 요청 페이로드가 완전하게 분석되어 `Taco` 객체를 생성하는데 까지 블록킹되고, 리포지토리의 `save()` 메서드의 호출이 끝날 때 까지 블록킹된다.

## 함수형 요청 핸들러 정의하기

- 애노테이션 기반 프로그래밍
	- 애노테이션 자체는 '무엇'을 정의하며, '어떻게'는 프레임워크 코드 어딘가에 정의되어 있다.
	- 이로 인해 프로그래밍 모델을 커스터마이징하거나 확장할 때 복잡해진다.
		- 애노테이션 외부에 있는 코드로 작업해야 하기 때문이다.
- WebFlux는 애노테이션 기반을 대안으로 리액티브 API를 정의하기 위한 새로운 함수형 프로그래밍 모델이 소개되었다.
- 함수형 프로그래밍 모델을 사용한 API 작성에는 4가지 기본 타입이 수반된다.
	- `RequestPrediate`: 처리될 요청의 종류를 선언한다.
		- `RequestPredicates.GET`, `RequestPredicates.POST` 함수가 `RequestPredicate`를 반환한다.
	- `RouterFunction`: 일치하는 요청이 어떻게 핸들러에게 전달되어야 하는지를 선언한다.
		- `RouterFunctions.route()` 함수가 `RouterFunction`을 반환한다.
		- `RouterFunctions.route()` 함수의 2가지 파라미터
			- `RequestPredicate` 
			- 일치하는 요청을 처리하는 함수
		- `andRoute()`를 통해서 여러개의 요청을 매핑할 수 있다.
	- `ServerRequest`: HTTP 요청을 나타내며, 헤더와 몸체 정보를 사용할 수 있다.
	- `ServerResponse`: HTTP 응답을 나타내며, 헤더와 몸체 정보를 포함한다.

```kotlin
import junroot.study.tacos.Taco  
import junroot.study.tacos.data.TacoRepository  
import org.springframework.context.annotation.Bean  
import org.springframework.context.annotation.Configuration  
import org.springframework.web.reactive.function.server.RequestPredicates.GET  
import org.springframework.web.reactive.function.server.RequestPredicates.POST  
import org.springframework.web.reactive.function.server.RouterFunction  
import org.springframework.web.reactive.function.server.RouterFunctions.route  
import org.springframework.web.reactive.function.server.ServerRequest  
import org.springframework.web.reactive.function.server.ServerResponse  
import reactor.core.publisher.Mono  
import java.net.URI  
  
@Configuration  
class RouterFunctionConfig(  
    val tacoRepository: TacoRepository  
) {  
  
    @Bean  
    fun routerFunction(): RouterFunction<*> {  
       return route(GET("/design/taco"), this::recents)  
          .andRoute(POST("design"), this::postTaco)  
    }  
  
    fun recents(request: ServerRequest): Mono<ServerResponse> {  
       return ServerResponse.ok()  
          .body(tacoRepository.findAll().take(12), Taco::class.java)  
    }  
  
    fun postTaco(request: ServerRequest): Mono<ServerResponse> {  
       return request.bodyToMono(Taco::class.java)  
          .flatMap { tacoRepository.save(it) }  
          .flatMap {  
             ServerResponse.created(URI("http://localhost:8080/design/taco/${it.id}"))  
                .body(it, Taco::class.java)  
          }  
    }  
}
```

## 리액티브 컨트롤러 테스트하기

- `WebTestClient`: 리액티브 컨트롤러의 테스트를 쉽게 작성하기 위핸 테스트 유틸리티

### GET 요청 테스트하기

- `WebTestClient.bindToController()`를 사용하여 `WebTestClient` 인스턴스가 생성된다.

```kotlin
@Test  
fun shouldReturnRecentTacos() {  
    val tacos = ArrayList((1..16).map { testTaco(it.toLong()) })  
    val tacoFlux = Flux.fromIterable(tacos)  
  
    val tacoRepository = Mockito.mock(TacoRepository::class.java)  
    given(tacoRepository.findAll()).willReturn(tacoFlux)  
  
    val testClient = WebTestClient.bindToController(  
       DesignTacoController(tacoRepository)  
    ).build()  
  
    testClient.get().uri("/design/recent")  
       .exchange() // 요청 보냄  
       .expectStatus().isOk // 응답 코드 검사  
       .expectBody()  
       .jsonPath("$").isArray  
       .jsonPath("$").isNotEmpty  
       .jsonPath("$[0].id").isEqualTo(tacos[0].id.toString())  
}  
  
private fun testTaco(number: Long): Taco {  
    val ingredients = listOf(  
       Ingredient("INGA", "Ingredient A", Ingredient.Type.WRAP),  
       Ingredient("INGB", "Ingredient B", Ingredient.Type.PROTEIN)  
    )  
  
    return Taco(number, Date(), "Taco $number", ingredients)  
}
```

- `expectBodyList()`를 사용하면 어서션을 수행할 `ListBodySpec` 객체를 반환한다.

```kotlin
testClient.get().uri("/design/recent")  
    .exchange() // 요청 보냄  
    .expectStatus().isOk // 응답 코드 검사  
    .expectBodyList(Taco::class.java)  
    .contains(*tacos.copyOf(12))
```

### POST 요청 테스트하기

```kotlin
@Test  
fun shouldSaveATaco() {  
    val tacoRepository = Mockito.mock(TacoRepository::class.java)  
    val unsavedTacoMono = Mono.just(testTaco(null))  
    val savedTaco = testTaco(1L)  
    val savedTacoMono = Mono.just(savedTaco)  
    given(tacoRepository.save(any())).willReturn(savedTacoMono)  
  
    val testClient = WebTestClient.bindToController(  
       DesignTacoController(tacoRepository)  
    ).build()  
  
    testClient.post()  
       .uri("/design")  
       .body(unsavedTacoMono, Taco::class.java)  
       .exchange()  
       .expectStatus().isCreated  
       .expectBody(Taco::class.java).isEqualTo(savedTaco)  
}
```

### 실행 중인 서버로 테스트하기

- `@RunWith`와 `@SpringBootTest` 애노테이션을 테스트 클래스에 지정하면 `WebTestClient`를 자동 연결할 수 있다.
	- ![](assets/Pasted%20image%2020230910164524.png)

## REST API를 리액티브하게 사용하기

- 스프링 5가 `RestTemplate`의 리액티브 대안으로 `WebClient`를 제공한다.
- `WebClient`의 사용한 `RestTemplate`과 다르게, 요청을 나타내고 전송하게 해주는 빌더 방식의 인터페이스를 사용한다.
- `WebClient`를 사용하는 일반적인 패턴
	- `WebClient`의 인스턴스를 생성한다.
	- 요청을 전송할 HTTP 메서드를 지정한다.
	- 요청에 필요한 URI와 헤더를 지정한다.
	- 요청을 제출한다.
	- 응답을 소비한다.

### 리소스 얻기(GET)

- ![](assets/Pasted%20image%2020230910165832.png)
- 결과 `Flux`를 구독하지 않으면 이 요청은 결코 전송되지 않을 것이므로 `subscribe()` 메서드를 호출하는 코드가 제일 끝에 추가된다.
- `WebClient.create()` 메서드로 빈을 생성해두면 기본 URI을 지정해둘 수 있다.
	- ![](assets/Pasted%20image%2020230910170016.png)
	- ![](assets/Pasted%20image%2020230910170026.png)
- 느린 네트워크나 서비스 때문에 클라이언트의 요청이 지체되는 것을 방지하기 위해 `Flux`나 `Mono`의 `timeout()` 메서드를 사용해서 데이터를 기다리는 시간을 제한할 수 있다.
	- 제한 시간안에 데이터를 가져오지 못하면 `subscribe()`의 두번제 인자로 지정된 에러 핸들러가 호출된다.
	- ![](assets/Pasted%20image%2020230910170227.png)

### 리소스 전송하기

- ![](assets/Pasted%20image%2020230910171056.png)
- 만약 전송할 `Mono`나 `Flux`가 없는 댓니 도메인 객체가 있다면 `syncBody()`를 사용할 수 있다.
	- ![](assets/Pasted%20image%2020230910171119.png)
- 응답 페이로드가 비어있는 경우 `bodyToMono`에 `Void.class`를 인자로 전달해야된다.
	- ![](assets/Pasted%20image%2020230910171214.png)

### 에러 처리하기

- 에러를 처리할 때 `onStatus()` 메서드를 호출하여, 처리해야 할 HTTP 상태코드를 지정할 수 있다.
	- ![](assets/Pasted%20image%2020230910171942.png)
	- ![](assets/Pasted%20image%2020230910171949.png)
- 위 사진과 같이 커스텀 예외를 던지면, `subscribe()`시에 예외에 따른 핸들링 처리가 가능하다.
	- ![](assets/Pasted%20image%2020230910172116.png)

### 요청 교환하기

- `retrive()` 메서드는 `ResponseSpec` 타입의 객체를 반환하며, 이 객체를 통해서 `onStatus()`, `bodyToFlux()`, `bodyToMono()`와 같은 메서드를 호출하여 응답을 처리한다.
- 응답의 헤더나 쿠키 값을 사용할 필요가 있을 때는 `ResponseSpec`으로 처리할 수 없다.
- `exchange()`를 호출하면 `Mono<ClientResponse>` 값을 반환한다.
- `Mono<ClientResponse>`에서 원하는 객체의 `Mono`값을 가지고 오려면 아래와 같이 처리할 수 있다.
	- ![](assets/Pasted%20image%2020230910173133.png)
- 헤더 검사 예시
	- ![](assets/Pasted%20image%2020230910173157.png)

## 리액티브 웹 API 보안

- 스프링 MVC의 스프링 시큐리티는 서블릿 필터를 중심으로 만들어졌다.
- 스프링 WebFlux로 웹 애플리케이션을 작성할 때는 서블릿이 아닌 Netty나 non-서블릿 서버에 구축될 가능성이 많다.
- 스프링 시큐리티는 5.0.0 버전부터 스프링 MVC와 리액티브 스프링 WebFlux 애플리케이션 모두 보아넹 사용할 수 있다.
	- 스프링의 `WebFilter`가 서블릿 API 의존하지 않고 스프링 특유의 서블릿 필터 역할을 해준다.
- 스프링 시큐리티는 스프링 MVC와 동일한 스프링 부터 보안 스타터를 사용한다.

### 리액티브 웹 보안 구성하기

- 스프링 MVC의 시큐리티 구성

```kotlin
@EnableWebSecurity  
@Configuration  
class SecurityConfig {  
    @Bean  
    fun filterChain(http: HttpSecurity): SecurityFilterChain {  
       return http.authorizeRequests()  
          .antMatchers("/design", "/orders")  
          .hasRole("USER")  
          .antMatchers("/", "/**")  
          .permitAll()  
          .and()  
          .build()  
    }  
}
```

- WebFlux의 시큐리티 구성

```kotlin
@EnableWebFluxSecurity  
@Configuration  
class SecurityConfig {  
    @Bean  
    fun filterChain(http: ServerHttpSecurity): SecurityWebFilterChain {  
       return http.authorizeExchange()  
          .pathMatchers("/design", "/orders")  
          .hasRole("USER")  
          .pathMatchers("/", "/**")  
          .permitAll()  
          .and()  
          .build()  
    }
}
```

### 리액티브 사용자 명세 서비스 구성하기

- 스프링 MVC의 사용자 명세 서비스

```kotlin
@Service  
class UserRepositoryUserDetailsService(  
    val userRepository: UserRepository  
): UserDetailsService {  
  
    override fun loadUserByUsername(username: String): UserDetails {  
       return userRepository.findByUsername(username)  
          ?: throw UsernameNotFoundException("User '${username}' not found")  
    }  
}
```

- WebFlux의 사용자 명세 서비스

```kotlin
@Service  
class UserRepositoryUserDetailsService(  
    val userRepository: UserRepository  
): ReactiveUserDetailsService {  
  
    override fun findByUsername(username: String): Mono<UserDetails> {  
       return userRepository.findByUsername(username)  
          .mapNotNull { it }  
    }  
  
}
```