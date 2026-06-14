---
tags:
  - Spring-Framework
title: "@ApplicationModuleListener"
---
- `@ApplicationModuleListener`: 모듈 간 통합을 이벤트로 느슨하게 연결할 때 쓰는 이벤트 리스너 선언 단축 표기.
	- Spring Framework 기본 기능이 아니라 **Spring Modulith** 프로젝트가 제공하는 애노테이션이다.
	- 모듈러 모놀리식에서 한 모듈이 다른 모듈을 직접 호출하지 않고, 도메인 이벤트를 발행해 후속 처리를 위임하는 패턴을 위한 것.

## 세 애노테이션의 합성

- 이 애노테이션은 세 가지를 한 번에 붙인 메타 애노테이션이다.
	- `@Async` — 발행 측과 다른 스레드에서 비동기로 실행한다.
	- `@Transactional(propagation = REQUIRES_NEW)` — 리스너 자신의 새 트랜잭션에서 실행한다.
	- `@TransactionalEventListener` — 이벤트를 발행한 트랜잭션이 커밋된 뒤 호출된다(기본 phase가 `AFTER_COMMIT`).

```kotlin
// 단축 표기
@Component
class InventoryManagement {
	@ApplicationModuleListener
	fun on(event: OrderCompleted) { /* … */ }
}

// 위와 동일한 의미
@Component
class InventoryManagement {
	@Async
	@Transactional(propagation = Propagation.REQUIRES_NEW)
	@TransactionalEventListener
	fun on(event: OrderCompleted) { /* … */ }
}
```

- 각 애노테이션이 붙는 이유:
	- `@TransactionalEventListener`의 기본 phase가 `AFTER_COMMIT`이라, 발행 측 트랜잭션이 커밋에 성공해야만 리스너가 돈다. 발행 측이 롤백되면 리스너는 실행되지 않는다.
	- `@Async`로 발행 측 스레드와 분리해, 리스너가 오래 걸려도 발행 측 응답을 막지 않는다.
	- `AFTER_COMMIT` 시점엔 원래 트랜잭션이 이미 끝나 있으므로, 리스너에서 DB 쓰기를 하려면 새 트랜잭션이 필요하다. 그래서 `REQUIRES_NEW`.
- 발행 측은 그냥 `ApplicationEventPublisher`로 이벤트를 던지면 된다.

```kotlin
@Service
class OrderManagement(val events: ApplicationEventPublisher) {
	@Transactional
	fun complete(order: Order) {
		// 주문 애그리거트 상태 전이
		events.publishEvent(OrderCompleted(order.id))
	}
}
```

## 단순 @Async + @TransactionalEventListener의 함정

- 메타 애노테이션을 풀어 쓴 것만으로는 한 가지 문제가 남는다: **이벤트 유실**.
- `@Async` + `@TransactionalEventListener` 조합에서, 원 트랜잭션은 이미 커밋됐는데 리스너가 예외로 실패하면 그 이벤트는 그냥 사라진다.
	- 발행 측은 이미 커밋·성공 응답을 끝냈으므로 되돌릴 방법이 없다.
	- 동기 리스너였다면 예외가 호출 흐름에 전파되지만, `@Async`라 별도 스레드에서 조용히 죽는다.
- `@ApplicationModuleListener`가 단순 조합과 결정적으로 다른 점은, Spring Modulith의 **이벤트 발행 레지스트리**와 함께 동작해 이 유실을 막는다는 것이다.

## 이벤트 발행 레지스트리 (Event Publication Registry)

- 동작 순서:
	1. 이벤트가 발행되면, Spring Modulith가 **발행 기록을 DB에 먼저 저장(INSERT)한다**.
	2. 이 INSERT는 발행 측(원래) 트랜잭션 안에서 일어나므로, 비즈니스 상태 변경과 원자적으로 커밋된다.
	3. 커밋 후 리스너가 호출되고, **정상 종료하면 해당 기록을 완료(completed)로 표시**한다.
	4. 리스너가 실패하면 기록이 **미완료(incomplete) 상태로 남는다** → 유실되지 않고 추적·재처리 가능.
- 트랜잭셔널 아웃박스(transactional outbox)와 같은 발상이다. "상태 변경과 이벤트 기록을 한 트랜잭션에 묶고, 전달은 나중에 보장한다."

### DB에 어떻게 저장되나

- 저장 위치는 영속 기술에 따라 다르다. JDBC면 `EVENT_PUBLICATION` 테이블, JPA면 대응 엔티티, MongoDB면 컬렉션. 아래는 JDBC 기준 표준 스키마(MySQL)다.

```sql
CREATE TABLE IF NOT EXISTS EVENT_PUBLICATION (
  ID                     VARCHAR(36)   NOT NULL,   -- 발행 기록 식별자(UUID)
  LISTENER_ID            VARCHAR(512)  NOT NULL,   -- 대상 리스너 식별자
  EVENT_TYPE             VARCHAR(512)  NOT NULL,   -- 이벤트 클래스 FQCN
  SERIALIZED_EVENT       VARCHAR(4000) NOT NULL,   -- 직렬화된 이벤트 본문
  PUBLICATION_DATE       TIMESTAMP(6)  NOT NULL,   -- 발행 시각
  COMPLETION_DATE        TIMESTAMP(6)  DEFAULT NULL, -- 완료 시각(미완료면 NULL)
  STATUS                 VARCHAR(20),              -- 상태(PUBLISHED/COMPLETED 등)
  COMPLETION_ATTEMPTS    INT,                      -- 처리 시도 횟수
  LAST_RESUBMISSION_DATE TIMESTAMP(6)  DEFAULT NULL, -- 마지막 재제출 시각
  PRIMARY KEY (ID),
  INDEX EVENT_PUBLICATION_BY_COMPLETION_DATE_IDX (COMPLETION_DATE)
);
```

