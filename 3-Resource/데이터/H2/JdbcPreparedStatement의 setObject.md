---
tags:
  - H2
---
# JdbcPreparedStatement의 setObject

`PreparedStatement`의 `setObject`메소드로 파라미터 매핑을 했을 때 어떻게 자동으로 타입을 찾는지 궁금해서 조금 찾아봤다.

```java
// JdbcPreparedStatement
@Override
public void setObject(int parameterIndex, Object x) throws SQLException {
    try {
        if (isDebugEnabled()) {
            debugCode("setObject(" + parameterIndex + ", x);");
        }
        if (x == null) {
            setParameter(parameterIndex, ValueNull.INSTANCE);
        } else {
            setParameter(parameterIndex, DataType.convertToValue(session, x, Value.UNKNOWN));
        }
    } catch (Exception e) {
        throw logAndConvert(e);
    }
}
```

`JdbcPreparedStatement`의 `setObject`를 보면 다음과같이 `DataType.convertToValue` 메서드로 타입을 변환한다.

[https://github.com/chris-martin/h2/blob/a639abcdfd5928ea23b7dd3827cb8567e162a0a1/h2/src/main/org/h2/value/DataType.java#L882](https://github.com/chris-martin/h2/blob/a639abcdfd5928ea23b7dd3827cb8567e162a0a1/h2/src/main/org/h2/value/DataType.java#L882)

위 링크를 보면 타입별로 적절한 DBType 으로 매핑하는 것을 볼 수 있다.