---
title: 2-JPA 시작
tags:
  - 도서/자바-ORM-표준-JPA-프로그래밍
---
## 객체 매핑 시작

```sql
CREATE TABLE MEMBER (  
    ID VARCHAR(255) NOT NULL,  
    NAME VARCHAR(255),  
    AGE INTEGER,  
    PRIMARY KEY(ID)  
)
```

```kotlin
@Entity  
@Table(name = "MEMBER")  
class Member(  
    @Id  
    @Column(name = "ID")  
    var id: String,  
    @Column(name = "NAME")  
    var username: String,  
    var age: Int,  
)
```

- `@Entity`: 이 클래스를 테이블과 매핑된다고 JPA에게 알려준다.
- `@Table`: 엔티티 클래스에 매핑할 테이블 정보를 알려준다. `name` 속성을 사용해 `Member`엔티티를 `MEMBER` 테이블에 매핑했다.
- `@Id`: 엔티티 클래스의 필드를 테이블의 기본 키에 매핑한다.
- `@Column`: 필드를 컬럼에 매핑한다. `name` 속성을 사용해 `Member.username` 필드를 `MEMBER` 테이블의 `NAME` 컬럼에 매핑했다.
	- 매핑 정보가 없는 필드는 필드명을 사용해서 컬럼명으로 자동으로 매핑한다.

