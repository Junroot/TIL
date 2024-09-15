---
tags:
  - Spring-Batch
title: Tasklet vs Step
---


## 목표

- Spring batch의 `Tasklet`과 `Step`의 차이점을 이해한다.

## 차이점

- `Tasklet`은 Step 안의 작업의 전략을 나타내는 함수형 인터페이스다.
- Job에는 여러개의 Step이 있고, Step은 `Tasklet`을 이용해 표현할 수 있다.

## 참고 자료

- https://docs.spring.io/spring-batch/docs/current/api/org/springframework/batch/core/step/tasklet/Tasklet.html
- https://stackoverflow.com/questions/40041334/difference-between-step-tasklet-and-chunk-in-spring-batch
