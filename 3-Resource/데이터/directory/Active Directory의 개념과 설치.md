# Active Directory의 개념과 설치 

## Active Directory 란

- 규모가 있는 회사의 네트워크 상황을 Windows Server에 구현하기 위한 기술
- 네트워크 상으로 나눠져 있는 여러 자원을 중앙 관리자가 통합하여 관리하여, 본사 및 지사의 직원들은 자신의 PC에 모든 정보를 보관할 필요가 없어짐

## 용어 정리

- Directory Service: 분산된 네트워크 관련 자원 정보를 중앙 저장소에 통합시켜 놓은 환경.
- Active Directory: Directory Service를 Windows Server에서 구현한 것
- AD DS(Active Directory Domain Service): 컴퓨터, 사용자, 기타 주변 장치에 대한 정보를 네트워크 상에 저장하고 이러한 정보들을 관리자가 통합하여 관리하도록 해줌.
- 도메인(domain): Active Directory의 가장 기본이 되는 단위. 아래 그림에서 '서울 본사', '부산 지사' 등이 각각 하나의 도메인이라고 보면 된다.
- 트리(tree)와 포리스트(forest)
	- 트리는 도메인의 집합. 포리스트는 여러 개의 트리로 구성.
	- 도메인 < 트리 <= 포리스트의 관계
	- 트리가 하나 뿐이면 트리와 포리스트가 같을 수 있다.
- 사이트(site): 도메인이 논리적인 범주라면, 사이트는 물리적인 범주. 사이트는 지리적으로 떨어져 있으며, IP 주소대가 다른 묶음.
- 트러스트(trust): 도메인 또는 포리스트 사이에 신뢰할지 여부에 대한 관계를 나타낸다.
- 조직 구성 단위(Organizational Unit, OU): 한 도메인 안에 있는 세부적인 단위(예시. 부서)
- 도메인 컨트롤러(Domain Controller, DC): 로그인, 이용 권한 확인, 새로운 사용자 등록, 암호 변경 그룹 등을 처리하는 기능을 하는 서버 컴퓨터. 도메인에는 하나 이상의 DC를 설치해야된다.
	- 아래 그림에서는 '본사 서버', '부산 지사 서버', '일본 지사 서버' 등이 DC다.
- 읽기 전용 도메인 컨트롤러(Read-Only Domain Controller, RODC)
	- 주 도메인 컨트롤러로부터 데이터를 전송받아 저장한 후 사용하지만 스스로 데이터를 추가하거나 변경하지 않음
	- 소규모로 운영되어 별도의 서버 관리자를 두기 어려울 경우 유용
	- 아래 그림에서 일본 사무실의 규모가 작아서 서버 관리자를 두기 어려운 경우, 본사 서버(주 도메인 컨트롤러)로부터 데이터를 전송 받아 사용
- 글로벌 카탈로그(Global Catalog, GC): 트러스트 내의 도메인들에 포함된 개체에 대한 정보를 수집하여 저장되는 저장소

![](assets/Pasted%20image%2020240503181146.png)

## Active Directory 도메인 서비스 구현

![](assets/Pasted%20image%2020240503182549.png)


https://www.youtube.com/watch?v=Crms6s8hwoo
## 참고 자료 

- https://www.youtube.com/watch?v=6tc-WOZTmpU