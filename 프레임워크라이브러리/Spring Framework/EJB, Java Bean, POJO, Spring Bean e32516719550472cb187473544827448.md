# EJB, Java Bean, POJO, Spring Bean

- EJB(Enterprise JavaBeans): J2EE(Java EE)가 자바 웹 애플리케이션 시장을 차지하고 있을 때, 사용되었던 애플리케이션측의 컴포넌트 모델. 여기에는 Session Bean, Entity Bean, Message-driven Bean 등이 있다. 하지만 이는 객체지향적이지 못하고 특정 환경/기술에 종속적이라는 단점이 있다.
- Java Bean: J2EE(Java EE)에서는 데이터를 표현하기 위해서 어떤 규약을 지켜야했다. 이 규약을 Java Bean이라고 부른다.
- POJO: 위의 EJB의 단점을 지적하여 일반 자바 객체로 비즈니스 로직을 구현하자는 주장이 만들어졌다(마틴 파울러). 이 때 이 자바 객체를 POJO라고 부른다.
- Spring Bean: 컨테이너에 의해서 생명주기가 관리되는 객체로 이 때 객체를 POJO 형식을 따르고 있다.