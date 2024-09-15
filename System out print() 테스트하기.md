---
tags:
  - Java
title: System out print() 테스트하기
---

`System.setOut()` 메소드를 통해서 시스템의 기본 출력을 설정할 수 있다.

```java
private ByteArrayOutputStream byteArrayOutputStream;

@BeforeEach
void setUp() {
    byteArrayOutputStream = new ByteArrayOutputStream();
    System.setOut(new PrintStream(byteArrayOutputStream));
}

@Test
public void out() {
    System.out.print("hello");
    assertEquals("hello", byteArrayOutputStream.toString());
}
```

## 참고 자료

[https://stackoverflow.com/questions/1119385/junit-test-for-system-out-println](https://stackoverflow.com/questions/1119385/junit-test-for-system-out-println)
