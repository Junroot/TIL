---
tags:
  - Spring-Framework
---
# TransactionTemplate 이용한 트랜잭션 관리

`@Transactional` 어노테이션을 사용하지 않고, 트랜잭션을 직접 관리하고 싶은 경우가 있었다. 이때 `TransactionTemplate`를 사용하면 된다.

## 트랜잭션 외부에 리턴을 해야되는 경우

```java
return transactionTemplate.execute(new TransactionCallback() {
    // the code in this method runs in a transactional context
    public Object doInTransaction(TransactionStatus status) {
        updateOperation1();
        return resultOfUpdateOperation2();
    }
});
```

## 트랜잭션 외부에 리턴이 필요없을 경우

```java
transactionTemplate.execute(new TransactionCallbackWithoutResult() {
    protected void doInTransactionWithoutResult(TransactionStatus status) {
        updateOperation1();
        updateOperation2();
    }
});
```

## 참고 자료

[https://docs.spring.io/spring-framework/docs/current/reference/html/data-access.html#tx-prog-template](https://docs.spring.io/spring-framework/docs/current/reference/html/data-access.html#tx-prog-template)
