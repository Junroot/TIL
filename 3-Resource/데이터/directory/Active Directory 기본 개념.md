# Active Directory 기본 개념

## AD DS 정의

- Active Directory Domain Services
- 사용자 계정, 컴퓨터 계정 및 그룹과 같은 domain object의 중앙 저장소.
- 계층적인 디렉토리에 대한 검색을 지원한다.
- 기업 내에 있는 object에 대한 구성 및 보안 설정을 적용할 수 있는 방법을 제공한다.

### 논리적인 구성요소

| 구성요소        | 설명                                                                                                                                                                                                            |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| partition   | naming context라고도 부른다. 데이터베이스는 `Ntds.dit`이라는 하나의 파일로 구성되지만 각 파티션이 각 데이터를 분리해서 가지고 있다. 예를들어, schema partition은 Active Directory 스키마를 가지고 있고, configuration partition은 forest에 대한 configuration object를 가지고 있다. |
| schema      | AD DS에서 만들어지는 object를 정의하는데 사용하는 object type 과 attribute에 대한 정의의 집함                                                                                                                                           |
| domain      | 사용자 컴퓨터와 같은 object를 위한 관리용 컨테이너. 도메인은 특정 파티션에 매핑되며 다른 도메인과 상하 관계로 구성할 수 있다.                                                                                                                                   |
| domain tree | 인접한 DNS와 common root domain를 공유하는 도메인들의 계층적인 모음                                                                                                                                                               |
| forest      | common AD DS root, common schema, common global catalog를 가진 하나이상의 도메인들의 모음                                                                                                                                    |
| OU          | 사용자, 그룹, 컴퓨터를 위한 컨테이너 object. GPO(Group Policy Object)들을 연결하여 관리 권한을 위임하고 관리할 수 있는 프레임워크를 제공한다.                                                                                                               |
| container   | AD DS에서 사용할 수 있는 조직 프레임워크를 제공하는 object. 디폴트 컨테이너를 사용하거나 사용자 지정 커넽이너를 만들 수 있다. GPO를 컨테이너에 연결할 수 없다.                                                                                                            |

### 물리적인 구성요소

| 구성요소                               | 설명                                                                                                                                                                                             |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| domain controller                  | AD DS 데이터베이스의 복사본이 포함되어 있다. 대부분의 작업에서 각 컨트롤러는 변경 사항을 처리하고 변경 사항을 도메인의 다른 모든 도메인 컨트롤러에 복제할 수 있다.                                                                                                |
| data store                         | data store의 복사본은 각 도메인 컨트롤러에 존재한다.                                                                                                                                                             |
| global catalog server              | 글로벌 카탈로그는 여러 도메인 forest에 있는 모든 object의 부분적인 읽기 전용 복사본이다. 이런 글로벌 카탈로그를 호스팅하는 domain controller이다. global catalog를 사용하면 forest의 다른 도메인에 있는 domain controller에 저장되어 있을 수 있는 object를 빠르게 겁색할 수 있다. |
| read-only domain controller (RODC) | 읽기 전용 domain controller                                                                                                                                                                        |
| site                               | 물리적인 위치에 특정 컴퓨터나 서비스와 같은 object를 위한 컨테이너이다. 이는 사용자, 그룹, 컴퓨터 같은 객체의 논리적인 구조를 나타내는 도메인과 비교된다.                                                                                                    |
| subnet                             | 컴퓨터에 할당된 조직의 네트워크 iP 주소 중 일부. site에는 서브넷이 2개 이상 있을 수 있다.                                                                                                                                       |

## 유저, 그룹, 컴퓨터 정의하기

- https://learn.microsoft.com/en-us/training/modules/introduction-to-ad-ds/3-define-users-groups-computers
