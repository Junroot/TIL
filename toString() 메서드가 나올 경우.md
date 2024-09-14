---
tags:
  - Java
---
# toString() 메서드가 나올 경우

```java
assertThat(obejct.toString()).isEqualTo("\"value\"");
```

위의 코드는 아래의 방식으로 바꿀 수 있다.

```java
assertThat(obejct).hasToString(expectedString)
```