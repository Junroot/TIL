---
title: maven.test.skip vs skipTests
tags:
  - Maven
---
## 목표

- jar 빌드할 때 테스트를 제외하는 옵션인 `-Dmaven.test.skip=true`와 `-DskipTests`의 차이를 이해한다.

## 차이점

- `-Dmaven.test.skip=true`: 테스트 코드를 컴파일하지 않고, 테스트를 실행하지도 않는다.
- `-DskipTests`: 테스트 코드를 컴파일하지만 실행하지는 않는다.

## 참고 자료 

- https://stackoverflow.com/questions/21933895/what-is-the-difference-between-dmaven-test-skip-exec-vs-dmaven-test-skip-tr
