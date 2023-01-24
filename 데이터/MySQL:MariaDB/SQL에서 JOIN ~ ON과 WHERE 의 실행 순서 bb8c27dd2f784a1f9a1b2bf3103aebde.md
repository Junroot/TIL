# SQL에서 JOIN ~ ON과 WHERE 의 실행 순서

SQL문을 실행하면 일반적으로 아래와 같은 순서로 진행된다고 일고 있을 것이다.

```markdown
1. FROM
2. ON
3. JOIN
4. WHERE
5. GROUP BY
6. WITH CUBE or WITH ROLLUP
7. HAVING
8. SELECT
9. DISTINCT
10. ORDER BY
11. TOP
```

하지만 이것은 논리적 처리 순서이다. SQL 문을 실행시키면 쿼리 옵티마이저가 인덱스를 사용할 수 있도록 JOIN과 WHERE의 순서를 바꿔서 처리한다. 실제 처리 순서와 논리적 순서가 다르다는 것을 이해할 필요가 있다.

```sql
SELECT programmer.exercise, count(1) as count
FROM hospital
    INNER JOIN covid ON covid.hospital_id = hospital.id
    INNER JOIN programmer ON programmer.id = covid.programmer_id
WHERE hospital.name = '서울대병원'
GROUP BY programmer.exercise
ORDER BY NULL;
```

다음과 같은 SQL 문이 있다고 하자. 만약 hospital에 (name, id) 라는 인덱스가 있다면 내부적으로는 WHERE 절의 `hospital.name = '서울대병원'`을 먼저 실행하고 `covid.hospital_id = [hospital.id](http://hospital.id)` 를 실행한다.

## 참고 자료

[https://dba.stackexchange.com/questions/5038/sql-server-join-where-processing-order](https://dba.stackexchange.com/questions/5038/sql-server-join-where-processing-order)

[https://dba.stackexchange.com/questions/36391/is-there-an-execution-difference-between-a-join-condition-and-a-where-condition](https://dba.stackexchange.com/questions/36391/is-there-an-execution-difference-between-a-join-condition-and-a-where-condition)