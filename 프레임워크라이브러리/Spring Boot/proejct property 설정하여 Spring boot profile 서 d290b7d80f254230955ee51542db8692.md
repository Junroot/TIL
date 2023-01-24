# proejct property 설정하여 Spring boot profile 설정하기

![Untitled](proejct%20property%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%8B%E1%85%A7%20Spring%20boot%20profile%20%E1%84%89%E1%85%A5%20d290b7d80f254230955ee51542db8692/Untitled.png)

위의 방법으로 gradle을 실행시킬 때 project property를 설정할 수 있다.

```java
SPRING_PROFILES_ACTIVE=local ./gradlew build sonarqube --info
```

위의 방법으로 gradle 빌드할 때 spring의 프로필을 설정할 수 있다.

## 참고 자료

[https://docs.gradle.org/current/userguide/build_environment.html#sec:project_properties](https://docs.gradle.org/current/userguide/build_environment.html#sec:project_properties)

[https://stackoverflow.com/questions/23367507/how-to-pass-system-property-to-gradle-task](https://stackoverflow.com/questions/23367507/how-to-pass-system-property-to-gradle-task)