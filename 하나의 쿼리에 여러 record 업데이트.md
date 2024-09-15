---
tags:
  - MySQL
title: 하나의 쿼리에 여러 record 업데이트
---


## 목표

- 쿼리 하나로 여러 record의 값을 서로 다르게 업데이트 한다.(INSERT 문처럼)

## 방법

- SQL에서 따로 제공하는 문법은 없다. CASE 문을 통해 구현해야 된다.

```sql
UPDATE BANDS
SET PERFORMING_COST = CASE BAND_NAME
	WHEN 'METALLICA' THEN 90000
	WHEN 'BTS' THEN 200000
	ELSE PERFORMING_COST
	END
WHERE BAND_NAME IN('METALLICA', 'BTS');
```

## 참고 자료

- https://www.geeksforgeeks.org/how-to-update-multiple-records-using-one-query-in-sql-server/
