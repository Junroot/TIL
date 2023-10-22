## DAY 1 

### 하나의 코드로 React, Vue, Svelte 등 모든 프레임워크를 지원할 수 있는 CFCs Reactive

- Cross Framework Components(CFCs): 하나의 컴포넌트를 여러 프레임워크에 제공
- egjs: flicking, infinitegrid, view3D, View360 등 컴포넌트 제공
- 프레임워크 전용 컴포넌트가 아니라면 단순 wrapping하여 사용하여 프레임워크를 지원 (mounted)
- Compatible을 통해 하나의 공통 코드를 여러 프레임워크에 지원
- CFCs는 2가지 방법을 제공
	- DOM: DOM을 생성하거나 변경
	- Reactive: 
- CFCs DOM: 프레임워크 동작을 반하면 안되기 떄문에 Sync작업이 필요
	- view3D 등 컴포넌트마다 DOM Rendering하는 방법이 다양하여 제작 지연
- Function Component
	- React는 render 때마다 호출, Vue, Svelte은 생성될 때마다 1회 호출
	- Hooks: 인스턴스가 없기 때문에 내부 컴포넌트 정보가 존재하고 Hooks를 순서대로 추가. root부터 시작하여 하위 컴포넌트까지 호기화 및 렌더링하면서 현재 컴포넌트 정보가 변경
- Reactive Component: 특정 조건에 따라 상태 값이 변하거나 이벤트가 발생하는 컴포넌트
	- 직접 상태 변경 호출하는게 아닌 이벤트나 내부적으로 변경되는 컴포넌트로 자동 변경
	- state, mounted, unmounted, result로 구성
- CFCs Reactive
	- 상태가 변경되면 rerendering
- 모듈로써 공개하는 CFCs Reactive
	- 프레임워크가 유사한 CFCs Reactive만의 Lifecycle을 제공
	- 함수형태로 adapter 작성(이벤트, 메서드를 사용하고싶다면 함수를 통해 추라적인 정보 입력)
	- github.com/naver/cfcs

### 바닥까지 파보는! Hbase random read 성능 개선기  

- 배경
	- CUBE: Hbase 기반의 범용적인 대규모 분선 데이터 저장소
- 데이터 다양성
	- 대규모, 범용성
	- 해결방안1: 제약
	- 해결방안2: Multi-clustered storage
		- 클러스터를 구분하고 각각의 데이터에 맞게 최적화
		- 규모가 늘어날 수록 복잡도 또한 증가
	- 해결방안3: HBase 데이터 유연성 개선
	- HBase에서 random read 과정에서 client가 실제 쿼리한 data size보다 증폭된 hdfs read 요청, 그 결과로 과도한 disk IO 사용
- HBase의 read amplification 원인 분석
	- 추측1: multi file access amplification
		- memstore에 쓰기를 cache 한뒤 일정량 초과하면 flush
		- 원인이 아님
	- 추측2: Granularity Mismatch Amplification
		- request size와 I/O data size와 차이가 있어 발생하는 문제
		- 작은 크기의 data block을 사용하는 경우: random read가 빈번하게 발생. 인덱스 블록의 사이즈가 너무 커짐
- HBase 개선 방안
	- solution 1: 데이터 블록 사이즈를 동적으로 조절
		- MaxNumData: 하나의 데이터블록의 키밸류의 상한성
		- MinDataBlockSize: 데이터 블록ㅇ 사이즈의 하한선
	- solution 2: KV Cache
			- space utilization을 기반한 pot KV를 프로모팅

### Cquery: 우당탕탕 Trino와 썸타기

- Who am i
	- AIDA (Advanced Interface for Data and AI) CQuery: 네이버 서비스에서 발생하는 대용량 로그를 SQL로 조회 및 분석하는 환경을 제고아는 멀티테넌트 플랫폼 통합 분석 솔류션
- Architecture
	- Hive vs Trino
		- Trino가 SQL 쿼리 처리속도가 더 빠르다
		- Trino는 YARN overhead가 없다.

