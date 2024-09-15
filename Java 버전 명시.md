---
tags:
  - Gradle
title: Java 버전 명시
---

`sourceCompatibility` 와 `targetCompatibility` 를 사용하면된다.

![Untitled](assets/Untitled-4545561.png)

sourceCompatibility: .java 파일을 컴파일 할 때 사용할 Java 프로그래밍 언어의 버전.

targetCompatibility: 생성 될 클래스파일이 호환되어야 하는 VM의 버전. 기본적으로 source와 같은 값이 되므로 같다면 명시해줄 필요가 없다.

## 참고 자료

[https://docs.gradle.org/3.3/userguide/java_plugin.html#sec:java_convention_properties](https://docs.gradle.org/3.3/userguide/java_plugin.html#sec:java_convention_properties)

[https://www.cloudhadoop.com/gradle-configure-java-version/](https://www.cloudhadoop.com/gradle-configure-java-version/)