> kotlin 클래스와 매핑을 할 때는 [링크](https://kotlinlang.org/docs/no-arg-plugin.html#jpa-support)와 같이 플러그인을 추가하면 no-arg 생성자 없이도 매핑이 가능하다.

## persistence.xml 설정

- JPA는 persistence.xml을 사용해서 필요한 설정 정보를 관리한다.
	- 설정 파일이 META_INF/persistence.xml 클래스 패스 경로에 있으면 별도의 설정없이 JPA가 인식할 수 있다.
- 데이터베이스당 하나의 영속성 유닛을 등록한다.
- 영속성 유닛에 필요한 속성
	- JPA 표준 속성
		- `javax.persistence.jdbc.driver`: JDBC 드라이버
		- `javax.persistence.jdbc.user`: 데이터베이스 접속 아이디
		- `javax.persistence.jdbc.password`: 데이터베이스 접속 비밀번호
		- `javax.persistence.jdbc.url`: 데이터베이스 접속 URL
	- 하이버네이트 속성
		- `hibernate.dialect`: 데이터베이스 방언 설정

### 데이터베이스 방언

- SQL 표준을 지키지 않거나 특정 데이터베이스만의 고유한 기능을 JPA에서는 방언(Dialect)라고 한다.
	- 데이터 타입: MySQL은 `VARCHAR`, 오라클은 `VARCHAR2`
	- 함수명: 문자열로 자르는 함수로 SQL 표준은 `SUBSTRING()`, 오라클은 `SUBSTR()`
	- 페이징 처리: MySQL은 `LIMIT`, 오라클은 `ROWNUM`
- 개발자는 JPA가 제공하는 표준 문법에 맞추어 JPA를 사용하면 되고, 특정 데이터베이스에 의존적인 SQL은 데이터베이스 방언이 처리해준다.

### 하이버네이트 전용 속성

- `hibernate.show_sql`: 하이버네이트가 실행한 SQL을 출력한다.
- `hibernate.format_sql`: 하이버네이트가 실행한 SQL을 출력할 떄 보기 쉽게 정렬한다.
- `hibernate.use_sql_comments`: 쿼리를 출력할 떄 주석도 함께 출력한다.
- `hibernate.id.new_generator_mappings`: JPA 표준에 맞는 새로운 키 생성 전략을 사용한다.

## 애플리케이션 개발

![](assets/Pasted%20image%2020241022230928.png)

```java
// 엔티티 매니저 팩토리 생성
EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpabook");
EntityManager em = emf.createEntityManager(); // 엔티티 매니저 생성

EntityTransaction tx = em.getTransaction(); // 트랜잭션 기능 획득

try {

	tx.begin(); // 트랜잭션 시작
	logic(em);  // 비즈니스 로직
	tx.commit();// 트랜잭션 커밋

} catch (Exception e) {
	e.printStackTrace();
	tx.rollback(); // 트랜잭션 롤백
} finally {
	em.close(); // 엔티티 매니저 종료
}

emf.close(); // 엔티티 매니저 팩토리 종료
```


### 엔티티 매니저 설정

- `Persistence` 클래스가 persistence.xml 설정 정보를 가져와 엔티티 매너저 팩토리를 생성하게 해준다.
	- 파라미터로 영속성 유닛 이름을 넘겨준다.
	- `EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpabook")`
- 엔티티 매니저 팩토리는 애플리케이션 전체에서 딱 한 번만 생성하고 공유해서 사용해야 한다.
	- persikstcne.xml 파일을 읽어 JPA를 동작시키기 위한 기반 객체를 만들고, JPA 구현체에 따라서는 데이터베이스 커넥션 풀도 생성하기 때문에 생성 비용이 아주 크다.

> spring-boot-starter-data-jpa 을 사용 중일 때는 "default" 라는 이름으로 영속성 유닛 이름을 사용하는 것을 확인할 수 있었다.
> ![](assets/Pasted%20image%2020241022225530.png)

- 엔티티 매니저 생성
	- `EntityManager em = emf.createEntityManager()`
	- 엔티티 매니저를 사용해서 엔티티를 데이터베이스에 등록/수정/삭제/조회할 수 있다.
	- 엔티티 매니저는 커넥션과 밀접한 관계가 있으므로 스레드 간에 공유하거나 재사용하면 안 된다.
- 종료
	- 사용이 끝난 엔티티 매니저는 반드시 종료해야 한다.
		- `em.close()`
	- 애플리케이션을 종료할 때 엔티티 매니저 팩토리도 종료해야 한다.
		- `emf.close()`

### 트랜잭션 관리

- JPA를 사용하면 항상 트랜잭션 안에서 데이터를 변경해야 한다.
- 트랜잭션 없이 데이터를 변경하면 예외가 발생한다.
- 엔티티 매니저의 트랜잭션 API를 받아와서 트랜잭션을 시작한다.

### 비즈니스 로직

- 등록: 엔티티 매니저의 persist() 메소드에 저장할 엔티티를 넘겨주면, 엔티티의 매핑 정보를 분석해 SQL을 만든다.
- 수정: JPA는 어떤 에티티가 변경되었는지 추적하는 기능을 갖추고 있어, 엔티티의 값만 변경하면 SQL을 생성한다.
- 삭제: 엔티티 매니저의 `remove()` 메소드에 삭제하려는 엔티티를 넘겨준다.
- 한 건 조회: `find()` 메소드는 조회할 엔티티 타입과 `@Id`로 데이터베이스 테이블의 기본 키와 매핑한 식별자 값으로 엔티티 하나를 조회하는 가장 단순한 조회 메소드다.
	- `Member findMember = em.find(Member.class, id)`

### JPQL

```java
List<Member> members = em.createQuery("select m from Member m", Member.class).getResultList();
```

- 테이블이 아닌 엔티티 객체를 대상으로 검색하려면 데이터베이스의 모든 데이터를 애플리케이션으로 불러와서 엔티티 객체로 변경한 다음 검색해야하는데, 이는 사실상 불가능하다.
- 애플리케이션이 필요한 데이터만 데이터베이스에서 불러오려면 결국 검색 조건이 포함된 SQL을 사용해야하는데, JPA는 JPQL이라는 쿼리 언어로 이를 해결한다.
- JPQL은 엔티티 객체를 대상으로 쿼리한다.
	- JPQL은 데이터베이스 테이블을 전혀 알지 못한다.
