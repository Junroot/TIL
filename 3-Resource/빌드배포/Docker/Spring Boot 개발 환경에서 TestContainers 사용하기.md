# Spring Boot 개발 환경에서 TestContainers 사용하기

## 목표

- TestContainers를 통해 개발 환경에서 Spring 애플리케이션 실행 시 mariaDB 컨테이너를 실행하도록 한다.
- TestContainers를 통해 이미 mariaDB 컨테이너가 실행 중이라면 재사용하도록 한다.

## 의존성 추가

- 일반적으로 TestContainers는 테스트 환경에 사용하지만, Spring 애플리케이션이 dev 프로파일로 실행될 때 사용하는 것이 목표여서 아래와 같이 의존성을 추가한다.
- mariaDB를 사용하기 위한 JDBC Driver도 함께 의존성 추가한다.

```kotlin
dependencies {  
	//...
    implementation("org.mariadb.jdbc:mariadb-java-client")  
    implementation("org.springframework.boot:spring-boot-testcontainers")  
    implementation("org.testcontainers:mariadb")  
    //...
}
```

## 컨테이너 자동 실행

- Spring Boot 3.1부터 `Container` 클래스를 Bean 등록하면, 자동으로 컨테이너를 실행해준다.
- `@ServiceConnection` 어노테이션이 있으면 생성된 컨테이너를 기준으로 `ConnectionDetails` 을 Bean으로 자동으로 등록해준다.
	- `ConnectionDetails`: Spring Boot 3.1부터 커넥션에 사용해되는 새로운 추상화 클래스. (이전에는 JDBC 커넥션을 위해 spring.datasource.url 프로퍼티를 사용했다)
	- https://spring.io/blog/2023/06/19/spring-boot-31-connectiondetails-abstraction
- 이미 실행중인 컨테이너가 있다면 이를 계속 사용하기 위해 `withReuse(true)`를 호출한다.

```kotlin
@Configuration(proxyBeanMethods = false)  
@Profile("dev")  
class ContainerConfiguration {  
  
    @Bean  
    @ServiceConnection    
    fun mariaDbContainer(): MariaDBContainer<*> {  
       return MariaDBContainer("mariadb:10.11.6").withReuse(true)  
    }  
}
```

## 참고 자료

- https://www.baeldung.com/spring-boot-built-in-testcontainers
- https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.testing.testcontainers.service-connections
- https://www.baeldung.com/spring-boot-testcontainers-integration-test
