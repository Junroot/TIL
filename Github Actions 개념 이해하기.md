---
tags:
  - Github
title: Github Actions 개념 이해하기
---


## 목표

- GIthub Actions를 사용하기 위한 기본 개념을 이해한다.

## 개념

![](assets/Pasted%20image%2020240202004912.png)

### Workflow

- 한 개 이상의 job이 실행되는 자동화된 과정
- `.github/workflows` 디렉토리에 yaml 파일로 정의할 수 있다.
- workflow가 다른 workflow를 참조할 수도 있다.

### Event

- workflow 실행을 트리거하는 레포지토리 내의 활동
- pull request, issue, push 등

### Job

- 같은 runner에서 실행되는 step의 집합
- job들 간에는 기본적으로 의존성이 없고 병렬로 실행된다.
- 만약 job이 다른 job에 의존성을 설정하면, 의존하는 job이 완료될 때 까지 실행을 기다린다.

### Step

- 실행될 수 있는 셸 스크립트 또는 action
- 각 step은 순차적으로 의존성을 가지고 실행된다.
- 따라서 같은 runner에서 실행되는 step은 데이터를 공유할 수 있다.

### Action

- 자주 실행되거나 복잡한 작업을 수행해주는 Github Action용 애플리케이션
- 개발자가 직접 작성하거나 Github 마켓플레이스에서 사용할 action을 찾을 수 있다.

### Runner

- workflow가 실행할 서버
- 각 runner는 한 번에 하나의 job을 실행할 수 있다.
- Github에서는 Ubuntu, Windows, macOS runner를 제공한다.
- 만약 자체 운영체제가 필요하거나 특정 하드웨어 구성이 필욯나 경우 self-hosted runner를 구성할 수 있다.

## 참고 자료

- https://docs.github.com/ko/actions/learn-github-actions/understanding-github-actions