![](assets/Pasted%20image%2020230227140755.png)
![](assets/Pasted%20image%2020230227140914.png)

- Features
	- 커널, 디스크/네트워크 버퍼 등 20%
	- Thread stacks, GC, off heap 메모리등 30%
	- 쿼리 실제 처리 가용 메모리는 서버의 56%

![](assets/Pasted%20image%2020230227141138.png)

- Iceberg: 대규모 데이터 분석을 위해 Netflix에서 개발한 테이블 형식. 

### 네이버 스케일로 카프카 컨슈머 사용하기

- Kafka: 로그 자료구조를 분산 스토리지 시스템으로
	- 로그는 순서보장이 가장 큰 특징
	- 쓴 순서대로 저장, 저장된 순서대로 읽는다.
	- topic, pub/sub

![](assets/Pasted%20image%2020230227151242.png)

- Kafka Consumer
	- Topic: 1개 이상의 Partition으로 분할, 1개 이상의 Replica로 복제된 log 자료 구조
	- client
		- producer: 쓰고자 하는 Topic Partition의 맨 끝에 record를 추가. 여러 개의 파티션에 쓸 수 있음.
		- consumer: 읽어오고자 하는 Topic의 Partition에 저장된 record를 순차적으로 읽어 옴. 하나의 파티션은 하나의 consumer만 읽을 수 있음.
- Consumer Group
	- 같은 'group.id' 설정값을 가진 consumer들은 하나의 consumer group을 이룬다.]
	- 같은 consumer group에 속한 consumer들에 topic에 속한 partition들을 나눠서 읽는다.
	- consumer group == 논리적인 consumer
	- 거대한 consumer 하나가 전체 topic 내용을 읽어들이고 있는 것처럼 보인다.
- Consumer Group에 필요한 것
	- Partition Assignment 기능
	- Offset Commit 기능
- Consumer Coordination 동작 원리
	- Broker를 재시작할 필요 없이 더 유연하고 확장 가능한 파티션 할당을 지원하기 위해 아래와 같은 복잡한 구조를 가진다.

![](assets/Pasted%20image%2020230227152228.png)

- consumer coordination 관련 설정
	- max.poll.interval.ms: 가져간 메시지들을 처리하는데 사용할 수 있는 최대 시간. 이 시간을 초과하면 해당 coordinator 가 죽었다고 판단한다.
	- session.timeout.ms: 하트비트 오지 않아도 문제없는 주기. 
	- partition.assignment.strategy: 
		1. consumer group에 참여한 모든 consumer에 공통으로 설정된 assignor 중에서
		2. 우성순위가 가장 높은 것이 파티션 할당 전략으로 선택 (앞에 있는 것이 우선순위가 더 높음)

![](assets/Pasted%20image%2020230227152847.png)

- cloud 환경에서의 consumer group coordination
	- 물리적 장비의 자원을 여러 pod가 나눠서 씀
		- noisy neighbors 현상
		- network hicup
	- pod rescheduling이 일상적임
- 새 설정: `group.instance.id`
	- 정적 그룹 멤버심
	- 정상적 재시작 이전에 할당되어 있던 파티션들을 다시 할당
		- 같은 `group.instance.id` 설정을 가진 기존 컨슈머의 할당을 승계
		- rebalace가 발생하지 않음
	- 단순 pod 재시작 때문에 partition rebalance가 발생하는 사태를 방지
		- kafka streams가 내부적으로 이 설정을 사용
- 설졍 변경: `session.timeout.ms`
	- 기본값 변경
		- 3.0 이전: 10초 (10000)
		- 3.0 이후: 45초 (45000)
	- 단순 network hiccup 때문에 partition rebalnce가 발생하는 사태를 방지
		- consumer 프로세스가 죽었는지 알아차리는 데 걸리는 시간 증가
