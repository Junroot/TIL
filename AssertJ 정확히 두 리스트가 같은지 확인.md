---
tags:
  - AssertJ
title: AssertJ 정확히 두 리스트가 같은지 확인
---

```java
assertThat(a).hasSize(b.size()).hasSameElementsAs(b);
```

- `hasSameElementsAs` 는 b가 가지고 있는 요소들을 a가 전부 가지고 있는지 확인한다. 하지만 a가 중복된 값을 가지고 있다면 b가 하나만 가지고 있어도 통과가 되기 때문에, `hasSize()`로 크기 체크도 해야된다.

[https://www.baeldung.com/java-assert-lists-equality-ignore-order](https://www.baeldung.com/java-assert-lists-equality-ignore-order)
