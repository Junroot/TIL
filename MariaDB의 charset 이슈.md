---
tags:
  - MariaDB
title: MariaDB의 charset 이슈
---

MariaDB는 기본 캐릭터셋으로 utf8mb4를 쓰기 때문에 스키마 생성시 utf8을 사용하게 설정해야된다.

![MariaDB%E1%84%8B%E1%85%B4%20charset%20%E1%84%8B%E1%85%B5%E1%84%89%E1%85%B2%20e8b31714e370455bb7800d2719c198cd/Untitled.png](assets/Untitled-4544919.png)

```sql
CREATE DATABASE practice DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```
