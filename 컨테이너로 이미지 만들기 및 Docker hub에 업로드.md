---
tags:
  - Docker
title: 컨테이너로 이미지 만들기 및 Docker hub에 업로드
---


## 컨테이너로 이미지 만들기

```bash
docker commit [ContainerID]
```

## 이미지에 태그 붙이기

```bash
docker tag SOURCE_IMAGE[:TAG] TARcoGET_IMAGE[:TAG]
```

## 이미지 docker hub에 업로드 및 다운로드

```bash
docker push [OPTIONS] NAME[:TAG]
```

```bash
docker pull [OPTIONS] NAME[:TAG]
```

## 참고 자료

[https://galid1.tistory.com/324](https://galid1.tistory.com/324)
