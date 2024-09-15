---
tags:
  - Java
title: 파일을 통해서 ContentType 찾아오는 법
---

Java 표준 중에 `Files.probeContentType()` 메소드를 사용하면 쉽게 확인할 수 있다.

```java
@Test
public void whenUsingJava7_thenSuccess() {
    Path path = new File("product.png").toPath();
    String mimeType = Files.probeContentType(path);
 
    assertEquals(mimeType, "image/png");
}
```

[https://www.baeldung.com/java-file-mime-type](https://www.baeldung.com/java-file-mime-type)

파일 이름만으로 유추하는 방법도 있다.

```java
String mimeType = URLConnection.guessContentTypeFromName(file.getName());
```

[https://stackoverflow.com/questions/9670040/what-is-the-best-approach-to-identify-a-specific-file-type-in-java](https://stackoverflow.com/questions/9670040/what-is-the-best-approach-to-identify-a-specific-file-type-in-java)
