---
tags:
  - Java
  - JDBC
title: JDBC execute vs executeQuery vs executeUpdate
---


- execute: 일반적인 sql 실행. 리턴 타입이 `ResultSet`이면 TRUE, 아니면 false다.
- executeQuery: 특정 데이터를 탐색할 때 사용하는 메소드. 리턴타입이 `ResultSet`이다.
- executeUpdate: DML, DDL 등을 입려할 때 사용하는 메소드. 리턴타입이 `int`로 영향받은 행의 개수를 반환한다.

![Untitled](assets/Untitled-4549887.png)

## 참고 자료

[https://javaconceptoftheday.com/difference-between-executequery-executeupdate-execute-in-jdbc/](https://javaconceptoftheday.com/difference-between-executequery-executeupdate-execute-in-jdbc/)
