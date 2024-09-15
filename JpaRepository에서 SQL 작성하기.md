---
tags:
  - JPA
title: JpaRepository에서 SQL 작성하기
---

`@Query` 어노테이션에 `nativeQuery` 필드를 `true`로 설정하면 JPQL이 아닌 SQL 문을 작성할 수 있다.

```java
@Query(
  value = "SELECT * FROM USERS u WHERE u.status = 1", 
  nativeQuery = true)
Collection<User> findAllActiveUsersNative();
```

## 참고 자료

[https://www.baeldung.com/spring-data-jpa-query](https://www.baeldung.com/spring-data-jpa-query)
