---
tags:
  - 알고리즘
title: Sqrt Decomposition
---


## 문제 상황

- 처음에 segment tree를 이용해, 배열에 공통적인 변화량을 기록했다.
- 하지만, 이후에 주어진 범위 내에서 최대 값을 구해야되는 문제가 나왔다. 범위 내의 최대값을 구하기 위해서는 결국 segment tree의 모든 leef node를 탐색해야되므로 O(n)이 걸린다.

## 해결 방법

- 배열을 n개의 그룹으로 나누어서 공통적인 변화량을 기록한다.
- 배열의 크기는 n^(0.5)가 된다.
- 이렇게 하면 값을 수정할 때도 O(n^(0.5)) 가 걸리고, 최대값을 구할 때도 O(n^(0.5))의 시간 복잡도로 탐색을 하게된다.

## 참고 자료

[https://kesakiyo.tistory.com/22](https://kesakiyo.tistory.com/22)
