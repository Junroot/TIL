# Spring rest docs의 API 문서가 자동으로 덮어쓰기가 되지 않는 문제 해결

`build.gradle`에 아래 코드를 추가하면 된다.

```java
asciidoctor.doFirst {
	delete file('src/main/resources/static/docs')
}
```