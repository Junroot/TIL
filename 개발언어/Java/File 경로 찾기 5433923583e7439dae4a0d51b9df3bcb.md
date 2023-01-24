# File 경로 찾기

```java
String resourceName = "example_resource.txt";

ClassLoader classLoader = getClass().getClassLoader();
File file = new File(classLoader.getResource(resourceName).getFile());
String absolutePath = file.getAbsolutePath();

System.out.println(absolutePath);

assertTrue(absolutePath.endsWith("/example_resource.txt"));
```

`ClassLoader`를 사용하면 classpath에서 해당 파일의 위치를 찾는다. 서브 디렉토리까지 찾지 않는 점의 유의해야된다.

## 참고 자료

[https://www.baeldung.com/junit-src-test-resources-directory-path](https://www.baeldung.com/junit-src-test-resources-directory-path)