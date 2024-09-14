---
tags:
  - Maven
---
# 테스트 코드도 jar에 포함 시키기

## 배경

- 여러 컴포넌트의 테스트 코드에서 테스트 픽스처로 공통적으로 구성되어야 하는 로직이 있었다.
- 이를 core 컴포넌트의 테스트 코드(/src/test)에 구현하고 모든 컴포넌트에서 사용할 수 있도록 하고 싶었다.

## Apache Maven JAR Plugin

- maven에서 jar로 package할 때 사용되는 기본 플러그인
- 해당 플러그인의 execution을 추가해서 테스트 코드를 별도의 jar 파일로 패키징할 수 있다.
	- `<execution>`: maven 라이프사이클 중에 플러그인이 실행하고자 하는 내용을 정의할 수 있다.

### 테스트 코드를 추가하고자 하는 컴포넌트의 maven 설정

- 아래와 같이 설정하면 프로덕션 코드는 `{artifactId}-{version}.jar`에 생성되고, 테스트 코드는 `{artifactId}-{version}-{classifier}.jar`에 생성된다. classfier를 따로 지정하지 않으면 `tests`로 지정된다.
- ![](assets/Pasted%20image%2020230509144409.png)

### 재사용하는 컴포넌트의 maven 설정
- dependecy type이 `test-jar`이면 classifier의 기본값은 `tests`이어서 생략이 가능하다.
- ![](assets/Pasted%20image%2020230509144428.png)

## 참고 자료

- https://www.codetab.org/tutorial/apache-maven/plugins/maven-plugin-execution/
- https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Packaging
- https://maven.apache.org/ref/3.8.6/maven-core/artifact-handlers.html
- https://www.baeldung.com/maven-artifact-classifiers