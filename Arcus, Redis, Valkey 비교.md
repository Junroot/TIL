---
tags:
  - Redis
title: Arcus, Redis, Valkey 비교
---
- 셋 다 인메모리 캐시 솔루션이지만, 관계를 이해하려면 먼저 `memcached`와 `Redis`의 차이를 알아야 한다.
	- `Arcus`는 memcached 포크이고, `Valkey`는 Redis 포크다.
	- 즉 **Arcus vs Redis/Valkey는 memcached 계열 vs Redis 계열의 차이, Redis vs Valkey는 라이선스의 차이**로 정리된다.

![](assets/Pasted%20image%2020260610155924.png)

## memcached vs Redis

- 두 솔루션의 출발점이자, 나머지 비교의 토대다.

### 자료구조

- memcached: 값을 plain string으로만 저장하는 단순 key-value 저장소.
	- 키는 최대 250 byte, 값은 기본 1MB로 제한된다.
- Redis: string 외에 `hash`, `list`, `set`, `sorted set`, `stream`, bit array, hyperloglog 등 풍부한 자료구조를 지원한다.
	- 키/문자열 값은 최대 512MB. 리더보드 같은 복잡한 use case를 자료구조만으로 구현할 수 있다.
- 제자리(in-place) 수정: Redis는 값의 일부를 직접 수정할 수 있지만, memcached는 값을 통째로 교체해야 한다.

### 영속화(persistence)

- Redis: 디스크 영속화를 지원한다. 스냅샷(RDB), Append-only file(AOF), 둘을 섞은 하이브리드 방식이 있어 서버 재시작/장애 후 데이터를 복구할 수 있다.
- memcached: 디스크 영속화를 네이티브로 지원하지 않는다. 재시작하면 데이터가 사라진다.

### 스레드 모델

- memcached: 멀티스레드. 여러 CPU 코어를 활용하므로 컴퓨팅 용량을 키우면(scale up) 처리량이 늘어난다.
- Redis: 명령 실행은 싱글스레드(event loop)다. 단, 이벤트 기반 I/O로 다수의 동시 연결을 효율적으로 처리한다.
	- 명령이 순차 실행되므로 원자성 보장이 단순하다는 장점도 있다.

### 복제·고가용성

- Redis: 복제를 네이티브로 지원한다(master → replica). 읽기 분산과 클러스터 가용성을 얻을 수 있다.
- memcached: 네이티브 복제가 없다. 고가용성·이중화는 애플리케이션 레벨이나 별도 도구로 처리해야 한다.

### eviction(축출 정책)

- memcached: LRU(Least Recently Used) 한 가지만 사용한다.
- Redis: No Eviction(메모리가 차면 더 받지 않음), Volatile TTL(TTL 설정된 키 우선 제거) 등 여러 정책 중 선택할 수 있다.

### 부가 기능

- Pub/Sub: Redis는 패턴 매칭 기반 pub/sub 메시징을 지원한다(채팅·실시간 피드 등). memcached는 없다.
- 트랜잭션/스크립팅: Redis는 트랜잭션과 트랜잭셔널 Lua 스크립트로 원자적 연산을 지원한다. memcached는 둘 다 없다.
- 파티셔닝: 둘 다 여러 노드로의 데이터 파티셔닝(수평 확장)은 지원한다.

### 정리: 언제 무엇을

- memcached: 빠르고 메모리 효율적이며 설정이 단순한, 비영속 key-value 캐싱이 목적이고 신뢰할 수 있는 내부 네트워크 환경일 때.
- Redis: 풍부한 자료구조·스트림 처리가 필요하거나, 값을 제자리 수정해야 하거나, 커스텀 eviction 정책이 필요하거나, 디스크 영속화(백업·warm restart)가 필요할 때.

## memcached vs Arcus

- Arcus는 NAVER가 memcached를 포크해 자사 서비스 요구사항에 맞게 개조한 캐시 클라우드다.
- 핵심 차이는 두 갈래다: **(1) 컬렉션 자료구조, (2) ZooKeeper 기반 캐시 클라우드(노드 자동 관리·failover).** memcached의 두 한계(string만 저장, 클러스터/자동 failover 부재)를 각각 보완한다. 데이터 복제(replication)는 이와 별개 기능이다(아래 참조).

