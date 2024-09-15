---
tags:
  - Spring-Boot
title: Spring boot는 정적 파일을 어떻게 처리하나
---

Spring boot의 경우 `ResourceHttpRequestHandler` 라는 정적 리소스를 처리하는 핸들러가 따로있다.

기본적으로 /static, /public, /resources, /META-INF/resources 디렉토리에 있는 정적 컨텐츠를 처리하고 있다.

[https://www.baeldung.com/spring-mvc-static-resources](https://www.baeldung.com/spring-mvc-static-resources)

[https://github.com/spring-projects/spring-framework/blob/main/spring-webmvc/src/main/java/org/springframework/web/servlet/resource/ResourceHttpRequestHandler.java](https://github.com/spring-projects/spring-framework/blob/main/spring-webmvc/src/main/java/org/springframework/web/servlet/resource/ResourceHttpRequestHandler.java)
