---
tags:
  - Spring-MVC
---
# @Valid vs @Validated

## 목표

- `@Valid`와 `@Validated`의 차이점을 이해한다.
- `@Valid`와 `@Validated`의 사용법을 이해한다.

## 공통점

- 컨트롤러 파라미터에 `@Valid`, `@Validated` 를 붙이면, 글로벌 `Validator`로 검증이 된다.
- Spring Boot는 JSR-380의 기본 구현인 Hibernate Validator를 글로벌 `Validator`로 사용한다.

## 컨트롤러에서 @Valid vs @Validated

- `@Valid`는JSR-303의 어노테이션으로 메서드 수준의 유효성 검사에 사용한다.
- `@Validated`는 Spring에서 `@Valid`를 확장하기 위해 만든 어노테이션이다.
- `@Validated`는 validation group이라는 기능을 제공한다.
- 컨트롤러에서는 validation group 기능 유무 차이가 존재한다.
- 컨트롤러에서 검증은 `ArgumentResolver`에서 처리되며, 실패시 `MethodArgumentNotValidException` 예외가 발생한다.
- 아래 사진은 `ArgumentResolver`의 구현체들에서 사용하고 있는 `ValidationAnnotationUtils` 코드의 일부다.
	- ![](assets/Pasted%20image%2020230731225149.png)

### @Valid 어노테이션 사용 예

- 아래의 `@NotBlank`, `@Min` 어노테이션은 Java Bean Validation 에서 제공하는 어노테이션이다.

```java
public class UserAccount {
    
    @NotNull
    @Size(min = 4, max = 15)
    private String password;
 
    @NotBlank
    private String name;
 
    @Min(value = 18, message = "Age should not be less than 18")
    private int age;
 
    @NotBlank
    private String phone;
    
    // standard constructors / setters / getters / toString   
    
}
```

```java
@RequestMapping(value = "/saveBasicInfo", method = RequestMethod.POST)
public String saveBasicInfo(
  @Valid @ModelAttribute("useraccount") UserAccount useraccount, 
  BindingResult result, 
  ModelMap model) {
    if (result.hasErrors()) {
        return "error";
    }
    return "success";
}
```

### @Validated 어노테이션 사용 예

- `@Validated`를 사용하면, 각 검증 어노테이션을 그룹으로 만들 수 있다.
- `@Validated` 애노테이션에 그룹을 나타내는 인터페이스 클래스 타입을 인자로 넘긴다.
	- 인터페이스는 직접 만들어야 된다.

```java
public class UserAccount {
    
    @NotNull(groups = BasicInfo.class)
    @Size(min = 4, max = 15, groups = BasicInfo.class)
    private String password;
 
    @NotBlank(groups = BasicInfo.class)
    private String name;
 
    @Min(value = 18, message = "Age should not be less than 18", groups = AdvanceInfo.class)
    private int age;
 
    @NotBlank(groups = AdvanceInfo.class)
    private String phone;
    
    // standard constructors / setters / getters / toString   
    
}
```

```java
@RequestMapping(value = "/saveBasicInfoStep1", method = RequestMethod.POST)
public String saveBasicInfoStep1(
  @Validated(BasicInfo.class) 
  @ModelAttribute("useraccount") UserAccount useraccount, 
  BindingResult result, ModelMap model) {
    if (result.hasErrors()) {
        return "error";
    }
    return "success";
}
```

## @Validated의 Method Validation

- `@Validated` 어노테이션은 Spring의 Method Validation 기능을 사용할 때도 사용된다.
- 클래스 레벨에 `@Validated`를 붙이고, 메서드 파라미터에 `@Min` 등의 유효성 검사 어노테이션을 붙이거나, `@Valid`를 붙이면 검증이 메서드 파라미터에서 유효성 검사가 된다.
- 이 때 유효성 검사를 실패하면 `ConstraintViolationException`이 발생한다.
- Spring의 Method Validation은 AOP 기반으로 메소드 요청을 인터셉트하여 처리된다.

```java
@Service 
@Validated 
public class UserService { 
	public void addUser(@Valid AddUserRequest addUserRequest) { 
		... 
	} 
}
```

## 참고 자료

- https://mangkyu.tistory.com/174
- https://www.baeldung.com/spring-valid-vs-validated
- https://www.baeldung.com/spring-boot-bean-validation
- https://docs.spring.io/spring-framework/reference/core/validation/beanvalidation.html#validation-beanvalidation-spring-method