### 컬렉션 자료구조

- memcached: 값을 plain string으로만 저장한다. 한 키 = 한 값.
- Arcus: 한 키의 값으로 컬렉션을 가질 수 있다. 별도 직렬화 없이 구조화된 다중 값을 저장·조작한다.
	- `List`: 이중 연결 리스트. FIFO 큐처럼 동작.
	- `Set`: 중복 없는 비정렬 집합. 멤버십 확인(예: 친구 목록)에 유용.
	- `Map`: `<field, value>` 쌍의 비정렬 집합.
	- `B+tree`: 정렬된 map. 각 요소는 `<bkey(b+tree key), [eflag,] data>`로 구성되며 bkey 기준 정렬을 유지한다.
		- 단건 조회뿐 아니라 bkey **범위 조회**가 가능하고, eflag로 **필터링**할 수 있다.

### 요소(element) 단위 연산

- memcached: 값을 통째로 get/set한다. 일부만 바꾸려면 전체를 읽어와 수정 후 다시 저장해야 한다.
- Arcus: 컬렉션의 개별 요소를 직접 삽입/삭제/조회한다. 큰 컬렉션에서 일부만 다룰 때 네트워크·직렬화 비용을 아낀다.
- 컬렉션 단위 속성도 둔다: `expiretime`(만료), `maxcount`(최대 요소 수), `overflowaction`(요소 초과 시 동작).

### 캐시 클라우드 & 복제 (ZooKeeper)

- memcached: 네이티브 복제·클러스터 관리·자동 failover가 없다. 노드 목록과 장애 처리는 클라이언트나 외부 도구의 몫이다.
- Arcus는 둘 다 제공하지만, **캐시 클라우드 관리와 복제는 별개 메커니즘**이다.

**(1) 캐시 클라우드 관리** — 가용성 유지(데이터 복제는 아님)

- ZooKeeper로 다수의 memcached 노드를 하나의 캐시 클라우드로 묶는다.
	- 노드는 기동 시 ZooKeeper에 접속해 자신의 service code를 찾고, cache list에 자신을 등록한다.
	- ZooKeeper가 주기적으로 노드 생존을 확인해 장애 노드를 자동 감지·제외하고, 갱신된 cache list를 클라이언트에 통지한다.
	- 노드를 무중단(on the fly)으로 추가할 수 있고, 키가 자동 재분배(rehashing)되어 로드 밸런싱이 유지된다.
	- 클라이언트는 최신 cache list로 consistent hashing해 키별 노드를 결정한다.
- 주의: 복제 없는 기본 구성에서는 노드가 죽으면 그 노드의 데이터가 **유실**된다. 서비스는 계속되지만(cache miss → DB refill) 데이터가 보존되는 것은 아니다.

**(2) 복제(replication)** — 데이터 이중화로 무손실 failover

- 공식 문서(JaM2in) 기준 Arcus는 복제를 제공한다: *"Master-Slave 구성의 semi-sync 방식 복제 기능을 제공합니다. Master 캐시 노드에 장애가 발생 시 slave 노드를 master 노드로 자동 승격시켜주는 기능을 제공합니다."*
	- Master-Slave **semi-sync** 복제 + master 장애 시 slave 자동 승격(switchover)으로 데이터 유실 없이 failover한다.
- OSS arcus-java-client도 복제를 지원한다: ChangeLog `1.9.4`(2016) "Support replication. It can co-work with replication enabled cache cluster" 이후 replica group 확장·switchover·slave 쓰기 차단(`1.15.0`)·replica 읽기 분산(`1.16.0`, 2026)으로 확장.

![](assets/Pasted%20image%2020260610155941.png)

### memcached와 그대로인 것

- memcached 계열이므로 멀티스레드이고, 디스크 영속화는 기본 제공하지 않는다(휘발성).
- memcached ASCII 텍스트 프로토콜 기반에 명령을 확장(예: `scrub`)한 형태다.
- 라이선스: Apache 2.0(완전 오픈소스). 공식 클라이언트: Java, C/C++.

## Redis 라이선스 변경과 Valkey

