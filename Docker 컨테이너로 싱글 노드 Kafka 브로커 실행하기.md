---
title: Docker 컨테이너로 싱글 노드 Kafka 브로커 실행하기
tags:
  - Docker
  - Kafka
---
## 목표

- 테스트 환경에서 사용할 Kafka 브로커를 컨테이너로 실행하는 방법을 이해한다.
- Kafka 브로커는 KRaft 모드로 실행하여 ZooKeeper 없이 실행 가능하도록 구성한다.

## KRaft 모드

- KRaft 모드가 존재하기 이전에는 Kafka의 메타데이터를 관리하기 위해 Zookeeper 에 의존했다. 이는 여러 문제점이 존재했다.
	- ZooKeeper의 한계로 인해 클러스터의 확장에 한계가 존재
	- ZooKeeper 자체로도 하나의 분산 시스템이여서 Kafka를 사용하기 위해 2가지 기술의 학습 필요
- 이를 해결하기 위해서 KRaft 모드가 Apache Kafka 2.8 버전에서 처음 선보였고, 3.3 버전부터 프로덕션 환경에서 사용 가능한 것으로 발표했다.

### KRaft 모드의 구성 요소

- Controller Quorum: 메타데이터를 관리하는 전용 노드
	- 일반적으로 홀수 개로 구성한다.(보통 3개 또는 5개)
	- 메타데이터를 저장하는 리더 역할을 하는 액티브 컨트롤러와 이를 복제하는 팔로워 컨트롤러가 있다.
- Broker: 실제 메시지를 처리하는 노드
	- Controller Quorum으로부터 메타데이터를 받아와서 동작
	- Controller Quorum 역학을 하는 노드도 Broker 역할을 같이할 수 있다.

## compose.yml

