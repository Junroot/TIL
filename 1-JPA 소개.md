---
title: JPA 소개
tags:
  - 도서/자바-ORM-표준-JPA-프로그래밍
---
## SQL을 직접 다룰 떄 발생하는 문제점

### 반복, 반복 그리고 반복

- 객체를 데이터베이스에 CRUD하려면 너무 많은 SQL과 JDBC API를 코드로 작성해야 한다.
	- SQL 작성
	- JDBC API를 사용해서 SQL 실행
	- SQL과 객체의 매핑
- 테이블마다 이런 일을 반복해야 해서 작성해야 된다.

### SQL에 의존적인 개발

- Member 객체에 새로운 필드 Team을 추가할 경우
	- 클래스에 필드 추가
	- CRUD 쿼리 수정
	- 연관 관계 매핑을 위한 JOIN 쿼리가 있는 새로운 DAO 메소드 추가
- Member 객체는 team 필드가 있는지 확인하기 위해 DAO를 열어서 SQL을 확인할 수 밖에 없다.
- 결론
	- 진정한 의미의 계층 분할이 어렵다.
	- 엔티티를 신뢰할 수 없다.
	- SQL에 의존적인 개발을 피하기 어렵다.

### JPA와 문제 해결

- JPA를 사용하면 객체를 데이터베이스에 저장하고 관리할 때, 개발자가 직접 SQL을 작성하는 것이 아니라 JPA가 제공하는 API를 사용하면 된다.
- 저장: `jpa.persist(member)` 같이 메소드를 호출하면 매핑정보를 보고 적절한 INSERT SQL을 생성하여 전달한다.
- 조회: `jpa.find(Member.class, memberId)` 같이 메소드를 호출하면 객체와 매핑 정보를 보고 적절한 SELECT SQL을 생성하여 전달하고 객체를 반환한다.
- 수정: 수정 메소드를 제공하지 않고, 객체 내의 값을 변경하면 트랜잭션을 커밋할 때 적절한 UPDATE SQL이 전달된다.

```java
Member member = jpa.find(Member.class, memberId);
member.setName("이름변경");
```

- 연관된 객체 조회: 연관된 객체를 사용하는 시점에 적절한 SELECT SQL을 실행한다.

```java
Member member = jpa.find(Member.class, memberId);
Team team = jmember.getTeam(); // 사용하는 시점에 SELECT SQL 실행
```

## 패러다임의 불일치

- 객체지향 프로그래밍은 추상화, 캡슐화, 정보은닉, 상속, 다형성 등 시스템의 복잡성을 제어할 수 있는 다양한 장치들을 제공한다.
- 객체는 필드와 메소드를 가진다.
	- 메소드는 클래스에 정의되어 있으므로 객체의 인스턴스의 상태인 필드만 데이터베이스에 저장하면된다.
- 객체와 관계형 데이터베이스의 패러다임 불일치
	- 객체와 관계형 데이터베이스는 지향하는 목적이 다르므로 둘의 기능과 표현하는 방법이 다르다.
	- 객체 구조를 테이블 구조에 저장하려면 이 표현 방법이 달라서 발생하는 문제를 개발자가 해결해야된다.

### 상속

- 테이블에는 상속이라는 기능이 없어서, 아래와 같은 방법으로 테이블을 설계할 수 있다.
- ![](assets/Pasted%20image%2020241021214656.png)
- JDBC  API를 사용해서 이 코드를 완성하려면 아래와 같이, 부모 데이터와 자식 데이터를 분리해서 모두 SQL을 작성해줘야 한다.

```SQL
INSERT INTO ITEM ...
INSERT INTO ALBUM ...

INSERT INTO ITEM ...
INSERT INTO MOVIE ...

SELECT I.*, A.*
	FROM ITEM I
	JOIN ALBUM A ON I.ITEM_ID = A.ITEM_ID
```

### 연관관계

- 객체는 참조를 사용해서 다른 객체와 연관관계를 가지고 참조에 접근해서 연관된 객체를 조회한다.
- 반면에 테이블은 외래 키를 사용해서 다른 테이블과 연관관계를 가지고 조인을 사용해서 연관된 테이블을 조회한다.
	- ![](assets/Pasted%20image%2020241021215825.png)
	- ![](assets/Pasted%20image%2020241021215831.png)
- 객체를 테이블에 맞추어 모델링할 경우
	- 객체를 테이블에 저장하거나 조회할 때는 편리하지만, 좋은 객체 모델링을 기대하기 어렵고 결국 객체지향의 특징을 잃어버리게 된다.

```java
class Member{
  String id;       //MEMBER_ID 컬럼 사용
  Long teamId;     //TEAM_ID FK 컬럼 사용
  String username; //USERNAME 컬럼 사용
}

class Team{
  Long id;         //TEAM_ID PK 사용
  String name;     //NAME 컬럼 사용
}
```

- 객체지향 모델링할 경우
	- 객체가 외래 키의 값을 그대로 보관하는 것이 아니라 연관된 Team의 참조를 보관한다.
	- 반면에 테이블은 참조가 필요 없고 외래 키만 있으면 되기 떄문에 개발자가 중간에서 변환 역할을 해야 한다.(패러다임 불일치)
- JPA가 이런 패러다임 불일치를 해결해준다.
	- 개발자는 회원과 팀의 관게를 설정하고 회원 객체를 저장하면 된다.
	- 객체를 조회할 때 외래 킬를 참조로 변환하는 일도 JPA가 처리해준다.

