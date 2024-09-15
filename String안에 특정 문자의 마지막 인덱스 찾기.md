---
tags:
  - Java
title: String안에 특정 문자의 마지막 인덱스 찾기
---

`abc.txt.jpg` 같은 파일이름을 파싱할 때, 확장자를 `jpg`로 구하기 위해서 '.'문자의 마지막 인덱스 위치를 알아야 됐다.

```java
fileName.lastIndexOf(FILE_EXTENSION_DELIMITER);
```

Java에 String의 메소드로 `lastIndexOf`라는 메소드가 있어서 쉽게 구현할 수 있었다.