- 새 기능: follower replica로부터 읽기
	- broker.rack 설정
		- 새로 생성된 replica가 서로 다른 rack에 할당되도록 하기 위해 도입
		- “서버 랙 전체에 전력이 나가버리더라도 다수의 replica가 동시에 동작 불능에 빠지지는 않는다!”
		- 물리적 서버 시대의 유산
	- 클라우드 시대로 옮겨오면서 의미 변화
		- 물리적 서버 랙 -> 가용 영역
	- 문제: consumer와 leader replica가 서로 다른 AZ에 있으면?
		- 요금 폭탄
	- “Consumer가 위치한 AZ를 알고 있고 해당 AZ에 leader replica와 동기화된 상태를 유지하고 있는 follower replica가 있다면, 여기서 읽어올 수 있게 하자!
		- `client.rack`(consumer 설정): 클라이언트가 위치한 AZ를 정의
		- `replica.selector.class`(broker 설정): leader replica가 아니라 같은 AZ에 위치한 follower replica로 부터 읽어올 수 있도록 해주는 설정

### GraphQL 잘 쓰고 계신가요? (Production-ready GraphQL) 

- GraphQL 이란
	- 필요한 것만 요청하고 받아오기
	- 단일 요청으로 많은 데이터 가져오기
	- 가능한 케이스를 타입 시스템으로 표현하기
- Schema
	- 우리가 다룰 데이터의 모양
	- 데이터를 R/W 하는데 최족화를 목표
	- 출처가 다른 데이터들의 통합 타입 시스템
- Field Argument

![](assets/Pasted%20image%2020230227160725.png)

- Enum - 지원하느 이미지 사이즈를 타입으로

![](assets/Pasted%20image%2020230227160827.png)

- 암시적이 API Parameter
- Error Handling
	- GraphQL의 모든 상태 코드는 200
	- 메터데이터가 필요한 경우는 어떻게 관리?
	- 스키마로 관리. Union.
	- Interface로 확장에 열려있도록 구현 가능
- Custom Scalar
	- graphql-scala라는 라이브러리 제공

![](assets/Pasted%20image%2020230227161741.png)

- field resolver == getter function
	- field resolver는 rest와 다르게 필요할 때만 계산한다.
	- 매번 엔드포인트를 새로 만들 필요가 없다.
- normalization
- GraphQL&Relay


### 클라우드 환경 기반 실시간 데이터 처리의 유실 없는 Geo-Replication 구축 

![](assets/Pasted%20image%2020230227170753.png)

- IDC 장애의 심각성 그리고 Geo Replication
	- Disaster Recovery, Compliance, Data Migration, Data Distribution, Data co-location
	- Geo Replication의 구성
		- End-to-End 에 걸친 섬세한 설계가 필요
	- Geo Replication의 분류
		- performance
		- scalability
		- availabillty
- Message Queue in Geo Replication
	- Out-of-the-box feature
	- Synchronous & Asynchronous Replication
	- Visible/Mesurable Metric

	- Kafka Stretch Cluster: Synchronouse Replication
	- Kafka MirrorMaker: Asynchronous Replication on kafka

	- Pulsar GEO replication
	- pulsar vs kafka

![](assets/Pasted%20image%2020230227171636.png)

- Realtime Data Processing in Geo Replication
- Cloud Friendliness in Geo Replication

## DAY 2 

### 자바스크립트 화이트박스 암호와  크롬 라인 메신저의 보안 강화 



### 웨일 브라우저 오픈 소스 생존기

- 브라우저 오픈 소스 전성시대
	- 브라우저는 웹 플랫폼이다
	- 웹은 크로스 혹은 유니버설 플랫폼이다
	- 웹은 빠르게 발전하는 플랫폼이다
	- 브라우저 개발을 위해 필요한 고려 사항: 웹표준, 성능, 보안
	- 브라우저 개발 시 웹플랫폼의 발전 속도가 빨라서 오픈 소스를 사용하게 되었다
- 웨일 브라우저와 크로미움
	- 크로미움 구조와 소스 트리
		- chrome: UI 담당
		- content: 웹 엔진
	- 크로미움을 사용하는 3가지 방식
		- 시스템 소프트웨어(base): Android WebView Framework
		- 웹엔진(content): XWhale
		- 브라우저(chrome): Whale

