# TestRestTemplate 시작하기

`@SpringBootTest` 로 특정 포트에 애플리케이션을 실행하면 `TestRestTemplate` 이 자동 주입된다.

```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
public class ApiTest{

	@Autowired
  protected TestRestTemplate testRestTemplate;
}
```

## GET 요청

```java
ResponseEntity<Dto> response = testRestTemplate.getForEntity(FOO_RESOURCE_URL + "/1", Dto.class);

assertThat(response.getStatusCode(), equalTo(HttpStatus.OK));
```

파라미터로 응답 바디를 쉽게 특정 타입으로 변환할 수 있다.

## 참고 자료

[https://www.baeldung.com/rest-template](https://www.baeldung.com/rest-template)

[https://www.baeldung.com/spring-boot-testresttemplate](https://www.baeldung.com/spring-boot-testresttemplate)