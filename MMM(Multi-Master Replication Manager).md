---
tags:
  - MySQL
---
# MMM(Multi-Master Replication Manager)

## 목표

- MMM이 무엇인지 이해한다.
- MMM의 동작 과정을 이해한다.

## MMM

- MMM은 MySQL에서 failover 및 모니터링을 수행해주는 스크립트다.

## MMM 구조

- monitor-agent 통신 방식
- monitor: MMM 내에 있는 DB 노드들을 모니터링하고 관리한다.
- agent: MMM 내의 DB 노드들에 설치해서 monitor에 의해 관리된다.
	- agent는 monitor에 의해 읽기, 쓰기 모드가 관리된다.

### 기본 구성

- 2개의 마스터가 존재한다.
	- active master: read, write 가능
	- standby master: read만 가능
- active master와 standby master가 양방향 복제된다.
- ![](assets/Pasted%20image%2020231213134239.png)

### slave 추가 구조

- active master로부터 단방향 복제된다.
- slave 또한 monitor에 의해 읽기 모드로 제한된다.
- ![](assets/Pasted%20image%2020231213140928.png)

## failover 과정

![](assets/Pasted%20image%2020231213144909.png)

1. active master의 역할을 뺏는다.
	1. active master의 데이터가 더이상 변경되지 않도록 읽기모드로 변경
	2. active master에 붙어있던 session을 모두 kill
	3. 신규 session이 들어오지 않도록 VIP 회수
2. standby master로 복제 재구성한다.
	1. standby master나 slave 중에 복제지연이 있는지 확인
	2. 복제지연이 해소되거나 없는 경우 standby master 기준으로 복제 재구성
3. standby master를 신규 master로 승격시키는 작업을 한다.
	1. standby master의 읽기 모드를 해제
	2. 신규 session이 들어오도록 VIP 할당
4. failover 완료

### failover에서 복제가 깨지는 경우

- MMM 구조에서 미약하지면 복제 crash가 발생할 가능성이 존재한다.
- 아래 그림과 같이 active master에서 새로운 데이터가 들어오고 slave에만 복제가 된 상태에서, failover가 일어나면 복제 crash 발생한다.
	- standby master가 active로 승격되고 새로운 데이터가 들어가면 복제로 인해 다시 slave에 데이터가 들어가게된다.
	- slave는 해당 데이터를 이미 추가했기 때문에 중복 키 오류가 발생할 가능성이 있다.
- ![](assets/Pasted%20image%2020231213145338.png)
- ![](assets/Pasted%20image%2020231213145350.png)

## MySQL의 자동-failover

- MMM은 위 예시와 같은 crash가 발생할 가능성도 있고, 오래된 툴이어서 최근에는 사용되지 않는 것으로 보인다.
- MHA, ProxySQL, Galera Cluster 복제와 failover를 위한 다양한 방식을 제공하고 있다.

## 참고 자료

- https://velog.io/@claraqn/%ED%8C%80%EB%82%B4-DB-%EC%9A%B4%EC%98%81-%EA%B5%AC%EC%84%B1%EB%8F%84-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0-funvlz8f#22-mysql-replication-%EC%9D%B4%EC%A4%91%ED%99%94
- https://bcho.tistory.com/1062
- https://sungwookkang.com/entry/ProxySQL-%EC%9D%B4%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80