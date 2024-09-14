---
tags:
  - Spring-MVC
---
티
# Spring Validation과 lombok 예외 처리

spring validation의 `@NotNull`과 lombok의 `@NonNull`의 차이를 알아본다.

## `@NotNull`

### Spring MVC

Spring boot에서 컨트롤러에 `@Valid`와 함께쓰면 검증을 하게된다. 만약 조건을 만족하지 못하면 `MethodArgumentNotValidException` 이 발생한다. 하지만 예외 메시지가 직접 담기는 것이 아니라 아래 코드와 같이 메시지를 뽑아내야된다.

```java
private List<ExceptionDto> extractErrorMessages(final MethodArgumentNotValidException exception) {
        return exception.getBindingResult()
            .getAllErrors()
            .stream()
            .map(DefaultMessageSourceResolvable::getDefaultMessage)
            .map(ExceptionDto::new)
            .collect(Collectors.toList());
    }
```

### JPA

JPA에서도 `@NotNull`을 사용할 수 있다. `@Entity` 클래스의 필드에 `@NotNull`이 있으면 동작을한다. 만약 조건을 만족하지 않으면 `ConstraintViolationException` 이 발생한다. 하지만 예외 메시지가 직접 담기는 것이 아니라 아래 코드와 같이 메시지를 뽑아내야된다.

```java
private List<ExceptionDto> extractErrorMessages(final ConstraintViolationException exception) {
        return exception.getConstraintViolations().stream()
            .map(ConstraintViolation::getMessage)
            .map(ExceptionDto::new)
            .collect(Collectors.toList());
    }
```

## `@NonNull`

lombok에서 지원하는 검증 어노테이션이다. 만약 조건을 만족하지 않으면 `NullPointException`이 발생한다. 커스텀 예외는 던질 수 없기때문에, 사용에 제한이 있다.

[https://www.baeldung.com/spring-boot-bean-validation](https://www.baeldung.com/spring-boot-bean-validation)