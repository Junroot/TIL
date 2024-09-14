---
tags:
  - MySQL
---
# Record Lock

## 목표

- record lock이 무엇인지 이해한다.

## 목적

- index에 걸리는 락
- `SELECT c1 FROM t WHERE c1 = 10 FOR UPDATE`이고 `c1`에 대해서 인덱스가 걸려있는 경우에, 다른 트랜잭션에서 `t.c1 = 10` 인 값을 수정하지 않도록 막아야된다.
- `UPDATE` 쿼리를 수행할 때 c1 같은 secondary index로 조건을 건다면, innoDB에서 secondary index로 PK를 찾고, PK를 통해서 행을 조회하므로, `c1 = 10`과 그에 해당하는 모든 PK에 record lock이 걸린다.

## 참고 자료

- https://dev.mysql.com/doc/refman/8.0/en/innodb-locking.html#innodb-record-locks