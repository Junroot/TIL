---
title: Docker Stack 알아보기
tags:
  - Docker
---
## 목표

- Docker Stack이 무엇인지 이해한다.
- Docker Stack의 사용법을 이해한다.

## Docker Stack 이란

- Docker Swarm 은 Docker 컨테이너를 클러스터링하고 스케줄링하기 위한 컨테이너 오케스트레이션 툴이다.
- Docker Stack 은 기본적으로 Docker Swarm을 통해 실행된다.
- Docker Stack을 사용하면 Swarm에 분산된 컨테이너인 여러 서비스를 논리적으로 배포하고 그룹화할 수 있다.

### vs Docker Compose

- Docker Compose는 단일 노드에서 실행되는 컨테이너를 관리하기 위한 용도이고, Docker Stack은 Docker Swarm 모드로 실행되는 멀티 노드 환경에서 컨테이너를 관리하긴 위한 용도이다.
- 공통점
	- docker-compose.yml 파일을 사용해서 컨테이너를 불러올 수 있다.
	- docker-compose.yml 파일에 지정된 대로 모든 서비스, 볼륨, 네트워크 및 기타 모든 것을 불러온다.
- 차이점
	- Docker Swarm은 build 명령을 무시한다. Docker Stack에서는 이미지를 빌드할 수는 없다.
	- 이외에도 Docker Stack에서는 사용할 수 없는 docker-compose.yml 명령어가 다수 존재한다.

## Docker Stack 명령어

- `docker stack deploy --compose-file compose.yml stackName` 으로 배포가 가능하다.
- 현재 배포된 stack은 `docker stack ls` 명령어로 확인 가능하다.
- `docker service ls`로 배포가 제대로 이루어졌는지 확인할 수 있다.
	- ![](assets/Pasted%20image%2020250131232809.png)
- `docker service scale my-stack_machine1=5`로 특정 서비스의 레플리카를 5개로 늘릴 수 있다.

## 참고 자료

- https://www.ronaldjamesgroup.com/article/docker-stack
- https://vsupalov.com/difference-docker-compose-and-docker-stack/
- https://docs.docker.com/engine/swarm/stack-deploy/
