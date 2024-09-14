---
tags:
  - Java
---
# Lombok

롬복을 통해 쉽게 생성자, getter, setter, 빌드 패턴이 구현된다.

```java
@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Game {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NonNull
    private String name;
}
```

access 속성으로 접근 제어자 지정할 수 있다.

```java
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
```