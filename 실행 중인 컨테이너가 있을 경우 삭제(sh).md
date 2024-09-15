---
tags:
  - Docker
title: 실행 중인 컨테이너가 있을 경우 삭제(sh)
---

```xml
if [ "$(docker ps -q -f name=<name>)" ]; then
    docker stop <name>
		docker rm <name>
fi
```
