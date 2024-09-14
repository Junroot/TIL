---
tags:
  - Java
---
# ClassLoader

- Java에서 ClassLoader는 자바 클래스를 JVM으로 동적으로 로드하기 위한 객체다.
- ClassLoader 덕분에 파일 시스템과 파일의 구조에 대해서 알 필요가 수 있다.
- Java의 클래스들은 한 번에 전부 로드되는 것이 아니라 애플리케이션에서 필요할 때 로드한다. 이 때 ClassLoader가 호출되고 ClassLoader가 동적으로 메모리에 로드한다.

## ClassLoader의 종류

### Bootstrap Class Loader

자바 클래스들은 `java.lang.ClassLoader`에 의해 로드된다. 하지만 이 `ClassLoader`도 결국엔 클래스다. 이 `java.lang.ClassLoader`를 로드하기 위한 것이 바로 Bootstrap Class Loader다. Bootstrap Class Loader는 다른 ClassLoader의 부모 역할을 한다. Bootstrap Class Loader는 core JVM의 일부이면 네이티브 코드로 작성되어 있어서 `getClassLoader` 메서드로 호출하면 null이 반환된다.

### Extension Class Loader

Bootstrap Class Loader의 자식으로, 자바 익스텐션 클래스들을 로드할 때 사용한다. 

### System Class Loader

애플리케이션 레벨 클래스들을 로드할 때 사용한다. `-classpath` 나 `-cp` 같은 커맨드라인 같은 classpath 환경 변로 찾은 파일들을 로드한다. Extension Class Loader의 자식이다.

## 참고 자료

[https://www.baeldung.com/java-classloaders](https://www.baeldung.com/java-classloaders)