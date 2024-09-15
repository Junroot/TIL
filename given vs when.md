---
tags:
  - Mockito
title: given vs when
---


## 목표

- mockito의 given과 when 함수의 차이점을 이해한다.

## Mockito vs. BDDMockito

- 기본적으로 `given`과 `when`함수의 동작은 같다. 둘 다 특정 객체를 목킹하여 함수의 동작을 정의할 때 사용할 수 있다.
- `given`은 `when`을 BDD 스타일로 작성할 수 있도록 만든 함수다.
- `given`은 `BDDMockito`에 정의되어있고, `when`은 `Mockito`에 정의되어 있다.
	- `BDDMockito`는 `Mockito` 를 상속한 클래스다.

![](assets/Pasted%20image%2020230213162950.png)

## BDD(Behavior Driven Development)

- TDD의 한 종류로 시나리오를 기반으로 테스트 케이스를 작성하여, 개발자가 아닌 사람이 봐도 이해할 수 있을 정도의 테스트 코드를 작성하는 것이다.
- 비즈니스 중심 관점을 통해 팀은 유지 관리가 쉽고, 비개발자를 포함한 모든 팀원들이 사용할 수 있는 문서를 만들 수 있다.
- 기본적으로 given-when-then 구조를 사용한다.
	- given: 시나리오를 진행하기 전에 필요한 설정
	- when: 시나리오가 진행되는 조건
	- then: 시나리오를 완료했을 때 보장해야 되는 결과

## 참고 자료

- https://www.baeldung.com/bdd-mockito
- https://velog.io/@lxxjn0/Mockito%EC%99%80-BDDMockito%EB%8A%94-%EB%AD%90%EA%B0%80-%EB%8B%A4%EB%A5%BC%EA%B9%8C
- https://www.popit.kr/bdd-behaviour-driven-development%EC%97%90-%EB%8C%80%ED%95%9C-%EA%B0%84%EB%9E%B5%ED%95%9C-%EC%A0%95%EB%A6%AC/
- https://www.tricentis.com/blog/bdd-behavior-driven-development
