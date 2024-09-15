---
tags:
  - Jackson
title: snake case 필드를 camel case로 역직렬화 하기
---


## 목표

- 아래와 같이 snake case로 필드가 존재하는 json을 camel case로 역직렬화 하는 방법이 필요했다.

```json
{ 
	"first_name": "Jackie", 
	"last_name": "Chan" 
}
```

## 방법1: `@JsonProperty` 사용

- `@JsonProperty` 어노테이션을 사용하면, 해당 필드와 매핑되는 json 프로퍼티의 이름을 지정할 수 있다.

```java
public class UserWithPropertyNames {
    @JsonProperty("first_name")
    private String firstName;
    
    @JsonProperty("last_name")
    private String lastName;

    // standard getters and setters
}
```

## 방법2: `@JsonNaming` 사용

- `@JsonNaming`을 클래스 위에 명시하면 현재 클래스의 역직렬화 이름 전략을 설정할 수 있다.
- 아래와 같이 명시하면 클래스의 필드를 json의 snake case로 찾아서 매핑한다.

```java
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class UserWithSnakeStrategy {
    private String firstName;
    private String lastName;

    // standard getters and setters
}
```

## 참고 자료

- https://www.baeldung.com/jackson-deserialize-snake-to-camel-case
