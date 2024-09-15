---
tags:
  - MySQL
title: GROUP BY, ORDER BY 사용시 인덱스
---

인덱스는 정의되어 있는 순서가 중요하다.

만약 인덱스에 정의된 순서가 col1, col2, col3, col4 라고 정의되어 있다면 아래와 같다.

```sql
GROUP BY col1 # 사용 가능
GROUP BY col1, col2 # 사용 가능
GROUP BY col1, col2, col3 # 사용 가능
GROUP BY col1, col2, col3, col4 # 사용 가능

GROUP BY col2, col2 # 사용 불가능
GROUP BY col1, col3, col2 # 사용 불가능
GROUP BY col1, col2, col3, col4, col5 # 사용 불가능
```

WHERE 절이 있다고하면 그 다음 컬럼부터 GROUP BY에 있다면 사용 가능하다.

```sql
WHERE col1 = '상수' GROUP BY col2, col3 # 사용 가능
WHERE col1 = '상수' AND col2 = '상수' GROUP BY col3, col4  # 사용 가능
```

## 참고 자료

[https://lannstark.tistory.com/40](https://lannstark.tistory.com/40)
