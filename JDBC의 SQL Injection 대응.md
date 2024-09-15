---
tags:
  - Java
  - JDBC
title: JDBC의 SQL Injection 대응
---

정확히는 JDBC 내부적으로 SQL Injection에 대응하고 있다. `PreparedStatement` 클래스를 예로 들면 `setString()` 메서드에 내부적으로 SQL Injection에 대응하고 있기 때문에 안전하게 사용할 수 있다.

- [https://www.baeldung.com/sql-injection](https://www.baeldung.com/sql-injection)

따라서 아래와 같은 코드를 작성하지 않도록 조심하자.

```java
String sql = "select "
      + "customer_id,acc_number,branch_id,balance "
      + "from Accounts where customer_id = '"
      + customerId 
      + "'";
    Connection c = dataSource.getConnection();
    ResultSet rs = c.createStatement().executeQuery(sql);

select count(1) from user where id = ? and password = ?
```
