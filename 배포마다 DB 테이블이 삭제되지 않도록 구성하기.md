---
tags:
  - JPA
  - Flyway
title: 배포마다 DB 테이블이 삭제되지 않도록 구성하기
---

`properties` 파일에 아래의 설정을 추가하여 해결했다.

```java
spring.jpa.hibernate.ddl-auto=validate
```

## 문제점: 새로운 not null 컬럼이 추가되었을 때 기존 row들은 어떻게 처리하는 것이 좋을까?

예를들어, 서비스가 확장되면서 `User`에 `Age`컬럼이 추가되었을 때, `Age`가 not null 이라면 기존의 사용자 데이터는 어떻게 처리하는 것이 좋을까?

→ 구글링 결과, 방법은 1. not null을 포기하거나 2. default value를 설정하거나 두 가지 방법 밖에없다. 상태로 컬럼을 추가하는 수밖에 없다. (어떻게 보면 당연하다 우리가 사용자의 나이를 추측할 순 없으니까)

### 1. not null 포기

기존 데이터는 null로 두고 이후에 생성되는 데이터에서는 null이 들어오지 못하도록 DTO에서 null 값체크를 하도록 구현한다.

### 2. default value 두기

기존 데이터에 default value를 설정하고 값을 설정하도록 한다. 이후에 이 default 값을 사용하고 싶지 않다면 default value에 대한 제약사항을 삭제하면 된다. 이 방법의 경우, 위 예시인 나이에는 맞지 않을 거라는 생각이 든다.

### 출처

[https://stackoverflow.com/questions/64025530/add-not-null-column-without-default-but-with-values](https://stackoverflow.com/questions/64025530/add-not-null-column-without-default-but-with-values)

[https://stackoverflow.com/questions/3997966/can-i-add-a-not-null-column-without-default-value](https://stackoverflow.com/questions/3997966/can-i-add-a-not-null-column-without-default-value)

## 문제점: DB 스키마에 변경 사항이 있다면 매번 DB서버에 접속하여 수정해야되나?

→ 자료 조사를 해보니, 이런 상황 때문에 DB 마이그레이션이 필요하다고 한다. 마이그레이션 툴 중 Spring boot에서 사용하는 대표적인 것이 flyway다.

## flyway 시작하기

다음 글을 참고했다.([https://wooody92.github.io/spring boot/Spring-Boot-DB-초기화와-DB-마이그레이션-툴/](https://wooody92.github.io/spring%20boot/Spring-Boot-DB-%EC%B4%88%EA%B8%B0%ED%99%94%EC%99%80-DB-%EB%A7%88%EC%9D%B4%EA%B7%B8%EB%A0%88%EC%9D%B4%EC%85%98-%ED%88%B4/))

### 1. 의존성 추가

```java
implementation 'org.flywaydb:flyway-core:7.12.0'
```

[https://flywaydb.org/documentation/usage/plugins/springboot.html](https://flywaydb.org/documentation/usage/plugins/springboot.html)

### 2. sql 추가

![Untitled.png](assets/Untitled_15.png)

```sql
create table game
(
    id    bigint auto_increment,
    image varchar(255) not null,
    name  varchar(255) not null,
    primary key (id)
);
create table room
(
    id            bigint auto_increment,
    created_date  timestamp,
    is_deleted    boolean not null,
    max_headcount integer,
    game_id       bigint  not null,
    primary key (id)
);
create table session
(
    id         bigint auto_increment,
    session_id varchar(255) not null,
    room_id    bigint       not null,
    user_id    bigint       not null,
    primary key (id)
);
create table tag
(
    id   bigint auto_increment,
    name varchar(255) not null,
    primary key (id)
);
create table tag_registration
(
    id       bigint auto_increment,
    room_id  bigint not null,
    tag_name bigint not null,
    primary key (id)
);
create table user
(
    id        bigint auto_increment,
    avatar    varchar(255) not null,
    joined_at timestamp,
    nickname  varchar(255) not null,
    room_id   bigint,
    primary key (id)
);
alter table room
    add constraint fk_room_game foreign key (game_id) references game(id);
alter table session
    add constraint fk_session_room foreign key (room_id) references room(id);
alter table session
    add constraint fk_session_user foreign key (user_id) references user(id);
alter table tag_registration
    add constraint fk_tag_registration_room foreign key (room_id) references room(id);
alter table tag_registration
    add constraint fk_tag_registration_tag foreign key (tag_name) references tag(id);
alter table user
    add constraint fk_user_room foreign key (room_id) references room(id);
```

constraint 네이밍은 아래의 컨벤션을 사용했다.

[https://www.c-sharpcorner.com/UploadFile/f0b2ed/what-is-naming-convention/](https://www.c-sharpcorner.com/UploadFile/f0b2ed/what-is-naming-convention/)

## 마이그레이션 확인하기

내 노트북에 mysql을 설치하여 직접확인해본다.

1. 위의 구성 실행해보기: 성공적으로 테이블이 생성되었다.

![](assets/Pasted%20image%2020231123132329.png)

1. 컬럼 추가해보기: Game 엔티티에 `specialName` 컬럼을 추가해봤다.

![](assets/Pasted%20image%2020231123132350.png)

![](assets/Pasted%20image%2020231123132407.png)

![](assets/Pasted%20image%2020231123132428.png)

![](assets/Pasted%20image%2020231123132443.png)

`special_name`컬럼이 추가된 것을 확인할 수 있다! 

### 출처

[https://wooody92.github.io/spring boot/Spring-Boot-DB-초기화와-DB-마이그레이션-툴/](https://wooody92.github.io/spring%20boot/Spring-Boot-DB-%EC%B4%88%EA%B8%B0%ED%99%94%EC%99%80-DB-%EB%A7%88%EC%9D%B4%EA%B7%B8%EB%A0%88%EC%9D%B4%EC%85%98-%ED%88%B4/)

(영상근로의 힘을 이용해서 아직 올라오지 않은 코기의 flyway 영상)