![](assets/Pasted%20image%2020230228111202.png)

- 리베이스의 무게를 견뎌라
	- 리베이스: 사용중인 오픈소스의 버전을 최신 버전으로 가져오는 작업
	- 리베이스가 어려운 이유
		- 코드 사이즈: 6만개 이상
		- 멀티 플랫폼: Windows, macOS...
		- 테스트: 브라우저 기능, 웹엔진 기능
	- 생존을 위한 상시 리베이스 프로젝트를 시작
		- Time based release가 가능한 개발문화와 인프라가 갖춰져야 가능한 도전
	- 빠른 코드 리베이스를 위한 리베이스-봇 개발
		- 코드 리베이스를 잘 하기 위해서는 변경된 파일을 최소한의 컨플릭트로 반영하는 것
		- 커밋이 아닌 파일 단위로 관리 (작업 순서 관리에 유리)
		- 자주 리베이스를 할 수록 코드 컨플릭트가 드라마틱하게 줄어 듬
	- 컨플릭트 최소화를 위한 코딩 룰 적용
	- 일정 주기 배포를 위한 개발 문화의 변화: time based release 8주
		- 기능 기획/개발
		- 자동화 테스트
		- DEV 채널 도입
	- 예층 가능한 품질 확보를 위한 개발 인프라: 안정성, 성능, 메모리

![](assets/Pasted%20image%2020230228113552.png)

- 생존을 넘어서 기여하기
	- 글로버 브라우저 벤더사들은 글로벌 이슈에 관심이 많지 국내 이슈는 상대적으로 관심이 낮음.
	- 국내 보안 기능에 노력하고 있음
	- 크로미움 오픈 소스 컨트리뷰션하고 있음

### Noir: 메일검색 서버를 반의 반으로 줄여준 신규 검색엔진 제작 

- 개별 데이터 검색서비스
	- 개별 데이터 검색 서비스: 통합검색과 다르게 특정 서비스의 문서를 검색
	- 네이버메일 검색서비스는 어떻게 서빙해야 할까?
	- 단일 역색인 볼륨 방식
		- 일반적인 방법
		- 단일 역색인 볼륨으로 모든 문서 서빙
		- 문서가 많지 않으면 가능한 방식
		- 단일 역색인 볼륨의 어려움
	- 개별 역색인 구조와 메일 검색: 계정단위 역색인 볼륨 관리. 검색시 동적으로 해당 볼륨을 메모리에 올려 검색
		- 해당 사용자 문서만 검색
		- 해당 사용자 볼륨만 업데이트
		- 검색대상 문서가 물리적으로 모이므로 성능 개선
		- 단점
			- 매달 서버 증설 필요
			- 검색서버만큼 별도의 색인 서버 필요
			- 평생 검색후보가 되지 않을 문서도 색인 필요
			- 큰 볼륨 검색 시 응답 지연
			- 수많은 색인볼륨 관리 운영이슈 다수 발생
- Full scan 검색 
	- 역색인: 검색 응답속도에 최적화된 자료구조
		- 검색 응답시간은 줄지만
		- 검색전용 역색인 자료구조가 필요하고, 볼륨생성 & 신규문서 증분 비용 올라감
	- Full scan search: 문서 원본 scan 문서가 쿼리와 부분일치할 시 검색됨
		- 검색 대상 일부문서만 scan
		- 응답속도 너무 느림: IO time + CPU time
		- 문서를 압축해도 decode time이 추가됨
		- 병렬화를 통해 개선: 총 검색 시간이 C
		- 네이버메일은 평균 볼륨 크기가 작아서 Full scan 방식을 적용하기 좋은 서비스

![](assets/Pasted%20image%2020230228121202.png)

![](assets/Pasted%20image%2020230228121234.png)

- Noir(No Information Retrieval)
	- full scan 검색
	- 네이버 Noir 적용 결과: 검색서버 100대 색인서버 150대 -> 검색서버 30대 색인서버 0대
	- 역색인을 사용하지 않으니 블록 단위 압축도 가능하다.
	- 메일은 일반적으로 부분일치 검색에 요구한다.
		- 역색인 사용시 bigram분해 필요 => 볼륨크기와 장비수요가 늘어남
		- Noir의 부분일치는 자연스럽게 제공되고 직관적인 검색로직으로 CS 최소화(운영 공수 절감)

