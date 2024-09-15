---
tags:
  - Spring-REST-Docs
title: RestAssured로 Rest docs 사용하기
---

MockMvc로 사용중인 Spring rest docs를 RestAssured로 바꿔보자.

## 의존 추가

```java
testImplementation 'org.springframework.restdocs:spring-restdocs-restassured'
```

## 테스트 코드

```java
private RequestSpecification spec;

@BeforeEach
public void setUp(RestDocumentationContextProvider restDocumentation) {
	this.spec = new RequestSpecBuilder()
			.addFilter(documentationConfiguration(restDocumentation)) 
			.build();
}
```

body 내용을 예쁘게 표시하고 싶다면 아래와 같이 구성하면된다.

```java
@BeforeEach
protected void setUp(final RestDocumentationContextProvider restDocumentation) throws Exception {
    this.specification = new RequestSpecBuilder()
        .addFilter(documentationConfiguration(restDocumentation).operationPreprocessors()
            .withResponseDefaults(prettyPrint()))
        .build()
;
```

rest api 호출

```java
RestAssured.given(this.spec) 
		.accept("application/json") 
		.filter(document("index")) 
		.when().get("/") 
		.then().assertThat().statusCode(is(200));
```

필드 설명을 추가하고 싶다면 아래와 같이 필터를 지정하면 된다.

```java
RestAssured.given(this.spec).accept("application/json")
	.filter(document("user", responseFields( 
			fieldWithPath("contact.name").description("The user's name"), 
			fieldWithPath("contact.email").description("The user's email address")))) 
	.when().get("/user/5")
	.then().assertThat().statusCode(is(200));
```

## 참고 자료

[https://docs.spring.io/spring-restdocs/docs/current/reference/html5/#getting-started-documentation-snippets](https://docs.spring.io/spring-restdocs/docs/current/reference/html5/#getting-started-documentation-snippets)
