---
tags:
  - Spring-REST-Docs
title: Spring rest docs의 API 문서가 자동으로 덮어쓰기
---

`build.gradle`에 아래 코드를 추가하면 된다.

```java
asciidoctor.doFirst {
	delete file('src/main/resources/static/docs')
}
```
