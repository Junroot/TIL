# Hibernate Validator로 단위 테스트하기

## 목표

- Spring MVC에서 컨트롤러의 파라미터로 사용되는 dto들의 어노테이션 기반 validation을 단위 테스트한다.
- `@SpringBootTest` 등을 사용해서 테스트가 느려지게 하지 않는다.

## 방법

- dto를 검증하기위해서는 `Validator`가 필요하다. 
	- `Validator`는 `ValidatorFacotry`를 통해서 생성할 수 있다.

```kotlin
val validatorFactory = Validation.buildDefaultValidatorFactory()  
val validator = validatorFactory.validator
```


- 아래와 같은 `User` 클래스가 있다면, `validator`를 통해서 검증을 통과했는지 테스트 해볼 수 있다.

```java
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Email;

public class User {

    @NotNull(message = "Name cannot be null")
    private String name;

    @AssertTrue
    private boolean working;

    @Size(min = 10, max = 200, message 
      = "About Me must be between 10 and 200 characters")
    private String aboutMe;

    @Min(value = 18, message = "Age should not be less than 18")
    @Max(value = 150, message = "Age should not be greater than 150")
    private int age;

    @Email(message = "Email should be valid")
    private String email;

    // standard setters and getters 
}
```

```java
// test code

Set<ConstraintViolation<User>> violations = validator.validate(user);
assertThat(violations).hasSize(4)
for (ConstraintViolation<User> violation : violations) {
	// ...
}
```

## 참고 자료

- https://www.baeldung.com/java-validation