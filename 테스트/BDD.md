# BDD (Behavior Driven Development)

## 목표

- BDD가 무엇인지 이해한다.
- BDD의 장점을 이해한다.
- BDD의 활용 예(Mockito)를 알아본다.

## BDD란

### 정의

- TDD 중 하나로, TDD를 진행할 때 테스트와 관련된 용어들을 비즈니스 용어로 사용하도록 하는 기법

### 만들어진 배경

> BDD 개념을 처음 고안한 Daniel Terhorst-North의 블로그: https://dannorth.net/introducing-bdd/

- 기존에 TDD를 진행할 때, 테스트 코드의 모든 영역에 `test`라는 단어가 들어갔다.
	- class: `CustomerLookUpTest`
	- method: `testFindsCustomerById()`, `TestFailsForDuplicateCustomers()`
- 테스트 코드를 문서처럼 사용하기 위해 `test`라는 단어를 제거하고, 비즈니스 도메인의 용어를 사용하는 문장을 작성하도록 변경했다.
	- class: `CustomerLookUp`
	- method: `findsCustomerById()`, `failsForDuplicateCustomers()`
- 이 기법을 사용하다보니 아래와 같은 관습을 갖기 시작했다.
	- `The class should do something`
	- "The class" : 클래스명
	- "should do something": 메서드명
	- 이런 식으로 작성하다보니 테스트 코드를 작성할 때, 테스트를 설명하기 위해 메서드 이름이 너무 길어진다거나 문장이 어색해지는 경우에는 해당 로직이 잘못된 클래스에 존재한다는 사실도 쉽게 파악할 수 있었다.
	- 또한, 메서드 이름이 의도하고 있는 동작을 쉽게 식별할 수 있어서 테스트가 실패했을 때 원인 3가지를 분류하기가 쉬웠다.
		- 내가 버그를 만든 경우
		- 의도된 동작이 다른 클래스로 이동한 경우
		- 동작 자체가 변경된 경우
- 이후에 TDD를 진행할 때 `test`보다 `behaviour` 행동에 해당하는 단어를 사용하기 시작했고, 이를 BDD(Behaviour Driven Development) 라고 불렀다.

### 수행방법

- 모든 비즈니스 요구사항에 대해 BDD 방식으로 테스트를 진행하기 위해 아래의 템플릿으로 요구사항을 정리했다.
	- given: 이벤트 발생 전에 필요한 설정(컨텍스트)
	- when: 이벤트 발생
	- then: 이벤트가 발생했을 때 보장해야 되는 결과 
- 이 템플릿으로 정리해 놓은 요구사항들을 행동에 해당하는 단어를 사용하여 테스트 코드를 작성한다.
- 테스트가 통과하다록 구현한다.

## BDD 장점

- 어떤 클래스의 동작에 집중하도록 하면서 클래스의 역할에 집중할 수 있고, 불필요한 코드나 잘못된 위치의 코드를 방지할 수 있다.
- 개발자와 비개발자가 공통된 언어를 사용하면서 비즈니스 도메인을 좀 더 정확히 이해할 수 있다.
- 테스트 코드가 문서 역할을 할 수 있다.
- BDD를 지원해주는 툴을 사용하면 문서를 자동으로 생성할 수 있다.

## Mockito에서의 BDD

- Mockito에서도 BDD 스타일로 테스트 코드를 작성할 수 있도록 `BDDMockito` 클래스를 제공하고 있다.
- `BDDMockito`는 `Mockito`클래스를 상속하고 있다.

![](assets/Pasted%20image%2020230215183102.png)

### 기존의 Mockito

- mock을 하기 위해서 `when()`를 사용하고, assert를 위해서 `verify()`를 사용한다.
- 이는 BDD에서 given-when-then 이라는 용어와 헷갈린다.

```java
when(phoneBookRepository.contains(momContactName))
  .thenReturn(false);
 
phoneBookService.register(momContactName, momPhoneNumber);
 
verify(phoneBookRepository)
  .insert(momContactName, momPhoneNumber);
```

### BDDMockito

- mock을 하기 위해서 `given()`이라는 메소드를 사용할 수 있고, assert를 위해서 `then()`이라는 메소드를 제공하고 있다.
- BDD의 given-when-then 템플릿을 그대로 표현할 수 있다.

```java
given(phoneBookRepository.contains(momContactName))
  .willReturn(false);
 
phoneBookService.register(momContactName, momPhoneNumber);
 
then(phoneBookRepository)
  .should()
  .insert(momContactName, momPhoneNumber);
```

## 참고 자료

- https://dannorth.net/introducing-bdd/
- https://stackoverflow.com/questions/4395469/tdd-and-bdd-differences
- https://www.agilealliance.org/glossary/bdd/
- https://www.baeldung.com/bdd-mockito



