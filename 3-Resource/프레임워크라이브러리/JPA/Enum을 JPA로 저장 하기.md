# Enum을 JPA로 저장 하기

## `@Enumerated`

구현 자체는 간단하다. 필드에 `@Enumerated` 어노테이션을 붙여주면 된다.

```java
@Entity
public class Article {
    @Id
    private int id;

    private String title;

    @Enumerated(EnumType.ORDINAL)
    private Status status;
}
```

하지만 속성 값을 어떻게 주냐에 따라 두 가지로 나뉜다.

### ORDINAL

위 코드 예시와 같이 `ORDINAL`을 속성으로 주면, `Enum.ordinal()` 값을 DB에 저장하는 방식이다. enum의 순서가 바뀌면 기존에 DB에 저장되어 있는 값과 충돌하는 문제가 있다.

### STRING

`@Enumerated(EnumType.STRING)` 로 저장하게되면 `Enum.name()` 값을 DB에 저장하게 된다. enum의 순서가 바뀌어도 문제가 없다. 하지만, enum의 이름을 바꾸면 기존에 저장되어 있는 값에 문제가 생긴다.

## `@PostLoad`, `@PrePersist`

위의 문제를 해결하기 위해서 두 어노테이션을 사용하는 기법이 있다. 두 어노테이션은 JPA의 이벤트 처리와 관련 있다.

- `@PostLoad` : 엔티티가 DB에서 영속성 컨텍스트로 로드된 후에 실행되는 메서드
- `@PrePersist`: 엔티티가 영속화 되기 직전에 실행되는 메서드

예시를 통해 알아보자.

```java
public enum Priority {
    LOW(100), MEDIUM(200), HIGH(300);

    private int priority;

    private Priority(int priority) {
        this.priority = priority;
    }

    public int getPriority() {
        return priority;
    }

    public static Priority of(int priority) {
        return Stream.of(Priority.values())
          .filter(p -> p.getPriority() == priority)
          .findFirst()
          .orElseThrow(IllegalArgumentException::new);
    }
}
```

다음과 같은 enum이 있다고해보자. 참골호, `@Transient`는 필드값을 테이블의 컬럼에서 제시키기 위한 어노테이션이다.

```java
@Entity
public class Article {

    @Id
    private int id;

    private String title;

    @Enumerated(EnumType.ORDINAL)
    private Status status;

    @Enumerated(EnumType.STRING)
    private Type type;

    @Basic
    private int priorityValue;

    @Transient
    private Priority priority;

    @PostLoad
    void fillTransient() {
        if (priorityValue > 0) {
            this.priority = Priority.of(priorityValue);
        }
    }

    @PrePersist
    void fillPersistent() {
        if (priority != null) {
            this.priorityValue = priority.getPriority();
        }
    }
}
```

위와 같이 구현되어 있다면, 엔티티가 로드 된 후 `fillTransient()` 메서드를 통해 `priority` 값을 찾아오게된다. 또한, 엔티티를 영속화하기 직전에 `fillPersistent()` 메서드를 통해 `priorityValue` 값을 갱신하게 된다. 따라서, enum을 직접 저장하는 것이 아니라 enum 내부 값을 통해 enum을 구분하는 기법니다. 실행 쿼리를 보면 아래와 같이 보인다.

```sql
insert 
into
    Article
    (priorityValue, status, title, type, id) 
values
    (?, ?, ?, ?, ?)
binding parameter [1] as [INTEGER] - [300]
binding parameter [2] as [INTEGER] - [null]
binding parameter [3] as [VARCHAR] - [callback title]
binding parameter [4] as [VARCHAR] - [null]
binding parameter [5] as [INTEGER] - [3]
```

## `@Converter`

JPA 2.1부터 위의 방법을 좀 더 편하게 사용하기 위해 새로운 API가 추가됐다. 아래 코드와 같이 `@Converter`의 `autoApply` 값을 `true` 로 해두면 자동으로 엔티티와 DB 데이터 간의 매핑이 이루어진다.

```sql
@Converter(autoApply = true)
public class CategoryConverter implements AttributeConverter<Priority, Integer> {
 
    @Override
    public String convertToDatabaseColumn(Priority priority) {
        if (priority == null) {
            return null;
        }
        return priority.getPriority();
    }

    @Override
    public Priority convertToEntityAttribute(Integer priorityValue) {
        if (priorityValue > 0) {
            return null;
        }
				return Priority.of(priorityValue);
    }
}
```

```java
@Entity
public class Article {

    @Id
    private int id;

    private String title;

    private Priority priority;
}
```

## 참고 자료

[https://www.baeldung.com/jpa-persisting-enums-in-jpa](https://www.baeldung.com/jpa-persisting-enums-in-jpa)

[https://blog.advenoh.pe.kr/database/QA-JPA-관련-질문-모음/](https://blog.advenoh.pe.kr/database/QA-JPA-%EA%B4%80%EB%A0%A8-%EC%A7%88%EB%AC%B8-%EB%AA%A8%EC%9D%8C/)

[https://docs.jboss.org/hibernate/orm/4.0/hem/en-US/html/listeners.html](https://docs.jboss.org/hibernate/orm/4.0/hem/en-US/html/listeners.html)

[https://gmoon92.github.io/jpa/2019/09/29/what-is-the-transient-annotation-used-for-in-jpa.html](https://gmoon92.github.io/jpa/2019/09/29/what-is-the-transient-annotation-used-for-in-jpa.html)