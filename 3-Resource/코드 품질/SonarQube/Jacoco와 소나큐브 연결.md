---
tags:
  - SonarQube
---
# Jacoco와 소나큐브 연결

build.gradle에 다음을 추가하면 소나큐브의 테스트 커버리지가 0%인 문제가 해결된다.

```java
plugins {
    id 'jacoco'
    // any other plugins
}

jacocoTestReport {
    reports {
        xml.enabled true
    }
}

test.finalizedBy jacocoTestReport

tasks.named('sonarqube').configure {
    dependsOn test
}
```

Jacoco가 자바 프로젝트의 테스트 커버리지 보고서를 생성해주는 라이브러리다.

## 참고 자료

[https://tomgregory.com/how-to-measure-code-coverage-using-sonarqube-and-jacoco/#22_Using_the_Jacoco_Gradle_plugin](https://tomgregory.com/how-to-measure-code-coverage-using-sonarqube-and-jacoco/#22_Using_the_Jacoco_Gradle_plugin)