---
tags:
  - Java
---
# PriorityQueue에 이미 추가된 객체의 값을 수정하면?

## 결론부터

- 생각해보면 당연하지만 코딩테스트 문제를 풀다가 실수한 내용이라 기록해본다.
- 이미 PriorityQueue에 추가된 값을 수정해도, 자동으로 heapify가 진행되지 않는다.

## 어떻게 해결했는가

PriorityQueue에 있는 값을 계속해서 수정해야 되는 경우가 있어서 soft delete 방법을 응용해서 해결했다.

1. 값을 수정해야 되는 객체를 soft delete 시킨다.
2. 해당 객체에서 값을 수정한 결과를 새로 인스턴스로 만들어 PriorityQueue에 추가한다.
3. PriorityQueue에서 pop했을 때, deleted된 객체는 무시해버린다.

## 참고 자료

[https://stackoverflow.com/questions/1871253/updating-java-priorityqueue-when-its-elements-change-priority](https://stackoverflow.com/questions/1871253/updating-java-priorityqueue-when-its-elements-change-priority)