- 핵심: **이벤트 1건을 발행한다고 row가 1건 생기는 게 아니다.** 그 이벤트를 받는 트랜잭셔널 리스너(`@ApplicationModuleListener` 등) **하나당 row 하나**가 생긴다.
	- 같은 이벤트를 리스너 3개가 듣고 있으면 `LISTENER_ID`만 다른 row 3건이 INSERT된다.
	- 완료/미완료는 (이벤트 × 리스너) 단위로 독립 추적된다. 리스너 A는 성공하고 B만 실패하면 B의 row만 미완료로 남는다.
- `SERIALIZED_EVENT`에는 이벤트 객체가 직렬화돼 들어간다(기본 Jackson JSON).
	- 그래서 이벤트는 직렬화 가능해야 한다. 재발행 시 이 컬럼을 역직렬화해 이벤트를 복원하므로, 클래스 구조가 바뀌면 과거 기록을 못 읽을 수 있다(역직렬화 호환성 주의).
- 리스너가 성공하면 완료 처리 모드에 따라 이 row가 바뀐다: `UPDATE`면 `COMPLETION_DATE`를 채우고, `DELETE`면 row를 지우고, `ARCHIVE`면 아카이브 테이블로 옮긴다.

## 미완료 이벤트 재발행

- 애플리케이션이 리스너 실행 중 죽거나 리스너가 예외로 끝나면 미완료 row(`COMPLETION_DATE`가 NULL)가 남는다.
- 재시작 시 자동 재발행: `spring.modulith.events.republish-outstanding-events-on-restart=true` (기본 `false`).
- **여기서 "재발행(republish)"은 DB에 이벤트를 다시 기록(INSERT)한다는 뜻이 아니다.**
	- 이미 저장돼 있는 미완료 row를 읽어, `SERIALIZED_EVENT`를 역직렬화해 이벤트 객체를 복원하고, `LISTENER_ID`가 가리키는 **바로 그 리스너를 다시 호출**하는 것이다.
	- row는 새로 생기지 않는다. 같은 row를 재사용하며 `COMPLETION_ATTEMPTS`(시도 횟수)가 늘고, 이번에 성공하면 그 row가 완료 처리된다.
	- 즉 "재발행"의 대상은 DB 기록이 아니라 **리스너로의 전달(재호출)**이다.
- 런타임 수동 재처리: `IncompleteEventPublications` 빈을 주입해 미완료 발행을 다시 제출할 수 있다(역시 기존 row 기반 재호출).
- 결과적으로 전달 보장 수준은 **at-least-once**다. 리스너는 같은 이벤트를 두 번 받을 수 있으므로 멱등하게 짜야 한다.

## 완료 처리 모드 (Completion Mode)

- 리스너 성공 시 발행 기록을 어떻게 처리할지 `spring.modulith.events.completion-mode`로 정한다. 값 3가지:

| 모드 | 동작 |
|---|---|
| `UPDATE` (기본) | 완료 시각 컬럼을 채워 완료 표시. 기록은 테이블에 그대로 남는다. |
| `DELETE` | 완료된 기록을 삭제한다. |
| `ARCHIVE` | 완료된 기록을 별도 아카이브 테이블로 옮긴다. |

- 기본 `UPDATE`는 기록이 계속 누적되므로 주기적 정리가 필요하다.
	- `CompletedEventPublications` 빈으로 정리한다: `deletePublicationsOlderThan(Duration)`(나이 기준), `deletePublications(Predicate)`(조건 기준).

## 영속화 스타터와 스키마

- 레지스트리는 영속 저장소가 있어야 동작한다. 영속 기술별 스타터를 골라 의존성에 추가한다.
	- `spring-modulith-starter-jpa`, `spring-modulith-starter-jdbc`, `spring-modulith-starter-mongodb`, `spring-modulith-starter-neo4j`.
	- 스타터가 직렬화·레지스트리 인프라를 자동 구성한다.
- JDBC/JPA는 이벤트 발행 테이블 스키마가 필요하다.
	- `spring.modulith.events.jdbc-schema-initialization.enabled=true`로 자동 생성하거나, DB별 제공 스키마(MySQL·PostgreSQL 등)를 직접 적용한다.

## 이벤트 외부화 (externalization)

- 같은 레지스트리 기반으로, 발행한 이벤트를 Kafka·RabbitMQ 같은 외부 브로커로 내보내는 기능도 있다.
- 외부화 역시 트랜잭셔널 이벤트 리스너로 구현돼, 브로커 전송이 실패하면 미완료 기록을 통해 재시도할 수 있다.

## 정리

- `@TransactionalEventListener(phase = AFTER_COMMIT)`만 쓰던 코드(애그리거트에서 이벤트를 모아 커밋 후 동기 처리)와 비교하면, `@ApplicationModuleListener`는 **비동기 + 새 트랜잭션 + 발행 레지스트리 기반 유실 방지**까지 한 애노테이션으로 묶어 준다.
- 모듈 간 통신을 이벤트로 분리하면서도, "발행 측이 커밋했는데 후속 처리가 유실되는" 문제를 막아야 할 때 적합하다.
- 단, 동작 전제로 비동기 처리가 활성화돼 있어야 하고(`@EnableAsync` 등), 리스너는 재전달을 견디도록 멱등하게 작성해야 한다.

## 참고 자료

- https://docs.spring.io/spring-modulith/reference/events.html
