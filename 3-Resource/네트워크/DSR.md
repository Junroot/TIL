---
tags:
  - 네트워크
---
# DSR

## 목표

- DSR(Direct Server Return)이 무엇인지 이해한다.
- L3DSR이 무엇인지 이해한다.

## DSR

- DSR: 로드 밸런서로부터 분산된 트래픽의 응답을 다시 로드밸런서로 보내지 않고, 클라이언트에 직접 보내는 기법.

### DSR을 사용하기 전의 로드밸런싱 과정

1. 클라이언트가 로드밸런서의 VIP를 통해, 로드밸런서로 패킷이 보내진다.
2. 로드밸런서는 트래픽 분산을 위해 서버를 하나 선택해서 패킷을 다시 전송한다.
3. 서버는 응답을 로드밸런서로 보낸다.
4. 로드밸런서가 클라이언트에게 응답을 보낸다.

![](assets/Pasted%20image%2020230706142339.png)

### DSR을 사용한 로드밸런싱 과정

- 서버의 응답이 로드밸런서가 아닌 클라이언트로 직접 보낸다.

![](assets/Pasted%20image%2020230706142617.png)
![](assets/Pasted%20image%2020230706143028.png)

### 장점

- 일반적인 서비스에서는 요청에비해 응답의 크기가 훨씬 크다. 
	- 특히 넷플릭스나 유튜브 같은 서비스는 더욱더 클것이다.
- 기존 방식을 사용할 경우 로드밸런서에 과부하가 발생할 수 있다.
- 응답을 서버에서 클라이언트로 직접 보내면서 로드밸런서의 병목 현상을 피할 수 있다.

## L2DSR/L3DSR

- 클라이언트의 Request를 서버로 전달함에 있어서 어떤 헤더를 이용하는지에 따라 L2/L3 DSR로 구분하게 된다.

### L2DSR

- Inbound 패킷의 destination MAC을 바꾸는 기법이다.
- 로드밸런서에서 패킷의 destination MAC 주소를 서버의 MAC 주소로 변환한 후 서버에게 전달한다.
- MAC 주소 변환을 통해 패킷을 전달하기 때문에, 로드밸런서와 서버들은 같은 네트워크에 속해 있어야한다.

![](assets/Pasted%20image%2020230706143832.png)

### L3DSR

- L2DSR이 같은 네트워크에 속해야 한다는 한계점을 극복하기 위해 나온 기법
- Inbound 패킷의 destination IP를 바꾸는 기법이다.
- 서버에서는 로드밸런서의 VIP 정보를 알 수 있는 방법이 2가지 있다.
	- SDCP 필드를 사용하는 방식
	- Inbound Packet을 터널링하는 방식
- DSCP 필드를 사용하는 방식
	- 로드밸런서와 서버는 DSCP/VIP 매핑 테이블을 알고 있다.
	- 서버는 들어온 요청의 DSCP 값을 확인해서, 응답의 source IP를 설정한다.
	- ![](assets/Pasted%20image%2020230706150622.png)
- Inbound Packet을 터널링하는 방식
	- 터널링: 두 점 간의 통신이 되도록 하위 계층의 통신 규약의 패킷을 상위 계층 통신 규약으로 캡슐화해서 수신자 이외에는 알아볼 수 없도록 전송하는 기술
	- 로드 밸런서와 서버는 Tunnel/VIP 매핑 테이블을 갖는다. 
	- 이 매핑 테이블을 바탕으로 Source IP를 설정한다.
	- ![](assets/Pasted%20image%2020230706150835.png)

## 참고 자료

- https://dev.to/kcdchennai/direct-server-return-with-kubernetes-454l
- https://www.haproxy.com/blog/layer-4-load-balancing-direct-server-return-mode
- http://www.redisgate.com/redis/network/load_balancing.php
- https://itpenote.tistory.com/489