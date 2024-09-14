---
tags:
  - Spring-Boot
---
# Spring Boot Web Starter에서 Validation 애노테이션 없어짐

## 배경

- Spring Boot에서 `@NotBlank`를 사용했는데 존재하지 않는 애노테이션으로 인식했다.
- Spring Boot의 웹 스타터에 validation api를 구현한 하이버네이트 컴포넌트가 존재한다고 알고 있었는데, 의문이었다.

## 원인 및 해결

- Spring Boot 2.3 부터 웹 스타터에서 validation 스타터가 분리되었다.
- 아래와 같이 직접 의존을 추가해줘야 된다.

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

```groovy
dependencies {
  ...
  implementation 'org.springframework.boot:spring-boot-starter-validation'
}
```

## 참고 자료

- https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.3-Release-Notes#validation-starter-no-longer-included-in-web-starters
- https://stackoverflow.com/questions/48614773/spring-boot-validation-annotations-valid-and-notblank-not-working