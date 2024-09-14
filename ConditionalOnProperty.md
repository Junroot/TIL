---
tags:
  - Spring-Framework
---
# @ConditionalOnProperty

## 배경

- `@ConditionalOnProeprty`라는 어노테이션을 코드에서 봤는데 동작 방식을 분명하게 이해하지 못 하고 있었다.

## 목적

- configuration property의 값에따라 조건부로 빈을 생성할 때 사용할 수 있다.
- 클래스 위나 메서드 위에 붙일 수 있다.

## 각 필드 설명

- `prefix`: 공통적으로 사용되는 property의 prefix
- `name`: property의 이름
- `value`: `name`과 같다.
- `havingValue`: property의 값. 만약 명시하지 않거나 빈 값이면, property의 값이 `false`만 아니면 된다.
- `matchIfMissing`: property가 존재하지 않으면 match되는지 여부의 설정.

## 참고 자료

- https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/condition/ConditionalOnProperty.html

