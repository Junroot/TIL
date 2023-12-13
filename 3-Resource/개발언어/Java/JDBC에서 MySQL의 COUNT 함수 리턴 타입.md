# JDBC에서 MySQL의 COUNT 함수 리턴 타입

## 배경

- MyBatis를 이용해 특정 id별 COUNT 결과를 `Pair<Long, Int>` 로 리턴했더니, 타입 캐스팅 예외가 발생했다.
	- `java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer`
- 문제 상황 예시 코드

```kotlin
@Select("...")
fun countByIds(ids: List<Long>): List<Pair<Long, Int>>
```

## 원인

- MySQL의 COUNT 함수의 리턴 타입은 `BIGINT` 이다.
	- ![](assets/Pasted%20image%2020231207110338.png)
- MySQL JDBC Driver 에서 BIGINT는 기본적으로 Java의 `Long` 타입으로 변환되므로 타입 캐스팅 예외가 발생한다.
	- ![](assets/Pasted%20image%2020231207110426.png)

## 참고 자료

- [https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_count](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_count)
- [https://dev.mysql.com/doc/connector-j/en/connector-j-reference-type-conversions.html](https://dev.mysql.com/doc/connector-j/en/connector-j-reference-type-conversions.html)