- Valkey는 Redis 라이선스 변경에 반발해 갈라져 나온 Redis 7.2.4의 오픈소스 포크다.
- 발단:
	- 2024년 3월, Redis Inc.가 기존 `BSD 3-Clause`에서 source-available 라이선스(`RSALv2` / `SSPLv1`)로 전환했다.
	- 목적은 AWS 같은 클라우드 사업자가 기여 없이 Redis를 상업 서비스로 파는 것을 막는 것.
	- 이후 Redis 8부터는 오픈소스 옵션으로 `AGPLv3`도 추가했다.
- 이에 반발해 Linux Foundation 주도(AWS, Google, Oracle, Ericsson 등 참여)로 Valkey가 만들어졌다.
	- 라이선스: `BSD 3-Clause`. 사용·수정·배포에 제약이 없는 완전 오픈소스.
	- Redis 7.2 명령어셋과 완전 호환된다. (기능·성능·거버넌스 등 현재 차이는 아래 "Redis vs Valkey" 참조)
- 결과 — 클라우드 사업자가 갈렸다: RSALv2·SSPL은 클라우드의 무단 매니지드 Redis 제공을 막는 게 목적이다(RSALv2는 매니지드 서비스 제공 금지, SSPL은 관리 계층 소스 공개 강제). Redis 소스로 서비스하려면 Redis Ltd.와 상용 계약이 필요하다.
	- AWS·GCP: Valkey로 전환. AWS는 2024.10 ElastiCache·MemoryDB에 Valkey를 추가하고 신규 기본·권장 엔진으로 삼음(Redis 대비 약 20% 저렴).
	- Azure: Redis Inc.와의 상용 계약으로 Redis를 유지(Azure Cache for Redis).
	- 역설적으로, 무임승차를 막으려던 라이선스 변경이 Valkey라는 오픈소스 경쟁자를 만들어냈다.

![](assets/Pasted%20image%2020260610155956.png)

## Redis vs Valkey

- 코드 베이스는 Redis 7.2.4에서 갈라진 형제지만, 릴리스를 거듭하며 차이가 벌어지고 있다. Valkey 측은 "이 시점부터 Redis와 Valkey는 서로 다른 소프트웨어"라고 못박았다.

### 라이선스 · 거버넌스 (핵심 차이)

- Redis: `RSALv2` / `SSPLv1` / `AGPLv3` **3중 라이선스**(Redis 8~). Redis Ltd. **단일 벤더**가 주도하며, AGPLv3를 영구 오픈소스 옵션으로 유지하겠다고 밝혔다.
	- AGPLv3는 수정해서 네트워크 서비스로 제공하면 소스 공개 의무(network copyleft)가 따른다.
- Valkey: `BSD 3-Clause` 단일 퍼미시브 라이선스. Linux Foundation의 **다중 벤더 거버넌스**라 특정 벤더가 단독으로 라이선스를 바꿀 수 없다.
- (라이선스 변경 경위는 위 "Redis 라이선스 변경과 Valkey" 참조)

### 기능: 코어 통합(Redis) vs 가벼운 코어 + 모듈(Valkey)

- Redis 8은 과거 별도 모듈이던 기능을 **코어에 네이티브 통합**한다.
	- JSON, Time Series, 확률적 자료구조 5종(Bloom · Cuckoo · Count-Min Sketch · Top-K · t-digest), Vector Sets, 하이브리드 검색(`FT.HYBRID`), 시맨틱 캐싱(LangCache), hot key 탐지 등.
	- Redis 측은 Valkey 대비 "100개 이상 많은 명령"을 보유한다고 밝힌다.
- Valkey는 같은 계열 기능을 **별도 공식 모듈**로 제공한다(코어는 가볍게 유지).
	- `valkey-json`(JSON), `valkey-search`(벡터/검색), `valkey-bloom`(Bloom filter) 등.
- 즉 Redis는 "배터리 포함형 단일 코어", Valkey는 "가벼운 코어 + 모듈" 전략. 통합 기능 격차는 릴리스마다 벌어지고 있다.

### 성능

