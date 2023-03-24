# 인덱스 생성, 삭제, 조회 SQL 문

```sql
// 생성
ALTER TABLE 테이블명 ADD INDEX 인덱스명(컬럼명1, 컬럼명2, ...)
// 삭제
ALTER TABLE 테이블명 DROP INDEX 인덱스명
// 조회
SHOW INDEX FROM 테이블명;
```