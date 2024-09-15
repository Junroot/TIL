---
tags:
  - Java
title: Class A 가 Class B 의 자식인지 확인하는 방법
---

```java
Class<A> clazzA = ...;
Class<B> clazzB = ...;

clazzA.isAssignableFrom(clazzB); // true

class B extends A {
...
}
```

## 참고 자료

[https://www.tutorialspoint.com/java/lang/class_isassignablefrom.htm](https://www.tutorialspoint.com/java/lang/class_isassignablefrom.htm)
