---
tags:
  - Docker
title: Dockerfile multi-stage
---


## 목표

- Dockerfile에서 multi-stage 가 무엇인지 이해한다.

## multi-stage 란

- 단일 Dockerfile에서 여러 개의 이미지를 빌드 할 수 있는 기능이다.
- Dockerfile에서 여러 개의 `FROM` 절을 사용하면 multi-stage가 된다.

```dockerfile

FROM golang:1.21
WORKDIR /src
COPY <<EOF ./main.go
package main

import "fmt"

func main() {
  fmt.Println("hello, world")
}
EOF
RUN go build -o /bin/hello ./main.go

FROM scratch
COPY --from=0 /bin/hello /bin/hello
CMD ["/bin/hello"]
```

## multi-stage 장점

- 빌드시 필요한 환경과 실행시 필요한 환경이 다를 수 있다.
- 위의 예시에서도 go를 빌드 하기위해서 `FROM golang:1.21` 를 사용했지만, 빌드된 파일을 실행할 때는 필요없다.
- 최종적인 이미지를 용량을 줄이기 위해서 스테이지를 분리할 수 있다.

## 참고 자료

- https://docs.docker.com/build/guide/multi-stage/
- https://docs.docker.com/build/building/multi-stage/
- https://kimjingo.tistory.com/63
