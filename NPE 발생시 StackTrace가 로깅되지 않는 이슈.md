---
tags:
  - Java
title: NPE 발생시 StackTrace가 로깅되지 않는 이슈
---


## 배경

- NPE가 발생하고 있는 이슈가 발생해서 로그를 확인하니, 아래와 같이 로그가 남아있고 stack trace가 로깅되어 있지 않았다.

```java
java.lang.NullPointerException
```

## 원인

- JVM에서 최초로 발생하는 예외를 출력하고, 이를 기억해뒀다가 자주 발생하는 것이 확인되면 더 이상 stack trace는 출력하지 하지않도록 최적화가 이루어지고 있다.
- 이를 기능을 사용하지 않고, 항상 stack trace를 출력하려면 아래와 같이 JVM 옵션을 추가해야된다.

```java
-XX:-OmitStackTraceInFastThrow
```

## 참고 자료

- https://stackoverflow.com/questions/2411487/nullpointerexception-in-java-with-no-stacktrace
