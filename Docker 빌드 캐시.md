---
title: Docker 빌드 캐시
tags:
  - Docker
---
## 목표

- Docker 빌드 시 캐시가 사용되는 방법을 이해한다.

## 레이어 

- Docker가 빌드될 때 캐시가 동작하는 방법을 이해하기 전에 먼저 Docker 이미지의 레이어가 무엇인지 이해해야 된다.
- 하나의 이미지는 여러 개의 레이어로 구성된다.
- 각 레이어는 Dockerfile에 있는 각 명령어의 빌드 결과다.
- 각 레이어는 이전 레이어과의 차이값을 나타내고 있다.
- 아래 Dockerfile이 있으면 그림과 같이 각 명령어의 결과가 하나의 레이어가 된다고 볼 수 있다.

```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN apt-get update && apt-get install -y build-essentials
COPY main.c Makefile /src/
WORKDIR /src/
RUN make build
```

![](assets/Pasted%20image%2020250121192643.png)

## 빌드 캐시의 작동 방식 

- 빌드가 시작되면 빌더가 각 명령어에 캐시된 레이어가 있는지 비교하고, 히트된 캐시 레이어가 있으면 이를 재사용한다.
- 캐시 레이어가 히트 되는지는 명령어 종류에 따라 다르다.
	- `ADD`, `COPY`, `--mount=type=bind` 옵션이 있는 `RUN`
		- 사용하는 파일의 메타데이터에서 캐시 체크섬을 계산해서 캐시가 유효한지 확인한다.
		- 파일의 수정 시간은 체크섬에 포함되지 않는다.
	- 그 외의 경우
		- 명령어 문자열이 변하지 않으면 히트된다.
		- 예) `RUN apt-get -y update` 명령을 처리할 때 컨테이너에 업데이트 파일이 있는지 상관없이, 명령어 문자열은 변하지 않았으므로 캐시 레이어를 재사용한다.
- 캐시를 사용하지 않고 싶다면, `docker builder prune`을 상요해서 캐시를 지우거나, `--no-cache` 또는 `--no-cache-filter` 옵션으로 캐시를 사용하지 않도록 한다.
- 이전 레이어에서 캐시가 히트되지 않는다면 가 이후의 레이어에도 캐시가 무효화되어 모두 다시 실행하게 된다.
	- ![](assets/Pasted%20image%2020250121193822.png)

## 참고 자료

- https://docs.docker.com/build/cache/
- https://docs.docker.com/build/cache/invalidation/
