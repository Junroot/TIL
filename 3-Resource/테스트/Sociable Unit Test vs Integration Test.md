---
tags:
  - 테스트
---
# Sociable Unit Test vs Integration Test

- 테스트하고자 하는 객체가 다른 객체에 의존하고 있으면 그것은 단위 테스트가 아닌가?
- Sociable Unit Test와 Integeration Test는 궁극적으로 테스트의 목표가 다르다.
- Integration Test는 2개이상의 모듈이 있을 때, 각 모듈의 정확성보다는 제대로 협력하는지를 테스트한다. 따라서 Integration Test는 모든 경우를 모두 테스트할 필요는 없다.
- Sociable Unit Test는 모든 경우의 수에 제대로 동작하는지 테스트를 한다.
- 종속되는 대상을 이미 테스트하고 있다면, 굳이 독립적인 테스트를 만들 필요가 없다. 이미 종속되는 테스트를 완료했으며, 만약 너가 TDD를 하고있다면 테스트를 실패하는 원인을 찾기 어렵다는 점도 없을 것이다.

## 참고 자료

[https://merge-conflict.com/post/sociable-unit-testing/](https://merge-conflict.com/post/sociable-unit-testing/)