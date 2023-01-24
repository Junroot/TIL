# Spring Framework에서 멀티 모듈 사용해보기

이 글은 Spring Framework에서 멀티 모듈을 적용하면서 겪은 트러블 슈팅들을 정리한 글이다. 멀티 모듈은 Gradle을 통해 적용했으므로 아래 글을 먼저 진행한 뒤의 트러블 슈팅이다.

[Gradle로 멀티 모듈 환경 구성하기](../Gradle%209ec51bd5a84a42f08fe9988bca7e9ce9/Gradle%E1%84%85%E1%85%A9%20%E1%84%86%E1%85%A5%E1%86%AF%E1%84%90%E1%85%B5%20%E1%84%86%E1%85%A9%E1%84%83%E1%85%B2%E1%86%AF%20%E1%84%92%E1%85%AA%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%209334b3bd938a4ead8fadc5fe9b3785c2.md) 

## 모듈 및 패키지 구조

크게 api, client, core라는 모듈로 나뉘어지고, api와 client는 core 모듈의 의존한 상태다. 이후 소개할 트러블 슈팅들은 api와 core 사이의 관계로 설명하겠다. api 모듈과 core 모듈은 아래의 디렉터리 구조를 가지고 있다.

![Untitled](Spring%20Framework%E1%84%8B%E1%85%A6%E1%84%89%E1%85%A5%20%E1%84%86%E1%85%A5%E1%86%AF%E1%84%90%E1%85%B5%20%E1%84%86%E1%85%A9%E1%84%83%E1%85%B2%E1%86%AF%20%E1%84%89%E1%85%A1%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A2%E1%84%87%E1%85%A9%E1%84%80%E1%85%B5%20c1232838c0434da0a5d661c94b41aeed/Untitled.png)

![Untitled](Spring%20Framework%E1%84%8B%E1%85%A6%E1%84%89%E1%85%A5%20%E1%84%86%E1%85%A5%E1%86%AF%E1%84%90%E1%85%B5%20%E1%84%86%E1%85%A9%E1%84%83%E1%85%B2%E1%86%AF%20%E1%84%89%E1%85%A1%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A2%E1%84%87%E1%85%A9%E1%84%80%E1%85%B5%20c1232838c0434da0a5d661c94b41aeed/Untitled%201.png)

아래는 main 메서드가 있는 클래스의 코드다.

```java
@SpringBootApplication
public class HyNoticeApplication {

    public static void main(String[] args) {
        SpringApplication.run(HyNoticeApplication.class);
    }
}
```

## 트러블 슈팅

### Parameter 0 of constructor in hynotice.api.presentation.controller.RssFeedController required a bean of type 'hynotice.core.domain.repository.PostRepository' that could not be found.

PostRepository를 스프링에서 찾지 못해서 발생한 문제다. `@SpringBootApplication` 은 기본적으로 자신의 하위 디렉터리만 스캔하기 때문에 다른 패키지의 레포지토리는 스캔하지 못한다.

일반적인 컴포넌트 였다면 *`@SpringBootApplication***(**scanBasePackages = "hynotice"**)`** 의 방법으로 스캔할 패키지 경로를 설정하면 되지만 레포지토리는 별도의 어노테이션을 추가해줘야 했다.

`@EnableJpaRepositories` 어노테이션으로 패키지 경로를 지정해주면 된다.

```java
@EnableJpaRepositories(basePackages = "hynotice")
@SpringBootApplication(scanBasePackages = "hynotice")
public class HyNoticeApplication {

    public static void main(String[] args) {
        SpringApplication.run(HyNoticeApplication.class);
    }
}
```

### nested exception is java.lang.IllegalArgumentException: Not a managed type: class hynotice.core.domain.Post

엔티티를 찾지 못해서 발생한 문제다. `@Entity` 어노테이션도 `@Component` 어노테이션과 비슷하게 스프링에서 특정 경로를 스캔한 클래스만 엔티티로 관리해준다. 이 스캔할 대상을 지정하는 방법이 `@EntityScan` 어노테이션을 사용하는 것이다.

```java
@EntityScan("hynotice")
@EnableJpaRepositories(basePackages = "hynotice")
@SpringBootApplication(scanBasePackages = "hynotice")
public class HyNoticeApplication {

    public static void main(String[] args) {
        SpringApplication.run(HyNoticeApplication.class);
    }
}
```

## 참고 자료

[https://stackoverflow.com/questions/54382641/spring-boot-multi-module-with-data-jpa-not-working](https://stackoverflow.com/questions/54382641/spring-boot-multi-module-with-data-jpa-not-working)

[https://stackoverflow.com/questions/40973311/spring-boot-spring-data-maven-modules-illegalargumentexception-not-a-manag/41221750](https://stackoverflow.com/questions/40973311/spring-boot-spring-data-maven-modules-illegalargumentexception-not-a-manag/41221750)

[https://www.baeldung.com/spring-entityscan-vs-componentscan](https://www.baeldung.com/spring-entityscan-vs-componentscan)