# LDAP 기본 개념

## Directory service

- 디렉토리: 검색 및 조회에 특화된 데이터베이스. 업데이트도 가능하다.
	- 주로, 속성(attribute)기반의 정보를 포함하고, 정교한 필터링 기능을 지원한다.
	- 대량의 복잡한 업데이트를 처리하도록 설계된 데이터베이스에서 볼 수 있는 트랜잭션과 롤백을 지원하지 않는다.
	- 대량의 조회 또는 검색 작업에 빠르게 응답하도록 설계되었다.
	- 가용성과 신뢰성을 높이고, 응답 시간을 단축하기 위해서 복제(replicate) 해두기도 한다. 데이터 복제 중에 발생하는 일시적인 데이터 불일치는 허용한다.
- 디렉토리 서비스는 여러 방법으로 제공된다.
	- 디렉토리 서비스마다 정보의 종류가 다르고 조회, 업데이트 방법 등이 다를 수 있다.
	- 일부 디렉터리 서비스는 로컬 서비스로 제공된다.
	- 일부 디렉터리 서비스는 인터넷을 통해 광범위하게 제공하는 글로벌 서비스다.
-  DNS 또한 디렉토리 서비스다.

## LDAP

### 정의

- Lightweight Directory Access Protocol
- 디렉토리 서비스(특히, X.500 기반 디렉토리 서비스)에 접근하기 위한 경량 프로토콜
- TCP/IP 프로토콜 위에서 동작한다.
- IETF 표준 프로토콜 이며 RFC4510에 명시되어 있다.
- client-server 구조로 동작한다. 

### 사용자 관점 overview

#### LDAP에 저장되는 정보

- LDAP에 저장되어 있는 정보는 엔트리(entry)를 기반으로 한 모델이다.
- 엔트리: attribute의 모음.
- attribute는 globally-unique한 DN(Distinguished Name)을 가진다.
- 각 attribute는 하나의 type과 하나 이상의 value를 가진다.
	- type은 일반적으로 줄임말이다. 아래는 예시다.
		- cn: common name
		- mail: email address
	- value의 문법은 type에 따라 정해진다.
		- cn은 "Babs Jensen" 같은 형태
		- mail은 "babs@example.com"
		- jpegPhoto는 JPEG(binary) 포맷

#### LDAP이 정보를 저장하는 방식

- 엔트리의 계층적인 트리 구조로 저장한다.
	- 각 원이 entry이다.
	- ![](assets/Pasted%20image%2020240423202611.png)
- 추가적으로 objectClass라는 특별한 attribute를 통해 entry에 허용하는 attribute와 필수 attribute를 설정할 수 있다.

#### LDAP이 정보를 참조하는 방식

- 엔트리는 DN이라는 고유 이름으로 참조된다.
- RDN(Relative Distinguished Name): entry 자신의 이름
	- 위 그림에서 가장 아래에 있는 entry의 RDN은 `uid=babs`
- DN는 RDS를 계층적으로 이어서 표현한다.
	- 위 그림에서 가장 아래에 있는 entry의 DN은 `uid=babs,ou=People,dc=example,dc=com`
- `dc=example,dc=com`의 서브트리에서 cn이 "Barbara Jensen"인 엔트리를 검색할 수도 있다.

## X.500

- 디렉토리 서비스 중 하나
- LDAP은 X.500 디렉토리 서비스에 대한 액세스 프로토콜이다.
- 초기에 LDAP 클라이언트는 X.500 디렉토리 서비스에 대한 게이트웨이에 엑세스했다.
	- LDAP 클라이언트와 게이트웨이 사이에는 LDAP을 사용하고
	- 게이트웨이와 X.500 서버 사이에는 X.500의 DAP을 사용했다.
	- DAP은 full OSI 프로토콜을 사용하는 무거운 프로토콜이다.
	- LDAP은 TCP/IP를 통해 작동하도록 설계되어서 가벼운 비용으로 DAP의 대부분의 기능을 제공한다.
- 오늘날에는 X.500 서버에 LDAP을 직접 구현하는 것이 일반적이다.
