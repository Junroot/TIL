---
tags:
  - Mockito
---
# 반환 값이 void인 메소드 아무것도 하지 않게 mocking

```java
doNothing().when(myList).add(any(Integer.class), valueCapture.capture());
```

[https://www.baeldung.com/mockito-void-methods](https://www.baeldung.com/mockito-void-methods)