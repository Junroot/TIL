---
tags:
  - Shell-Script
---
# SSH 접근을 위한 public/private key 생성하기

`ssh-keygen` 이라는 명령어를 통해서 생성할 수 있다.

```bash
ssh-keygen
```

위와 같이 아무를 옵션없이 키 쌍을 생성하면, `~/.ssh/id_rsa.pub` 라는 파일에 생성된다. -t 옵셩능 사용하여 알고리즘과 크의 크기를 지정할 수도 있다.

```bash
ssh-keygen -t rsa -b 4096
```

해당 키를 사용할 서버의 `~/.ssh/authorized_keys`에 퍼블릭 키를 추가하면 된다.

## 참고 자료

[https://m.blog.naver.com/sehyunfa/221737099486](https://m.blog.naver.com/sehyunfa/221737099486)