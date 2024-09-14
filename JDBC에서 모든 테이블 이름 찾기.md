---
tags:
  - Java
  - JDBC
---
# JDBC에서 모든 테이블 이름 찾기

Rest Assured를 통한 E2E 테스트 진행시, 모든 테스트를 독립적으로 만들기 위해 각 테스트마다 모든 테이블을 TRUNCATE 할 필요가 있었다. 그래서 모든 테이블의 이름을 찾는 과정이 필요했다.

`DatabaseMetaData` 를 통해 찾을 수 있다고 한다. `DatabaseMetaData`는 `Connection`을 통해 얻을 수 있다. 나같은 경우 Spring을 사용하고 있어서 `JdbcTemplate`를 통해서 구할 수 있었다.

```java
private void truncateAllTables() throws SQLException {
    JdbcTestUtils.deleteFromTables(jdbcTemplate, getAllTables().toArray(new String[0]));
}

private List<String> getAllTables() throws SQLException {
    DatabaseMetaData metaData = jdbcTemplate.getDataSource().getConnection().getMetaData();
    List<String> tables = new ArrayList<>();
    try (ResultSet resultSet = metaData.getTables(null, null, null, new String[]{"TABLE"})) {
        while(resultSet.next()) {
            tables.add(resultSet.getString("TABLE_NAME"));
        }
    }
    tables.remove("flyway_schema_history");
    return tables;
}
```

`metaData.getTables(null, null, null, new String[]{"TABLE"})` 이 부분이 중요하다.

## 참고 자료

[https://stackoverflow.com/questions/2780284/how-to-get-all-table-names-from-a-database](https://stackoverflow.com/questions/2780284/how-to-get-all-table-names-from-a-database)