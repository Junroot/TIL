---
title: 12-스프링 데이터 JPA
tags:
  - 도서/자바-ORM-표준-JPA-프로그래밍
---
- JPA를 사용해서 데이터 접근 계층을 개발할 때도 유사한 코드를 반복해서 개발해야 한다.
- 이런 문제를 해결하려면 제네릭과 상속을 적절히 사용해서 공통 부분을 처리하는 부모 클래스를 만들면 되지만, 공통 기능이 부모 클래스에 너무 종속되고 구현 클래스 상속이 가지는 단점에 노출된다.

## 스프링 데이터 JPA 소개

- 스프링 데이터 JPA는 데이터 접근 계층을 개발할 때 구현 클래스 없이 인터페이스만 작성해도 개발을 완료할 수 있다.
- ![](assets/Pasted%20image%2020250225213341.png)
	- `MemberRepository.findByUsername()` 처럼 직접 작성한 메소드도 메소드 이름을 분석해서 다음 JPQL을 실행한다.
		- `select m from Member m where username =:username`

### 스프링 데이터 프로젝트

- 스프링 데이터 JPA는 스프링 데이터 프로젝트의 하위 프로젝트 중 하나다.
- ![](assets/Pasted%20image%2020250225213640.png)

## 스프링 데이터 JPA 설정

- 의존성 추가
	- ![](assets/Pasted%20image%2020250225213814.png)
- 스프링 설정에서 `@EnableJpaRepositories` 어노테이션을 추가하고 `basePackages`에서는 리포지토리를 검색할 패키지를 적는다.
	- ![](assets/Pasted%20image%2020250225213903.png)

## 공통 인터페이스 기능

- 스프링 데이터 JPA는 간단한 CRUD 기능을 처리하는 `JpaRepository` 인터페이스를 제공한다.
- ![](assets/Pasted%20image%2020250225214429.png)
- 주요 메서드
	- `save(S)`: 새로운 엔티티를 저장하고 이미 있는 엔티티는 수정한다.
		- 엔티티에 식별자 값이 없으면 새로운 엔티티로 판단해서 `EntityManager.persist()`를 호출하고 식별자 값이 있음녀 이미 있는 엔티티로 판단해서 `EntityManager.merge()`를 호출한다.
		- 필요하다면 스프링 데이터 JPA의 기능을 확장해서 신규 엔티티 판단 전략을 변경할 수 있다.
	- `delete(T)`: 엔티티 하나를 삭제한다. `EntityManager.remove()`를 호출한다.
	- `findOne(ID)`: 엔티티 하나를 조회한다. `EntityManager.find()`를 호출한다.
	- `getOne(ID)`: 엔티티를 프록시로 조회한다. `EntityManager.getReference()`를 호출한다.
	- `findAll(...)`: 모든 엔티티를 조회한다. 정렬이나 페이징 조건ㅇ르 파라미터로 제공할 수 있다.

## 쿼리 메소드 기능

- 스프링 데이터 JPA가 제공하는 쿼리 메소드 기능 3가지
	- 메소드 이름으로 쿼리 생성
	- 메소드 이름으로 JPA NamedQuery 호출
	- `@Qeury` 어노테이션을 사용해서 리포지토리 인터페이스에 쿼리 직접 정의

### 메소드 이름으로 쿼리 생성

- 참고: https://docs.spring.io/spring-data/jpa/reference/jpa/query-methods.html

### JPA NamedQuery

- 메소드 이름으로 JPA Named 쿼리를 호출하는 기능을 제공한다.
- ![](assets/Pasted%20image%2020250225220020.png)
- ![](assets/Pasted%20image%2020250225220034.png)
- 스프링 데이터 JPA는 선언한 "도메인 클래스 + .(점) + 메소드 이름"으로 Named 쿼리를 찾아서 실행한다.
- 메소드 파라미터에 `@Param`을 사용했는데 이것은 이름기반 파라미터 바인딩할 때 사용하는 어노테이션이다.

### @Query, 리포지토리 메소드에 쿼리 정의

- `@Query` 어노테이션을 사용해서 실행할 메소드에 정적 쿼리를 작성할 수 있다.
- JPA Named 쿼리처럼 애플리케이션 실행 시점에 문법 오류를 발견할 수 있는 장점이 있다.
- ![](assets/Pasted%20image%2020250225220313.png)
- `@Query` 어노테이션에 `nativeQuery = true`를 설정하면 네이티브 SQL을 작성할 수 있다.
	- ![](assets/Pasted%20image%2020250225220236.png)

### 파라미터 바인딩

