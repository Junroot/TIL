# Factory Bean

## 상황

- 코드에서 `FactoryBean`이라는 인터페이스를 빈으로 등록하는 부분이 있었는데, 어떤 용도인지 궁금했다.

## Factory Bean의 역할

- 다른 Bean을 생성하고 Spring IoC 컨테이너에 등록하는 Bean이다. 
- 사용 예시
  - `JndiObjectFactoryBean`: JNDI에서 데이터 소스를 조회하는데 사용
  - `ProxyFactoryBean`: AOP를 사용하여 bean에 대한 프록시를 생성하는데 사용

## Factory Bean 생성하는 방법

1. `FactoryBean` 인터페이스의 구현체를 빈으로 등록한다.
2. `AbstractFactoryBean`을 확장한다. 이 추상 클래스는 `getObjectType()`과 `createInstance()` 메서드만 구현하면된다. 해당 추상 클래스에서는 싱글톤 패턴을 사용하고 있어 쉽게 싱글톤으로 빈을 관리할 수 있게해준다.

## 참고 자료

- https://www.geeksforgeeks.org/spring-factorybean/