---
tags:
  - JPA
---
# 논리적 삭제를 하고 있는 Entity가 지연 로딩시 삭제된 엔티티도 불러오는 문제

## 문제 상황

```java
@EntityListeners(AuditingEntityListener.class)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class Room {

		@OneToMany(mappedBy = "room")
    private final List<Session> sessions = new ArrayList<>();

		//...
}
```

```java
@EntityListeners(AuditingEntityListener.class)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class Session {

		@Column(nullable = false)
    private boolean deleted = false;

		//...

		public void delete() {
        if (user.isLinkedSession(this)) {
            user.unLinkSession(this);
        }
        if (room.containsSession(this)) {
            room.exitSession(this);
        }
        deleted = true;
    }
}
```

`Session`은 논리적 삭제를 사용하고 있는데, `Room`의 `sessions`필드가 지연로딩 될 때, 논리적 삭제를 사용하고 있는 것을 모르기 때문에 모든 session을 가지고 오는 문제가 있었다.

## 해결

Hibernate에서 제공해주는 어노테이션인 `@Where` 어노테이션을 이용했다. 이 어노테이션으로 해당 엔티티를 조회하는 모든 쿼리에 where절이 추가된다.

```java
@EntityListeners(AuditingEntityListener.class)
@Getter
@Where(clause = "deleted=false")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class Session {

	//...

}
```

이 어노테이션을 사용할 때 주의해야될 점이 있다. SQL문에 해당 어노테이션의 문구를 삽입하는 것이기때문에, 이미 영속성 컨텍스트 내에 있는 엔티티의 경우 `deleted`를 `true`로 바꿔도 영속성 컨텍스트에는 남아있으니 유의해야된다. 

## 참고 자료

[https://www.baeldung.com/spring-jpa-soft-delete#how-to-get-the-deleted-data](https://www.baeldung.com/spring-jpa-soft-delete#how-to-get-the-deleted-data)

[https://www.baeldung.com/hibernate-dynamic-mapping#filtering-entities-with-where](https://www.baeldung.com/hibernate-dynamic-mapping#filtering-entities-with-where)

[https://stackoverflow.com/questions/40254962/hibernate-soft-deletion-for-child-table](https://stackoverflow.com/questions/40254962/hibernate-soft-deletion-for-child-table)