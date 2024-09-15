---
tags:
  - RestAssured
title: URL에 파라미터 사용하기
---

url에 유동적으로 바뀌는 부분이 있다면 파라미터를 사용하여 처리할 수 있다.

```java
RestAssured.given()
    .when()
        .get("http://restcountries.eu/rest/v1/name/{country}", cty)
.then()
        .body("capital", containsString("Helsinki"));
```

## 참고 자료

[https://stackoverflow.com/questions/32475850/how-to-pass-parameters-to-rest-assured](https://stackoverflow.com/questions/32475850/how-to-pass-parameters-to-rest-assured)