- 스프링 데이터 JPA는 위치 기반 파라미터 바인딩과 이름 기반 파라미터 바인딩을 모두 지원한다.
	- ![](assets/Pasted%20image%2020250225220934.png)
- 기본값은 위치 기반인데 파라미터 순서로 바인딩한다.
- 이름 기반 파라미터 바인딩을 사용하려면 `@Param(파라미터 이름)` 어노테이션을 사용하면 된다.
- 코드 가독성과 유지보수를 위해 이름 기반 파라미터 바인딩을 사용하자.

### 벌크성 수정 쿼리

- 스프링 데이터 JPA에서 벌크성 수정, 삭제 쿼리는 `@Modifying` 어노테이션을 사용하면된다.
- 벌크성 쿼리를 실행하고 나서 영속성 컨텍스트를 초기화하고 싶으면 `@Modifying(clearAutomatically = true)` 처럼 옵션을 설정하면 된다.(기본값은 false)
- ![](assets/Pasted%20image%2020250225223150.png)

### 반환 타입 

- 스프링 데이터 JPA는 유연한 반환 타입을 지원하는데 결과가 한 건 이상이면 컬렉션 인터페이스를 사용하고, 단건이면 반환 타입을 지정한다.
- ![](assets/Pasted%20image%2020250225223627.png)
- 만약 조회 결과가 없으면 컬렉션은 빈 컬렉션을 반환하고 단건은 null을 반환한다.
- 단건을 기대하고 반환 타입ㅇ르 지정했는데 결과가 2건 이상 조회되면 `NonUniqueResultException` 예외가 발생한다.

### 페이징과 정렬

- 스프링 데이터 JPA는 쿼리 메소드에 페이징과 정렬 기능을 사용할 수 있도록 2가지 특별한 파라미터를 제공한다.
	- `Sort`: 정렬 기능
	- `Pageable`: 페이징 기능(내부에 `Sort` 포함)
- 파라미터에 `Pageable`을 사용하면 반환 타입으로 `List`나 `Page`를 사용할 수 있다.
	- `Page`를 사용하면 스프링 데이터 JPA는 페이징 기능을 제공하기 위해 검색된 전체 데이터 건수를 조회하는 count 쿼리를 추ㅏㄱ로 호출한다.
	- ![](assets/Pasted%20image%2020250225224429.png)
- 참고로 페이지는 0부터 시작한다.
- ![](assets/Pasted%20image%2020250225224501.png)
- ![](assets/Pasted%20image%2020250225224640.png)

### 힌트

- JPA 쿼리 힌트를 사용하려면 `@QueryHints` 어노테이션을 사용하면 된다.
- 참고로 이것은 SQL 힌트가 아니라 JPA 구현체에게 제공하는 힌트다.
- ![](assets/Pasted%20image%2020250225224904.png)

### Lock

- 쿼리 시 락을 걸려면 `@Lock` 어노테이션을 사용하면 된다.
- ![](assets/Pasted%20image%2020250225224929.png)

## 명세

- 책 도메인 주도 설계는 명세라는 개념을 소개하는데, 스프링 데이터 JPA는 JPA Criteria로 이 개념을 사용할 수 있도록 지원한다.
- 명세를 이해하기 위한 핵심 단어는 술어인데 이것은 단순히 참이나 거짓으로 평가된다.
- 스프링 데이터 JPA는 `Specification` 클래스로 정의했다.
	- `Specification`은 컴포지트 패턴으로 구성되어 있어서 여러 `Specfication`을 조합할 수 잇다.
- 명세 기능을 사용하려면 리포지토리에서 `JpaSpecificationExecutor` 인터페이스를 상속받으면 된다.
	- ![](assets/Pasted%20image%2020250225225522.png)
- 명세를 사용하는 코드
	- `where()`, `and()`, `or()`, `not()` 메소드를 제공한다.
	- ![](assets/Pasted%20image%2020250225225540.png)
- 명세를 정의하는 코드
	- 며엣를 정의할 때는 `toPredicate()` 메소드만 구현하면 되는데 JPA Criteria의 `Root`, `CriteriaQuery`, `CriteriaBuilder` 클래스가 모두 파라미터로 주어진다.
	- ![](assets/Pasted%20image%2020250225225615.png)

## 사용자 정의 리포지토리 구현

- 스프링 데이터 JPA는 필요한 메소드만 직접 구현할 수 있는 방법을 제공한다.
- 먼저 직접 구현할 메소드를 위한 사용자 정의 인터페이스를 작성해야 한다.
	- ![](assets/Pasted%20image%2020250225230252.png)
