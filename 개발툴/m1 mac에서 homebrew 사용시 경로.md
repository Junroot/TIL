# M1 mac에서 homebrew 사용시 경로

## 배경

- homebrew를 사용해서 Apache를 설치했는데 예상한 위치에 설치되지 않았다.

## Intel 사용시 경로 vs M1 사용시 경로

- intel의 경우에는 기본 경로가 `/usr/local/bin/brew` 이다.

- m1의 경우에는 기본 경로가 `/opt/homebrew/bin` 이다.

- `which brew` 명령을 통해서 현재 brew가 설치되어 있는 위치가 어디인지 파악할 수 있다.

  ![image-20221206193435556](assets/image-20221206193435556.png)

## 참고 자료

- https://earthly.dev/blog/homebrew-on-m1/