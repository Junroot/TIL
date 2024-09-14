---
tags:
  - Java
---
# Stream을 collection으로 만든 후 추가 적인 작업이 필요한 경우

```java
passengers.stream()
		.map(name -> new Person(name))
    .collect(Collectors.collectingAndThen(Collectors.toList(), Bus::new));
```

`collectingAndThen()`메소드를 활용하면 된다.

## 참고 자료

[https://stackoverflow.com/questions/52382157/continue-mapping-after-stream-collect](https://stackoverflow.com/questions/52382157/continue-mapping-after-stream-collect)