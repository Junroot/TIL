---
title: Java에서 DNS 캐시 TTL 설정
tags:
  - Java
---
## 배경

- DNS LookUp을 통해 도메인에 대한 IP 정보를 조회한다.
- JVM에서는 이런 IP 정보를 캐싱해서 매번 DNS LookUp을 하지 않는다.
- TTL을 설정하면 캐시가 남아 있는 주기를 설정할 수 있다.

## security 파일 수정으로 TTL 변경하기

- Java 8 기준 `$JAVA_HOME/jre/lib/security/java.security`, Java 11 이상 기준 `$JAVA_HOME/conf/security/java.security` 파일에 있는 `networkaddress.cache.ttl` 프로퍼티 값을 설정하면 변경할 수 있다.
- 아래 예시는 TTL을 5초로 수정하는 예시다.

```
#
# This is the "master security properties file".
#
# An alternate java.security properties file may be specified
...
# The Java-level namelookup cache policy for successful lookups:
#
# any negative value: caching forever
# any positive value: the number of seconds to cache an address for
# zero: do not cache
...
networkaddress.cache.ttl=5
...
```

## 프로그래밍 방식으로 TTL 변경하기

- 아래와 같이 `java.security.Security.setProperty`를 호출하면 Security property를 수정할 수 있다.

```java
java.security.Security.setProperty("networkaddress.cache.ttl", "5");
```

## 참고 자료

- https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/jvm-ttl-dns.html
- https://medium.com/@avocadi/dns-cache-ttl-in-java-adb1c0525459
- https://docs.oracle.com/javase/8/docs/api/java/security/Security.html