### 그 여자 APP, 그 남자 SDK: Kotlin Multiplatform 적용기

- SDK 관점에서 본 Kotiln Multiplatform
	- Kotlin Multiplatform 을 선택한 이유
		- 플랫폼의 수가 계속해서 늘어나서 멀티플랫폼을 하기로 결정
		- Android Studio 에서도 gradle 설정으로 Web 개발이 가능하다.
		- Kotlin은 Kotiln/JVM 말고도 Kotlin/JS, Kotlin/Native 등 여러가지가 있다.
		- 각 플랫폼 주력 언어로 빌드되기 때문에 유의미한 성능 저하가 없음
	- 기존 프로젝트를 멀티플랫폼으로 마이그레이션
		- 1안: 기존 프로젝트의 기능 일부를 Kotlin Multiplatform으로 전환
			- 개발 리소스가 적지만 플랫폼 별 서로 다른 설계 및 스펙으로 이를 맞추는 데에도 상당한 리소스
		- 2안: 신규 Kotlin Multiplatform 프로젝트에 기존 기능 도입
	- Kotlin에 플랫폼 코드 연동
		- Kotlin/JS: external modifier, js(), npm dependency
	- 없으면 만들어 쓴다. 자체 도구 개발
		- HLS 스트리밍 중 미디어 관련정보를 metadata로 전달
		- kotlin-stdlib는 ByteArray -> UTF-8 String 변환 기능을 제공
		- kotlinx-io는 obsolete
	- 하나의 테스트 코드만 작성하면 모든 플랫폼 간 정합성 체크
	- Kotlin/Native는 Swift가 아닌 Objective-C로 컴파일
		- sealed class는 다른 언어에서는 지원하지 않음
	- Kotlin/JS는 계층 모듈 구조가 아직 불가
	- iOS 멀티모듈 지원 이슈: B모듈의 A 클래스가 C모듈의 A 클래스가 달라지는 이슈
	- SDK에 멀티 플랫폼 도입 후
		- 더 효율적인 팀 리소스 운영
		- 더 효율적인 커뮤니케이션
- APP 관점에서 본 Kotlin Multiplatform
	- 타렛 플랫폼: 모듈 계층 구조를 결정하는 키
	- 저장소 관리
		- 모든 플랫폼의 코드를 포함하는 저장소, monorepo
		- 저장소의 크기가 커지고, 타 플랫폼 코드 수정이 가능한 문제
			- 플랫폼별로 디렉토리 분리
			- CODEOWNERS: 특정 디렉토리/파일에 대해 소유권을 부여하여 PR 강제 리뷰어 지정
			- sparse-checkout: 특정 디렉토리/파일만 체크할 수 있는 기능
	- 처음부터 코틀린 버전(/컴파일러)을 맞추고 개발을 시작해야된다.
	- JAVA 파일 변환: J2K 이용
	- UI: Compose Multiplatform

### 런타임 데드 코드 분석 도구 Scavenger 당신의 코드는 생각보다 많이 죽어있다.  

- dead code: 실행되지 않는 코드. 실행되더라도 애플리케이션 동작에 영향을 미치지 않는 코드
- dead code 발생 원인
	- API 개발 요청만 하고, 미사용 통보를 안 할 때
	- 새로운 기획 반영 후 기존 코드를 삭제 안 할 때
- dead code 문제점
	- 유지보수 하기 힘든 코드
	- 성능/보안에 악영향
	- 컴파일/테스트 속도 지연으로 개발 속도 저하
- dead code 검출 방법
	- 정적 분석 도구
	- 런타임 분석 디버깅 또는 로그를 찍어 확인
