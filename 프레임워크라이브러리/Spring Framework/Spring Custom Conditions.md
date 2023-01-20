# Spring Custom Conditions

## 배경

- config 클래스 중에 `Condition` 인터페이스의 구현체가 있었는데, 어떤 용도인지 이해하지 못했다.

## Custom Conditions 정의

- 조건부로 빈을 등록할 때 `@Conditional` 애노테이션을 사용할 수 있다. 
- 이 애노테이션에서 사용할 조건을 클래스로 만들 수 있다.

```java
class Java8Condition implements Condition {
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        return JavaVersion.getJavaVersion().equals(JavaVersion.EIGHT);
    }
}
```

- 사용 예

```java
@Service
@Conditional(Java8Condition.class)
public class Java8DependedService {
    // ...
}
```

## 참고 자료

- https://www.baeldung.com/spring-conditional-annotations