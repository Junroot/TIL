---
tags:
  - Java
title: BigDecimal valueOf(0) 대신 BigDecimal ZERO
---

`valueOf` 메소드는 캐싱되어 있는 범위인지 확인한 후 캐싱된 값을 반환하지만 `ZERO` 는 바로 캐싱된 값을 반환하기 때문이다.
