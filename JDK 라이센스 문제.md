---
tags:
  - Java
title: JDK 라이센스 문제
---


* Java 애플리케이션을 컴파일하기 위한 JDK는 크게 Oracle JDK와 OpenJDK로 나뉜다. Oracle JDK의 경우 일반적인 목적(General Purpose Computing)이 아닌 경우 라이센스 비를 지불해야된다. 따라서, 여러 회사에서는 이 애매한 표현 때문에 대부분 오픈소스인 OpenJDK를 사용한다.
* Java SE7부터 모든 JDK는 OpenJDK 레퍼런스 코드를 기반으로 제작된다. Oracle JDK 또한 마찬가지다. OpenJDK 운영 주체 또한 Oracle이다.
* 오라클이 아닌 서드파티 업체가 OpenJDK를 기반으로 공인된 JDK를 제작하여 배포하려면 오라클의 유료 라이센스인 OCTLA에 가입해야 한다. 현재 전세계에 19개 업체가 가입되어 있다.[관련 링크](../../../3.Resource/%EA%B0%9C%EB%B0%9C%EC%96%B8%EC%96%B4/Java/%EA%B4%80%EB%A0%A8%20%EB%A7%81%ED%81%AC/)(http://openjdk.java.net/groups/conformance/JckAccess/jck-access.html)
* Amazon corretto는 Amazon이 직접 TCK 인증을 받아 빌드한 OpenJDK 구현체이다. Amazon은 자사의 수천대의 내부 프로뎍션 서버에 성공적으로 사용 중이기 때문에 안정성에는 전혀 문제가 없다고 밝히고 있다.

## 참고 자료

[https://mine-it-record.tistory.com/7](https://mine-it-record.tistory.com/7)
