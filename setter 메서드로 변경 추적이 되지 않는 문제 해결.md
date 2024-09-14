---
tags:
  - JPA
---
# setter 메서드로 변경 추적이 되지 않는 문제 해결

```java
Room room = Room.builder()
                .id(1L)
                .game(game)
                .tags(tags)
                .build();

room.join(user);
roomRepository.save(room);
```

위와 같은 코드가 있는데 `roomRepository.getById(1L)` 해도 user가 비어있다. `@Transactional`어노테이션을 붙이니 해결이 됐는데 원인을 모르겠다.

## 현재 추정: 트랜잭션과 변경 감지

* `roomRepository.save()`를 호출하면 트랜잭션을 기준으로 저장되는 것으로 추정된다. 따라서 위의 코드는 `@Transactional` 이 없기 때문에 트랜잭션에 모아둔 커밋이 없기 때문에 단순하게 Room Entity 자체만 저장이 되는것같다. (users는 연관관계의 주인이 아니기때문에 저장되지 않는다.)
*   `JpaRepository`의 코드를 보기로 했다. `JpaRepository`의 기본 구현체는 `SimpleJpaRepository` 로 이 부분에 `save` 메서드가 구현되어 있었다. 이 메서드에는 `@Transactional` 이 붙어있다. 따라서, 기존 트랜잭션이 있으면 참여하고, 없으면 새로 생성한다. 영속선 컨텍스트는 일반적으로 트랜잭션은 커밋하면 플러쉬가 되고 엔티티가 준영속 상태가 된다. 따라서, 변경 감지는 트랜잭션 단위로 이루어지고 동기화가 되기때문에 `@Transactional` 이 붙어있지 않은 경우는 변경 감지가 불가능해진다.

    ![setter%20%E1%84%86%E1%85%A6%E1%84%89%E1%85%A5%E1%84%83%E1%85%B3%E1%84%85%E1%85%A9%20%E1%84%87%E1%85%A7%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC%20%E1%84%8E%E1%85%AE%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%8B%E1%85%B5%20%E1%84%83%E1%85%AC%E1%84%8C%E1%85%B5%20%E1%84%8B%E1%85%A1%E1%86%AD%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%20%E1%84%92%20e78be85ac89d49408feb4a3112bd0f67/Untitled.png](assets/Untitled-4552059.png)

## 확인하기

*   만약 정말 트랜잭션과 변경 감지가 원인이라면, `@Transactional`이 없는 경우 실제 연관관계 주인인 `User`를 직접 수정해도 `Room`에 영향을 주지 못할 것이다. 트랜잭션 안이 아니라 `User`는 이미 준영속 상태기 때문이다. 아래 사진과 같이 여전히 실패하는 모습을 볼 수 있다.\\

    !\[setter%20%E1%84%86%E1%85%A6%E1%84%89%E1%85%A5%E1%84%83%E1%85%B3%E1%84%85%E1%85%A9%20%E1%84%87%E1%85%A7%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC%20%E1%84%8E%E1%85%AE%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%8B%E1%85%B5%20%E1%84%83%E1%85%AC%E1%84%8C%E1%85%B5%20%E1%84%8B%E1%85%A1%E1%86%AD%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%20%E1%84%92%20e78be85ac89d49408feb4a3112bd0f67/Untitled%201.png]\(assets/Untitled 1.png)

    !\[setter%20%E1%84%86%E1%85%A6%E1%84%89%E1%85%A5%E1%84%83%E1%85%B3%E1%84%85%E1%85%A9%20%E1%84%87%E1%85%A7%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC%20%E1%84%8E%E1%85%AE%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%8B%E1%85%B5%20%E1%84%83%E1%85%AC%E1%84%8C%E1%85%B5%20%E1%84%8B%E1%85%A1%E1%86%AD%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%20%E1%84%92%20e78be85ac89d49408feb4a3112bd0f67/Untitled%202.png]\(assets/Untitled 2-4552066.png)
*   `@Trnasactional`이 붙어있는 경우라면, 연관관계 주인이 아닌 `Room`이 호출되더라도 테스트가 통과된다.

    !\[setter%20%E1%84%86%E1%85%A6%E1%84%89%E1%85%A5%E1%84%83%E1%85%B3%E1%84%85%E1%85%A9%20%E1%84%87%E1%85%A7%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC%20%E1%84%8E%E1%85%AE%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%8B%E1%85%B5%20%E1%84%83%E1%85%AC%E1%84%8C%E1%85%B5%20%E1%84%8B%E1%85%A1%E1%86%AD%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%20%E1%84%92%20e78be85ac89d49408feb4a3112bd0f67/Untitled%203.png]\(assets/Untitled 3-4552069.png)

    ![setter%20%E1%84%86%E1%85%A6%E1%84%89%E1%85%A5%E1%84%83%E1%85%B3%E1%84%85%E1%85%A9%20%E1%84%87%E1%85%A7%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC%20%E1%84%8E%E1%85%AE%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%8B%E1%85%B5%20%E1%84%83%E1%85%AC%E1%84%8C%E1%85%B5%20%E1%84%8B%E1%85%A1%E1%86%AD%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%20%E1%84%92%20e78be85ac89d49408feb4a3112bd0f67/Untitled%204.png](../../../3.Resource/%ED%94%84%EB%A0%88%EC%9E%84%EC%9B%8C%ED%81%AC%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC/JPA/setter%20%E1%84%86%E1%85%A6%E1%84%89%E1%85%A5%E1%84%83%E1%85%B3%E1%84%85%E1%85%A9%20%E1%84%87%E1%85%A7%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC%20%E1%84%8E%E1%85%AE%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%8B%E1%85%B5%20%E1%84%83%E1%85%AC%E1%84%8C%E1%85%B5%20%E1%84%8B%E1%85%A1%E1%86%AD%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%20%E1%84%92%20e78be85ac89d49408feb4a3112bd0f67/Untitled%204.png)

## 참고 자료

[https://happyer16.tistory.com/entry/Spring-jpa-save-saveAndFlush-제대로-알고-쓰기](https://happyer16.tistory.com/entry/Spring-jpa-save-saveAndFlush-%EC%A0%9C%EB%8C%80%EB%A1%9C-%EC%95%8C%EA%B3%A0-%EC%93%B0%EA%B8%B0)

[https://www.popit.kr/jpa-변경-감지와-스프링-데이터/](https://www.popit.kr/jpa-%EB%B3%80%EA%B2%BD-%EA%B0%90%EC%A7%80%EC%99%80-%EC%8A%A4%ED%94%84%EB%A7%81-%EB%8D%B0%EC%9D%B4%ED%84%B0/)

[https://ict-nroo.tistory.com/130](https://ict-nroo.tistory.com/130)

[https://docs.spring.io/spring-data/jpa/docs/current/api/org/springframework/data/jpa/repository/support/SimpleJpaRepository.html#save-S-](https://docs.spring.io/spring-data/jpa/docs/current/api/org/springframework/data/jpa/repository/support/SimpleJpaRepository.html#save-S-)
