---
tags:
  - Java
---
# LocalDate, LocalDateTime 변환

## LocalDate → LocalDateTime

시간을 지정해줘야 되나는 문제가 있다. 

`atStartOfDay()` 메서드는 0시 0분 0초로 시간이 매핑된다.

`atTime()`은 자신이 원하는 시간을 `LocalTime` 이나 (시, 분, 초) 형태로 파라미터를 입력할 수 있다.

```java
LocalDateTime localDateTime1 = localDate.atStartOfDay();
LocalDateTime localDateTime2 = localDate.atTime(LocalTime.now());
LocalDateTime localDateTime3 = localDate.atTime(04, 30, 56);
```

## LocalDateTime → LocalDate

```java
LocalDate localDate = localDateTime.toLocalDate();
```

## 참고 자료

[https://howtodoinjava.com/java/date-time/localdate-localdatetime-conversions/](https://howtodoinjava.com/java/date-time/localdate-localdatetime-conversions/)