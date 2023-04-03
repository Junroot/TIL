# LDAP 이해하기

## 목표

- LDAP이 무엇인지 이해한다.
- LDAP의 장단점을 이해한다.

## LDAP란?

- LDAP: Lightweight Directory Access Protocol
- 디렉토리에 접근하기위해 사용되는 애플리케이션 레이어의 프로토콜(디렉토리 서비스 프로토콜)
- 우리가 흔히 알고있는 디렉토리처럼 계층적 트리 구조를 가지고 있다.

![](assets/Pasted%20image%2020230403204144.png)

## LDAP vs RDBMS

- 데이터를 저장하고 조회한다는 관점에서 LDAP도 데이터베이스라고 할 수 있다.
- 우리가 가장 흔하게 사용하고 있는 관계형 데이터베이스와 차이점을 비교해보며 장단점을 파악한다.
- 읽기가 쓰기보다 훨씬 많은 경우는 LDAP이 유리하다. (1000:1 비율보다 읽기가 더 많은 경우)

| LDAP                                                                                         | RDBMS                                                                                   |
| -------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| 검색과 조회 연산에 최적화되어 있다.                                                          | 쓰기 연산에 최적화되어 있다.                                                            |
| 객체지향적, 계층적 데이터 구조를 가진다. 사용자, 컴퓨터, 공유 리소스 등의 데이터를 나타낸다. | 관계형 데이터 구조를 가진다. 하나의 테이블에 있는 데이터는 다른 체이블과 관계를 가진다. |
| 복제 및 분산 관리에 맞게 설계되어 있다.                                                      | 중앙 집중화된 저장 및 관리를 위해 설계되어 있다.                                        |
| 객체와 속성 수준까지 정확한 보안                                                             | 행, 열 수준까지의 느슨한 보안                                                           |
| 레플리카와 데이터 일관성이 느슨하다.                                                                                           |      데이터 일관성 보장. 테이블 간의 참조 무결성 및 락을 통한 동시성 제어                                                                                   |


## 참고자료

- https://docs.geoserver.org/latest/en/user/security/tutorials/ldap/index.html
- https://stackoverflow.com/questions/6880804/when-to-use-ldap-over-a-database
- https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc738377(v=ws.10)#ldap-directories-compared-to-relational-databases
- https://stackoverflow.com/questions/6880804/when-to-use-ldap-over-a-database