- Valkey는 8.0부터 **비동기 I/O 멀티스레딩**을 도입해 네트워크 읽기/쓰기를 멀티코어로 분산한다(데이터 조작은 여전히 싱글스레드).
- 성능 우열은 출처·벤치마크 조건마다 다르므로 단정하지 않는다:
	- 제3자 벤치마크: Valkey 8.1이 Redis OSS 대비 처리량 ~8%↑, P99 지연 ~22%↓, 메모리 ~20%↓라고 보고(조건별 상이).
	- Redis 발표: Redis 8.x는 7.2 대비 단일 노드 처리량 5배 이상, JSON 수치 배열 메모리 최대 92%↓ 등 향상을 주장.
	- 벡터 검색은 Redis 네이티브 Vector Sets가 valkey-search보다 QPS가 높다는 제3자 측정도 있다.

### 버전 현황(2026-06) · 호환성

- Valkey: `9.1.0`(2026-05-19)이 최신. `8.1.x`, `7.2.x` 계열도 유지된다.
- 두 프로젝트는 같은 RESP 프로토콜·코어 명령셋을 공유해 기존 클라이언트가 그대로 동작하고, 기본 캐싱 용도는 드롭인 호환에 가깝다.

## 비교 표

| 구분      | Arcus                                       | Redis                             | Valkey           |
| ------- | ------------------------------------------- | --------------------------------- | ---------------- |
| 기반      | memcached 포크                                | 독자 개발                             | Redis 7.2.4 포크   |
| 개발 주체   | NAVER                                       | Redis Ltd.                        | Linux Foundation |
| 라이선스    | Apache 2.0                                  | RSALv2/SSPLv1 + AGPLv3(8~)        | BSD 3-Clause     |
| 스레드     | 멀티스레드                                       | 싱글스레드(명령 실행)                      | 멀티스레드 I/O 강화     |
| 자료구조    | List/Set/Map/B+tree                         | string/hash/list/set/zset/stream… | Redis와 동일        |
| 클러스터 관리 | ZooKeeper                                   | Redis Cluster                     | Redis Cluster 호환 |
| 복제      | Master-Slave semi-sync + 자동 failover(공식 문서) | master→replica                    | Redis와 동일        |
| 디스크 영속화 | 미지원                                         | 지원                                | 지원               |

## 선택 기준

- memcached의 단순함·속도에 컬렉션 자료구조와 클러스터 관리가 필요하면 `Arcus`.
- 벡터 검색·JSON 등 최신 통합 기능과 풍부한 자료형이 필요하면 `Redis`.
- 라이선스 자유도(완전 오픈소스)와 Redis 호환을 중시하면 `Valkey`.

## 참고 자료

- [Redis OSS vs. Memcached (AWS)](https://aws.amazon.com/elasticache/redis-vs-memcached/)
- [Memcached vs Redis (redis.io)](https://redis.io/compare/memcached/)
- [Arcus 공식 문서 (JaM2in GitBook) — 복제 등 기능 명시](https://jam2in.gitbook.io/arcus-documentation)
- [naver/arcus (GitHub)](https://github.com/naver/arcus)
- [Arcus Wiki — 1. Overview (GitHub)](https://github.com/naver/arcus/wiki/1.-Overview)
- [naver/arcus-memcached (GitHub)](https://github.com/naver/arcus-memcached)
- [arcus-java-client ChangeLog (복제 지원 근거)](https://github.com/naver/arcus-java-client/blob/master/ChangeLog)
- [arcus-memcached ChangeLog (서버측 복제 미언급)](https://github.com/naver/arcus-memcached/blob/master/ChangeLog)
- [Valkey 공식 사이트 (valkey.io) — 버전·라이선스·기능](https://valkey.io/)
- [What is Valkey? A comparison with Redis (redis.io) — Redis 관점의 기능·라이선스 차이](https://redis.io/blog/what-is-valkey/)
- [Redis RSALv2 & SSPL 듀얼 라이선스 발표 (redis.io)](https://redis.io/blog/rsalv2-sspl-announcement/)
- [BSD 3-Clause License (opensource.org)](https://opensource.org/license/bsd-3-clause)
- [AGPLv3 (opensource.org)](https://opensource.org/license/agpl-v3)


