---
tags:
  - Spring-REST-Docs
title: REST DOCS가 빌드 시 자동 생성되도록 gradle build 수정하기
---

의존 추가 없이 구현이 가능했다. [asciidoctor](https://asciidoctor.github.io/asciidoctor-gradle-plugin/development-3.x/user-guide/)에서 최종 문서가 저장되는 위치를 설정하는 방법이 적혀있어서 참고했다. `outputDir`를 통해 자신이 원히는 경로를 지정할 수 있다. jar 파일을 만들기 전에 `build/resources/main/static/docs` 경로에 rest docs 파일을 추가하여 수동으로 문서를 커밋하지 않아도 빌드시에 만들어지도록 구현했다.

```groovy
// build.gradle
asciidoctor {
    attributes 'snippets': snippetsDir
    inputs.dir snippetsDir
    outputDir "build/resources/main/static/docs"
    dependsOn test
}

bootJar {
    dependsOn asciidoctor
}
```

## 참고 자료

[https://asciidoctor.github.io/asciidoctor-gradle-plugin/development-3.x/user-guide/](https://asciidoctor.github.io/asciidoctor-gradle-plugin/development-3.x/user-guide/)