- 목적을 달성하기 가장 간단한 방법은 docker compose를 사용해서 컨테이너를 구성하는 방법이다.
- 이미지: [apache/kafka](https://hub.docker.com/r/apache/kafka)
- 해당 이미지는 환경 변수를 통해 브로커 설정을 수정할 수 있다.
	- 환경 변수는 `KAFKA_`로 시작하며, 브로커 프로퍼티의 모든 점을 밑줄로 대체하면된다.
	- 예시: `num.partitions` -> `KAFKA_NUM_PARTITIONS`
- 카프카 컨테이너가 재시작 되어도 이전 메시지를 유지하기 위해서 docker volume을 생성한다.
- 각 프로퍼티 설명
	- `node.id`: 노드의 식별자
		- KRaft 모드에서는 필수 프로퍼티
		- 컨트롤러 쿼럼에서 각 노드를 식별하기 위해 사용
	- `process.roles`: KRaft 모드에서 현재 노드가 어떤 역학을 할 것 인지 나타냄
		- `broker`, `controller`, 또는 `broker, controller` 모두 설정 가능
	- `controller.quorum.voters`: 컨트롤러 쿼럼에 참여하는 노드의 목록
		- `{id}@{host}:{port}` 형식으로 나열
	- `listeners`: 브로커나 컨트롤러가 네트워크 연결을 받아들일 주소와 포트를 정의
		- `{리스너 이름}://{호스트}:{포트}` 형태로 나열
		- `CONTROLLER`: 컨트롤러 노드 간 내부 통신용
		- `PLAINTEXT`: 일반적인 클라이언트-브로커 통신용. 암호화 되지 않음.
		- `PLAINTEXT_HOST`: 사용자 정의 리스너 이름
			- 컨테이너 외부에서 브로커를 접근할 때 사용
			- `PLAINTEXT` 는 컨테이너 간 통신할 때 사용하고, `PLAINTEXT` 는 컨테이너 외부에서 접근할 떄 사용
	- `advertised.listeners`: 클라이언트에게 '나에게 연결하려면 이 주소를 사용해라'라고 알려주는 주소
		- `listeners`는 서버 입장에서 허용할 주소와 포트 정보
			- 아래 예시에서는 `kafka-broker:29092`, `kafka-broker:29093` 주소로 들어온 연결은 허용하고, 9092 포트는 모든 IP주소로 들어오는 연결을 허용한다.
		- `advertised.listeners`는 클라이언트에게 알려주는 주소
			- 현재는 테스트 환경이므로 브로커 연결시 `localhost` 로 설정하면된다.
			- 만약 외부 노드에서 연결을 가능하도록 하려면 컨테이너가 실행되는 노드의 외부 IP를 작성해줘야된다.
				- 예시: `advertised.listeners=PLAINTEXT://203.0.113.100:9092`
	- `listener.security.protocol.map`: 각 리스너에서 사용하는 보안 프로토콜 
		- `{리스너 이름}:{실제 프로토콜}` 형태로 나열
		- `PLAINTEXT`: 암호화 없는 일반 통신
		- `SSL`: TLS/SSL 암호화 적용
		- `SASL_SSL`: SASL 인증 + SSL 암호화
	- `controller.listener.names`: 컨트롤러에서 사용할 리스너
	- `inter.broker.listener.name`: 브로커 간 통신할 때 사용할 리스너
	- `offsets.topic.replication.factor`: `__consumer_offsets` 토픽의 복제 개수
		- 테스트 환경이니 복제하지 않도록 구성한다.
		- 기본값: 3
	- `transaction.state.log.replication.factor`: `__transaction_state` 토픽의 복제 개수
		- 테스트 환경이니 복제하지 않도록 구성한다.
		- 기본값: 3
	- `transaction.state.log.min.isr`: `__transaction_state` 토픽의 최소 동기화 복제본 개수
		- 테스트 환경이니 하나만 동기화 되도록 구성한다.
		- 기본값: 2
	- `min.insync.replicas`: 프로듀서가 성공적으로 썼다고 처리하기 위해서 최소 복제본 개수
		- 기본값: 1
	- `default.replication.factor`: 토픽이 자동 생성되었을 때 복제본 개수 기본 값
		- 기본값: 1
	- `group.initial.rebalance.delay.ms`: 새로운 컨슈머 그룹이 생성되 었을 때 리밸런싱이 일어나기까지 딜레이 시간.
		- 새로운 컨슈머 그룹이 생성될 때, 리밸런싱이 반복해서 발생하는 것을 방지하기 위해 사용된다.
		- 하지만 딜레이가 너무 길어지면 컨슈머가 동작 시작하기까지 시간이 늘어난다.
		- 테스트 환경에서는 빠른 컨슈머 실행을 위해 0으로 설정한다.
		- 기본값: 3000(3초)
	- `log.dirs`: 메시지들이 저장되는 디렉토리 경로

```yaml
services:
  kafka-broker:  
  image: apache/kafka:3.7.2  
  hostname: kafka-broker  
  container_name: kafka-broker  
  ports:  
    - "9092:9092"  
  environment:  
    KAFKA_NODE_ID: 1  
    KAFKA_PROCESS_ROLES: broker,controller  
    KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-broker:29093  
    KAFKA_LISTENERS: PLAINTEXT://kafka-broker:29092,CONTROLLER://kafka-broker:29093,PLAINTEXT_HOST://0.0.0.0:9092  
    KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka-broker:29092,PLAINTEXT_HOST://localhost:9092  
    KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT  
    KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER  
    KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT  
    # 싱글 브로커 설정  
    KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1  
    KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1  
    KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1  
    KAFKA_MIN_INSYNC_REPLICAS: 1  
    KAFKA_DEFAULT_REPLICATION_FACTOR: 1  
    KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0  
    KAFKA_LOG_DIRS: /var/lib/kafka/data  
    CLUSTER_ID: MkU3OEVBNTcwNTJENDM2Qk  
  volumes:  
    - kafka-data:/var/lib/kafka/data
volumes:
  kafka-data:
```

## 참고 자료

- https://developer.confluent.io/confluent-tutorials/kafka-on-docker/
- https://hub.docker.com/r/apache/kafka
- https://www.baeldung.com/ops/kafka-docker-setup
- https://levelup.gitconnected.com/kraft-kafka-cluster-with-docker-e79a97d19f2c
- https://kafka.apache.org/documentation
