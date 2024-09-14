---
tags:
  - Maven
---
# 빌드 시 profile 설정

- `-P {프로필 명}`
- 쉼표로 구분해서 프로필을 여러개 설정할 수 있다.

```sh
mvn -P profile-1,profile-2 package
```

## 참고 자료

- https://maven.apache.org/guides/introduction/introduction-to-profiles.html