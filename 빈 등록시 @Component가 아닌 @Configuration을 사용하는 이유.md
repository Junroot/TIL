---
tags:
  - Spring-Framework
title: 빈 등록시 @Component가 아닌 @Configuration을 사용하는 이유
---


- `@Configuration` 안에 `@Component`가 있다. 즉 둘 다 클래스 자체가 빈으로 등록된다.
- 내부에서 선언한 빈을 싱글톤으로 등록하고자 하는 경우에는 `@Configuration`이 붙어야 된다.
- 큰 차이점은 `@Configuration`은 CGLIB wrapper를 사용하여 모든 빈 메서드가 자신이 현재 클래스의 첫 호출처럼 동작한다. 따라서 아래의 코드는 `@Component`는 동작을 하지 않는다.
- CGLIB은 프록시 빈 객체를 만들어서 실제로 사용될 때 객체가 생성되기 때문에 빈에 다른 빈을 의존할 수 있다.

```java
@Configuration
public static class Config {

    @Bean
    public SimpleBean simpleBean() {
        return new SimpleBean();
    }

    @Bean
    public SimpleBeanConsumer simpleBeanConsumer() {
        return new SimpleBeanConsumer(simpleBean());
    }
}
```
