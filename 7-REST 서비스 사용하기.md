---
tags:
  - 도서/Spring-in-Action
title: 7-REST 서비스 사용하기
---



- 스프링 애플리케이션이 REST API를 사용하는 방법들
	- `RestTemplate`: 스프링 프레임워크에서 제공하는 간단하고 동기화된 REST 클라이언트
	- `Traverson`: 스프링 HATEOAS에서 제공하는 하이퍼링크를 인식하는 동기화 REST 클라이언트로 같은 이름의 자바스크립트 라이브러리로부터 비롯된 것이다.
	- `WebClient`: 스프링 5에서 소개된 반응형 비동기 REST 클라이언트

## RestTemplate로 REST 엔드포인트 사용하기

- JDBC를 사용을 `JdbcTemplate`이 처리하듯이, `RestTempalte`은 REST 리소스를 사용할는데 번잡한 일을 처리해준다.
- `RestTemplate`은 REST 리소스와 상호작용하기 위한 41개의 메서드를 제공한다.
	- 고유한 작업을 수행하는 메서드는 12개이고, 나머지는 이 메서드의 오버로딩된 버전이다.
- ![](assets/Pasted%20image%2020230708203035.png)
- 위 메서드들을 세 가지 형태로 오버로딩 되어 있다.
	- 가변 인자 리스트에 지정된 URL 매개변수에 URL 문자열(`String` 타입)을 인자로 받는다.
	- `Map<String, String>`에 지정된 URL 매개변수에 URL 문자열을 인자로 받는다.
	- `URI`를 URL에 대한 인자로 받으며, 매개변수화된 URL은 지원하지 않는다.
- `RestTemplate`를 사용하러면 우리가 필요한 시점에 인스턴스를 생성하거나, 빈으로 선언하고 필요할 때 주입한다.

```kotlin
val restTemplate: RestTemplate = RestTemplate()

// 또는

@Bean
fun restTemplate: RestTemplate() {
	return RestTemplate()
}
```

- 예시) 리소스 가져오기(GET)

```kotlin
restTemplate.getForObject("http://localhost:8080/ingredients/{id}", Ingredient.class, ingredientId)
```

## Traverson으로 REST API 사용하기

- `Traverson`은 스프링 데이터 HATEOAS에 같이 제공되며, 스프링 애플리케이션 하이퍼미디어 API를 사용할 수 있는 솔루션이다.
- `Traverson`을 시작할 때 해당 API의 기본 URI을 갖는 객체를 생성해야 한다.

```kotlin
val traverson = Traverson(URI.create("http://localhost:8080/api"), MediaTypes.HAL_JSON)
```

- 기본 URI에서 시작해서 각 링크의 관계 이름으로 API를 사용한다.
- `CollectionModel<Taco>` 타입의 객체로 읽어 들여야 하는데, 자바에서는 런타임 시에 제네릭 타입의 타입 정보가 소거되어 리소스 타입을 지정하기 어렵다. 그러나 `ParameterizedTypeReference`를 생성하면 리소스 타입을 지정할 수 있다.
- `follow()` 메서드의 체인으로 홈 리소스에서 시작해서 원하는 리소스로 이동할 수 있다.
	- 또는 두 개 이상의 관계 이름들을 인자로 나열하라 한 번만 호출할 수 있다.
	- ![](assets/Pasted%20image%2020230708221523.png)
	- ![](assets/Pasted%20image%2020230708221447.png)
	- 서버 액세스 로그: ![](assets/Pasted%20image%2020230708221605.png)
