---
title: Liveness, Readiness, Startup Probe
tags:
  - Kubernetes
---
## 목표

- Liveness probe, Readiness probe, Startup probe의 차이점을 이해한다.

## Liveness probe

- 컨테이너를 재시작 해야되는지 판단할 때 사용한다.
- liveness probe에 반복해서 실패하면, 컨테이너가 재시작된다.
- 반복해서 실행되므로 liveness probe에는 무거운 작업을 하면 안된다.
- liveness probe는 readiness probe가 성공하는 것을 기다리지 않고 실행된다.
	- 만약 liveness probe가 실행되기 전에 지연이 필요하면, startup probe를 사용하거나 `initialDelaySeconds` 값을 설정함녀 된다.
- 예시: 애플리케이션이 데드락에 빠졌으면 이를 탐지하여 재시작한다.

## Readiness probe

- 컨테이너가 트래픽을 받을 수 있는 상태인지 판단할 때 사용한다.
- readiness probe가 실패하면, 서비스 엔드포인트에서 해당 pod와 연결을 제거한다.
	- liveness probe와 달리 다시 시작되지는 않는다.
- 반복해서 실행되므로 readiness probe는 무거운 작업을 하면 안된다.
- 예시: 다른 서비스(DB 등)에 대한 연결이 실패하여 파드가 일시적으로 서비스를 제공할 수 없고 나중에 복구되는 경우, 이를 탐지하여 트래픽 전송을 일시 중지한다.

## Startup probe

- 애플리케이션이 성공적으로 시작되었는지를 판단할 때 사용한다.
- 이를 통해 느리게 시작하는 컨테이너에 대해서 kubelet이 오탐하여 종료되어 버리는 것을 방지할 수 있다.
- 애플리케이션이 시작될 때 한 번만 동작한다.
- startup probe가 성공하면 즉시 파드로 트래픽을 보내기 시작한다.
- 예시: 애플리케이션 실행 성공 확인, 애플리케이션 warmup 작업

## 참고 자료

- https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/
- https://stackoverflow.com/questions/65858309/why-do-i-need-3-different-kind-of-probes-in-kubernetes-startupprobe-readinessp