- Scavenger: 런타임 Dead code 분석 도구
	- 디버깅, 로그를 추가하지 않고 메서드 호출 확인 가능
	- 메서드 호출 기록을 수집하여 시각화해 유저에게 보여줌
	- Java agent 방식으로 손쉽게 사용 가능
- Scanverger 데모

![](assets/Pasted%20image%2020230228150928.png)

- Scanvenger 성능 오버헤드가 높지 않음
	- Java agent 실행 시 초기 1회 전체 메서드를 스캔하는데 8.7s
	- 메서드 한번 호출 시 30ns
- JVM 기반 언어(Java, Kotlin)만 지원
	- Maven central에서 다운로드 가능
- Scavenger 아키텍처

![](assets/Pasted%20image%2020230228151930.png)

- 수집하는 데이터
	- Codebase: 추적할 메서드 목록과 관련 정보, 메서드 이름, parameter/return 타입 등
	- invaocation data: 호출된 메서드 목록과 호출 시각
- `class` 파일의 바이너리 데이터를 이용해서 codebase 수집

![](assets/Pasted%20image%2020230228152609.png)

- 정적으로 파싱하는 이유: 동적으로 분석하는 경우 피분석 프로그램의 행위를 분석할 수 있기 떄문
- 메서드 호출 추적 방법: 클래스가 로드될 때 사용하는 바이트코드를 수정

![](assets/Pasted%20image%2020230228152509.png)

- Java Agent: 자바에서 프로그램에 붙어서 본 프로그램이 실행되기 전에 특정 작업을 할 수 있게 하는 자바 에이전트라는 것이 제공
	- Instrumentation.addTransformer() 를 통해 transformer를 붙일 수 있다.

![](assets/Pasted%20image%2020230228152927.png)

- 데이터의 전송, 기록, 열람
	- Agent에서는 처음 실행될 떄 codebase 정보를 1회 스캔하여 전송
	- 이후에 invocatoin 정보를 주기적으로 일정 기간의 정보를 모아 전송
	- 전송 주기를 동적으로 collector에 질의하여 설정

- Codebase Fingerprint
	- 동일한 코드가 여러 대의 서버에 배포된 경우
	- codebsae finerprint를 부여하여 같은 codebase 여부를 구분함
	- codebase에서 삭제된 메서드들은 주기적으로 가비지 콜렉팅 실시
	- 수집중인 codebase의 생성 이전에 마지막으로 발견된 메서드 삭제

### 싸늘하다, 메신저에 경보가 날아와 꽂힌다 - 네이버 검색 SRE 시스템 개선기

- 장애 발생부터 해결 과정
	1. 장애 발생 
	2. 경보
	3. 상황 인지 
	4. 원인 파악&문제 대응
	5. 장애 해결
- 기존 모니터링 시스템 구조

![](assets/Pasted%20image%2020230228160320.png)

- 기존 모니터링 시스템의 코드 구조
	- Single Point Of Failure 문제

![](assets/Pasted%20image%2020230228160359.png)

- 신규 모니터링 시스템 구조
	- 지표 수집기: 지표 라벨링 작업
	- 경보 파이프라인: 더 빠른 경보 발송
	- 시각화 컴포넌트: 시각화 실시간성 증가

![](assets/Pasted%20image%2020230228160616.png)

- 신규 모니터링 시스템을 통한 문제 해결
	- 경보 파이프라인 개선으로 경보 시간 단축
	- 시계열 DB를 활용한 지표 조회 과정 개선
- 기존 경보 파이프라인
	- 이상 징후 탐지 시간이 늦어짐

![](assets/Pasted%20image%2020230228160915.png)

- 신규 경보 시스템의 구조
	- 경보 발송까지 걸리는 시간 3분 -> 1분

![](assets/Pasted%20image%2020230228161033.png)

![](assets/Pasted%20image%2020230228161156.png)

- 모니터링 시스템의 시각화 범위
	- 저수준의 지표의 합산하여 고수준 지표 시각화 중
- 구 시스템에서의 지표 준비 과정
	- TSDB를 도입했는데 이전일아 큰 차이가 없었음

![](assets/Pasted%20image%2020230228161449.png)

