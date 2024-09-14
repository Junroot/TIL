---
tags:
  - JPA
---
# Spring JPA로 논리적 삭제 사용하기

이전에 사용했던 `@Where` 어노테이션과 `@SQLDelete` 어노테이션을 사용하면 된다.

```java
@Entity
@Table(name = "table_product")
@SQLDelete(sql = "UPDATE table_product SET deleted = true WHERE id=?")
@Where(clause = "deleted=false")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private double price;

    private boolean deleted = Boolean.FALSE;
   
    // setter getter method
}
```

`@SQLDelete` 도 실제로 DB에 쿼리를 보낼 때 적용하게 되므로, 영속성 컨텍스트에 남아 있는 엔티티는 `findAll()` 같은 메서드로 조회가 되니 유의해야 된다.

## 참고 자료

[https://www.baeldung.com/spring-jpa-soft-delete](https://www.baeldung.com/spring-jpa-soft-delete)