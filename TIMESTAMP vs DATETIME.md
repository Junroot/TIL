---
tags:
  - MySQL
title: TIMESTAMP vs DATETIME
---


## 목표

- TIMESTAMP와 DATETIME의 차이점을 이해한다.

## 크기

- 5.6.4 버전 이후 기준
	- TIMESTAMP는 기본적으로 4 bytes에 소수점 표현을 위해 0~3 bytes를 추가로 사용한다.
	- DATETIME은 기본적으로 5 bytes에 소수점 표현을 위해 0~3 bytes를 추가로 사용한다.

## 표현 범위

- TIMESTAMP: `1970-01-01 00:00:00` ~ `2038-01-19 03:14:17`
- DATETIME: `1000-01-01 00:00:00` ~ `9999-12-31 23:59:59`
- 따라서, 2038년이 넘는 날짜가 필요하면 TIMESTAMP를 사용할 수 없다.

## Timezone

- DATETIME은 timezone에 대해서 아무것도 처리되지 않는다.
- TIMESTAMP는 timezone에 대한 처리가 이루어진다.
	- 저장 시 TIMESTAMP 값을 현재 timezone 에서 UTC로 변환
	- 조회 시 UTC에서 현재 timezone으로 변환

### 예시

```sql
CREATE TABLE timezone_test (
    `timestamp` TIMESTAMP,
    `datetime` DATETIME
);
```

```sql
SET SESSION time_zone = '+00:00';

INSERT INTO timezone_test VALUES ('2029-02-14 08:47', '2029-02-14 08:47');

SELECT * FROM timezone_test;


-- | timestamp           | datetime            |
-- |---------------------|---------------------|
-- | 2029-02-14 08:47:00 | 2029-02-14 08:47:00 |
```

```sql
SET SESSION time_zone = '-05:00';
SELECT * FROM timezone_test;


-- | timestamp           | datetime            |
-- |---------------------|---------------------|
-- | 2029-02-14 03:47:00 | 2029-02-14 08:47:00 |
```

## 참고 자료

- https://planetscale.com/blog/datetimes-vs-timestamps-in-mysql
- https://dev.mysql.com/doc/refman/8.0/en/storage-requirements.html
- https://dev.mysql.com/doc/refman/8.0/en/datetime.html
