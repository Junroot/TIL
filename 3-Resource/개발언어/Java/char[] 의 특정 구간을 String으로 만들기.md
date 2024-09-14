---
tags:
  - Java
---
# char[] 의 특정 구간을 String으로 만들기

`String` 생성자 중에 char 배열의 offset과 count를 지정할 수 있는 것이 있다.

```
char[] a = {'a', 'b', 'c'};
String b = new String(a, 1, 2); // b == "bc"

```

## 참고 자료

[https://docs.oracle.com/javase/8/docs/api/java/lang/String.html](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html)