- 다음으로 사용자 정의 인터페이스를 구현한 클래슬르 작성해야한다. 
	- 이때 클래스 이름을 짓는 규칙이 있는데 리포지토리 인터페이스 이름 + `Impl`로 지어야 한다.
	- ![](assets/Pasted%20image%2020250225230402.png)
- 마지막으로 리포지토리 인터페이스 사용자 정의 인터페이스를 상속받으면 된다.
	- ![](assets/Pasted%20image%2020250225230432.png)
- 만약 사용자 정의 구현 클래스 이름 끝에 Impl 대신 다른 이름ㅇ르 붙이고 싶으면 `repositoryImplementationPostfix` 속성을 변경하면 된다.
	- ![](assets/Pasted%20image%2020250225230510.png)

## Web 확장

- 스프링 데이터 프로젝트는 스프링 MVC에서 사용할 수 있는 편리한 기능을 제공한다.

### 설정

- 스프링 데이터가 제공하는 Web 확장 기능을 활성화하려면 `@EnablespringDatanebsupport`어노테이션을 사용하면 된다.
- ![](assets/Pasted%20image%2020250225232826.png)

### 도메인 클래스 컨버터 기능 

- 도메인 클래스 컨버터는 HTTP 파라미터로 넘어온 엔티티의 아이디로 엔티티 객체를 찾아서 바인딩해준다.
	- ![](assets/Pasted%20image%2020250225232903.png)
- OSIV를 사용하지 않으면 조회한 엔티티는 준영속 상태로, 엔티티를 컨트롤러에서 수정해도 실제 데이터베이스에는 반영되지 않는다.

### 페이징과 정렬 기능

- 스프링 데이터가 제공ㄹ하는 페이징과 정렬 기능을 스프링 MV에서 편리하게 사용할 수 있도록 `HandlerMethodArgumentResolver`를 제공한다.
	- 페이징 기능: `PageableHandlerMethodArgumentResolver`
	- 정렬 기능: `SortHandlerMethodArgumentReesovler`
- ![](assets/Pasted%20image%2020250225233231.png)
- `Pageable`은 `PageRequest`의 인터페이스다.
	- page: 현재 페이지, 0부터 시작
	- size: 한 페이지에 노출할 데이터 건수
	- sort: 정렬 조건
	- 예: ![](assets/Pasted%20image%2020250225233345.png)
- 사용해야 할 페이징 정보가 둘 잇아이면 접두사를 사용해서 구분할 수 있다.
	- ![](assets/Pasted%20image%2020250225233420.png)
- `Pageable`의 기본값은 page=0, size=20이다.
	- 만약 기본값을 변경하고 싶으면 `@PageableDefault` 어노테이션을 사용하면 된다.
	- ![](assets/Pasted%20image%2020250225233557.png)

## 스프링 데이터 JPA가 사용하는 구현체

- 스프링 데이터 JPA가 제공하는 공통 인터페이스는 `SimpleJpaRepository` 클래스가 구현한다.
- ![](assets/Pasted%20image%2020250225233954.png)
- 새로운 엔티티를 판단하는 기본 전략은 엔티티의 식별자로 판단하는데 식별자가 객체일 때 null, 자바 기본 타입일 때 0 값이면 새로운 엔티티로 판단한다.
	- 필요하면 엔티티에 `Persistable` 인터페이스를 구현해서 판단 로직을 변경할 수 있다.
	- ![](assets/Pasted%20image%2020250225234117.png)

## 스프링 데이터 JPA와 QueryDSL 통합

### QueryDslPredicateExecutor 사용

- 리포지토리에서 `QueryDslPredicateExecutor`를 상속받으면 된다.
- ![](assets/Pasted%20image%2020250225234552.png)
- ![](assets/Pasted%20image%2020250225234557.png)
- ![](assets/Pasted%20image%2020250225234603.png)
- `QueryDslPredicateExecutor`는 join, fetch 등 사용할 수 있는 기능에 한계가 있다. 따라서 QueryDSL이 제공하는 다양한 기능을 사용하려면 `JPAQuery`를 직접 사용하거나 스프링 데이터 JPA가 제공하는 `QueryDslRepositorySupport`를 사용해야 한다.

### QueryDslRepositorySupport 사용

- `QueryDslRepositorySupport`를 상속받아 사용하면 조금 더 편리하게 QueryDSL을 사용할 수 있다.
- 커스텀 리포지토리를 만들어서 `QueryDslRepositorySupport`를 상속받는다.
	- ![](assets/Pasted%20image%2020250225235115.png)
	- ![](assets/Pasted%20image%2020250225235108.png)
- 아래는 `QueryDslRepositorySupport`의 핵심 기능만 간추려보았다.
	- ![](assets/Pasted%20image%2020250225235155.png)
