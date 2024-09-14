---
tags:
  - Maven
---
# Maven Repository

## 배경

- 2개의 프로젝트 사이에 의존 관계를 갖고 있을 때, 로컬에서 빌드하는 방법을 몰랐다.

## Maven Repository

- Maven은 3가지 종류의 레포지토리를 지원한다.
  - local: 로컬 장치의 폴더
  - central: Maven 커뮤니티에서 제공하는 레포지토리
  - remote: 어떤 조직의 커스텀 레포지토리
- Maven에서는 빌드 했을 때 프로젝트를 로컬에서 재사용 할 수 있도록 로컬에 저장한다.

## 해결 방법

- 의존이 되는 프로젝트를 먼저 local repository에 배포하고 빌드하면 성공적으로 빌드된다.

  ```shell
  mvn install # 빌드 후 local repository에 배포
  ```

## 참고 자료

- https://www.baeldung.com/maven-local-repository