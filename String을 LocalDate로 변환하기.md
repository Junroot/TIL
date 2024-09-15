---
tags:
  - Java
title: String을 LocalDate로 변환하기
---

`DateTimeFormatter` 로 문자열의 날짜 형식을 지정하고 파싱하면된다.

```java
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d/MM/yyyy");
String date = "16/08/2016";

//convert String to LocalDate
LocalDate localDate = LocalDate.parse(date, formatter);
```

## 참고 자료

[https://mkyong.com/java8/java-8-how-to-convert-string-to-localdate/](https://mkyong.com/java8/java-8-how-to-convert-string-to-localdate/)
