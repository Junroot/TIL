---
tags:
  - Spring-Framework
title: properties에 비밀 번호 남는 문제 해결
---


- 현재는 일단 properties에 비밀번호를 입력하지 않고 실행시 아래와 같이 실행하도록 구현해뒀다

    ```java
    java -jar -Dspring.datasource.password=abcd1234 abc.jar
    ```

- 환경 변수를 이용하는 방법도 있다.
    - [https://stackoverflow.com/questions/37404703/spring-boot-how-to-hide-passwords-in-properties-file](https://stackoverflow.com/questions/37404703/spring-boot-how-to-hide-passwords-in-properties-file)
