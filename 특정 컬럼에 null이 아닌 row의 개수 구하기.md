---
tags:
  - MySQL
title: 특정 컬럼에 null이 아닌 row의 개수 구하기
---

```sql
sum(case when [session.id](http://session.id/) is null then 0 else 1 end)
```

`case` 키워드를 이용하면 된다.

## 참고 자료

[https://www.sqlshack.com/working-with-sql-null-values/](https://www.sqlshack.com/working-with-sql-null-values/)
