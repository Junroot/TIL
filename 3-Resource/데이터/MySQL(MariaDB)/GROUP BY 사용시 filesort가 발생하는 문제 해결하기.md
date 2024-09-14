---
tags:
  - MySQL
---
# GROUP BY 사용시 filesort가 발생하는 문제 해결

MySQL은 GROUP BY 사용시 자동으로 GROUP BY 열에 맞춰 정렬이 발생한다.

`ORDER BY NULL` 를 추가해서 정렬을 하지 않도록 할 수 있다.

## 참고 자료

[https://dba.stackexchange.com/questions/208166/group-by-needs-order-by-null-to-avoid-filesort](https://dba.stackexchange.com/questions/208166/group-by-needs-order-by-null-to-avoid-filesort)