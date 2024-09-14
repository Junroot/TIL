---
tags:
  - MySQL
---
# 컬럼명 수정 SQL

```sql
ALTER TABLE user CHANGE name nickname VARCHAR(30) NULL;
```

바꿀 컬럼명 뒤에 타입도 함께 명시하지 않으면 에러가 난다는 점을 유의해야된다.