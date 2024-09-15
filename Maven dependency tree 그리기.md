---
tags:
  - Maven
title: Maven dependency tree 그리기
---


## 배경

- 팀내에 사용하고 있는 컴포넌트 간에 어떤 의존 관계를 가지고 있는지, 의존 관계에 사이클이 존재하지 않는지 확인이 필요했다.

## 문법

```bash
mvn dependency:tree -Dincludes=[groupId]:[artifactId]:[type]:[version]
```

- `-Dincludes` 또는 `-Dexcludes` 옵션을 통해 자신이 원하는 의존만 필터링해서 볼 수 있다.

- `groupId`, `artifactId`, `type`, `version` 중에 자신이 필터링을 원치 않는 값은 빈값으로 해두면 되고, 와일드 카드도 사용할 수 있다.

  - ```bash
    org.apache.*:::	



## 참고 자료

- https://maven.apache.org/plugins/maven-dependency-plugin/examples/filtering-the-dependency-tree.html