```java
member.setTeam(team); // 회원과 팀 연관관계 설정
jpa.persist(member); // 회원과 연관관계 함께 저장

Member member = jpa.find(Member.class, memberId);
Team team = member.getTeam();
```

### 객체 그래프 탐색

![](assets/Pasted%20image%2020241021220935.png)

- SQL을 직접 다루면 처음 실행하는 SQL에 따라 객체 그래프를 어디까지 탐색할 수 있는지 정해진다.
	- 이는 비즈니스 로직에 따라 사용하는 객체 그래프가 다른데 언제 끊길지 모를 객체 그래프를 함부로 탐색할 수 없어서 객체지향 프고르매잉에 큰 제약이 된다.

```java
class MemberService{
  ...
  public void process(){
    Member member = memberDAO.find(memberId);
    member.getTeam(); //member->team 객체 그래프 탐색이 가능한가?
    member.getOrder().getDelivery(); //??? (예측 불가)
  }
}
```

- JPA를 사용하면 객체 그래프를 마음껏 탐색할 수 있다.
	- 지연 로딩: 실제 객체를 사용하는 시점까지 데이터베이스 조회를 미루는 기능
	- `Member`를 사용할 때마다 `Order`를 함께 사용하면, 간단한 설정으로 즉시 함께 JOIN하여 조회할 수 있게 정의할 수 있다.

```java
//처음 조회 시점에 SELECT MEMBER SQL
Member member = jpa.find(Member.class, memberId);

Order order = member.getOrder();
order.getOrderData(); //Order를 사용하는 시점에 SELECT ORDER SQL
```

### 비교

- 데이터베이스는 기본 키의 값으로 각 로우를 구분한다.
- 객체는 동일성 비교와 동등성 비교라는 두 가지 비교 방법이 있다.
	- 동일성 비교: `==` 비교. 인스턴스의 주소 값을 비교한다.
	- 동등성 비교: `equals` 비교. 객체 내부의 값을 비교한다.
- SQL을 직접 다루면 같은 로우를 조회했지만 객체의 동일성 비교에는 실패한다.

```java
String memberId = "100";
Member member1 = memberDAO.getMember(memberId);
Member member2 = memberDAO.getMember(memberId);

member1 == member2;   //다르다.
```

- JPA는 같은 트랜잭션일 때 같은 객체가 조회되는 것을 보장한다.
	- 그러므로 아래 코드는 동일성 비교에 성공한다.

```java
String memberId = "100";
Member member1 = jpa.find(Member.class, memberId);
Member member2 = jpa.find(Member.class, memberId);

member1 == member2; //같다.(같은 트랜잭션일 경우)
```

### 정리

- 객제 모델과 관계형 데이터베이스 보델의 패러다임 불일치를 극복하기 위해 개발자가 너무 많은 시간과 코드를 소비한다.
- JPA는 패러다임 불일치 문제를 해결해주고 정교한 객체 모델링을 유지하게 도와준다.

## JPA란 무엇인가?

- JPA(Java Persistence API): 자바 진영의 ORM 기술 표준
- ORM(Object-Relational Mapping): 객체와 관계형 데이트베이스를 매핑한다는 뜻
- 자바 진영에는 다양한 ORM 프레임워크들이 있는데 그중에 하이버네이트 프레임워크가 가장 많이 사용된다.
	- 하이버네이트는 거의 대부분의 패러다임 불일치 문제를 해결해주는 성숙한 ORM 프레임워크다.
- ![](assets/Pasted%20image%2020241021222324.png)
- ![](assets/Pasted%20image%2020241021222328.png)

### JPA 소개

- 과거 자바 진영에는 JEB라는 기술 표준을 만들었는데 그 안에 "엔티티 빈"이라는 ORM 기술도 포함되어 있었다.
	- 하지만 너무 복잡하고 기술 성숙도도 떨어졌으며 J2EE 애플리케이션 서버에서만 동작했다.
- 이 때 하이버네이트라는 오픈소스 ORM 프레임워크가 등장했는데 상대적으로 가볍고 실용적인 데다가 기술 성숙도도 높았다.
- 결국 EJB 3.0에서 하이버네이트를 기반으로 새로운 자바 ORM 기술 표준이 만들어졌는데 이것이 바로 JPA다.
- JPA는 자바 ORM 기술에 대한 인터페이스를 모아둔 것이고, 다양한 구현체가 존재한다.
	- ![](assets/Pasted%20image%2020241021222904.png)

### 왜 JPA를 사용해야 하는가?

- 생산성: 반복적인 코드와 CRUD용 SQL을 개발자가 직접 작성하지 않아도 된다.
- 유지보수:개발자가 작성해야 했던 SQL과 JDBC API 코드를 JPA가 대신 처리해주므로 유지보수해야 하는 코드 수가 줄어든다.
- 패러다임의 불일치 해결
- 성능: 애플리케이션과 데이터베이스 사이에 다양한 성능 최적화 기회를 제공한다.
	- 예) 하나의 트랜잭션에서 같은 객체를 두 번 조회하면, 두 번째 조회는 앞서 조회한 객체를 재사용한다.
- 데이터 접근 추상화와 벤더 독립성
	- 관계형 데이터베이스는 같은 기능도 벤더마다 사용버이 다른 경우가 많다.
	- JPA는 애플리케이션과 데이터베이스 사이에 추상화된 데이터 접근 계층을 제공해서 애플리케이션이 특정 데이터베이스 기술에 종속되지 않도록 한다.
	- ![](assets/Pasted%20image%2020241021223533.png)
- 표준: JPA는 자바 진영의 ORM 기술 표준이다.
