# Redis Transaction

## 목표

- redis를 이용한 작업 중에서 원자적으로 동작해야되는 로직이 필요했다.
- 이를 위해 redis에서 transaction을 사용하는 방법을 이해한다.

## 방법

- Redis에서 `MULTI`가 트랜잭션의 시작을 나타내고 `EXEC`가 트랜잭션의 커밋, `DISCARD`가 롤백을 나타낸다.
- `RedisTemplate` 자체애도 `multi()`, `exec()`가 있지만, 각 커맨드가 같은 connection에서 실행된다는 보장이 없다.
- 이를 위해 `SessionCallback` 인터페이스로 하나의 커넥션에서 수행할 연산을 전달한다.

```java
//execute a transaction
List<Object> txResults = redisTemplate.execute(new SessionCallback<List<Object>>() {
  public List<Object> execute(RedisOperations operations) throws DataAccessException {
    operations.multi();
    operations.opsForSet().add("key", "value1");

    // This will contain the results of all operations in the transaction
    return operations.exec();
  }
});
System.out.println("Number of items added to set: " + txResults.get(0));
```

## 참고 자료

- https://docs.spring.io/spring-data/data-redis/docs/current/reference/html/#tx
- https://wildeveloperetrain.tistory.com/137