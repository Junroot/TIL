---
tags:
  - Mockito
title: Mocking한 객체의 메소드 인자 상태 확인
---

Mocking한 상태인 `orderTableDao` 에서 `orderTableDao.save(entity)` 를 호출했을 때, `entity`의 필드값을 검증할 필요가 있었다. `argThat()` 메서드를 사용하면 검증이 가능하다.

```bash
verify(orderTableDao, times(3)).save(
    argThat(orderTable ->
        !orderTable.isEmpty() && Objects.nonNull(orderTable.getTableGroupId())
    )
);
```

## 참고 자료

[https://stackoverflow.com/questions/31993439/can-mockito-verify-an-argument-has-certain-properties-fields](https://stackoverflow.com/questions/31993439/can-mockito-verify-an-argument-has-certain-properties-fields)

[https://www.baeldung.com/mockito-argument-matchers](https://www.baeldung.com/mockito-argument-matchers)
