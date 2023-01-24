# Github의 GPG key가 무엇인가?

## 목표

- GPG가 무엇인지 알아본다.
- Github의 verified commit이 무엇인지 알아본다.
- Github에서 GPG key가 무엇인지 알아본다.

## GPG란

GPG는 GNU Privacy Guard의 약자로, 파일을 암호화하여 전송할 수 있는 툴이다. GPG는 여러가지 암호화 기술을 제공하지만 기본적으로 RSA 암호화를 사용한다.

## Github에서 verified commit이 무엇인가?

레포지토리에 커밋을 push할 때, 마치 다른 사람이 커밋한 것처럼 위조할 수 있는 문제점이 있다.

```bash
git config --global user.name junroot
git config --global user.email junroot0909@gmail.com
```

위의 명령어로 현재 커밋하는 사람의 이름과 이메일만 바꾼다면 쉽게 위조가 가능하다. push 할 때 Github 계정에 로그인이 필요하지 않냐고 하지만, Github에 push 권한의 인증만하지 커밋 단위로 인증하지는 않는다. (확인 필요)

이로 인해 악의적으로 다른 사람이 나쁜 코드를 삽입한 것처럼 커밋 내역을 조작할 수 있다.

## GPG key를 이용한 변조 문제 해결

Github에서는 GPG key를 이용해서, 커밋 단위로 committer를 검증한다. 이를 통해 committer 변조 문제를 해결할 수 있다. GPG key 등록 방법은 아래 링크를 참고한다.

[https://www.44bits.io/ko/post/add-signing-key-to-git-commit-by-gpg#gpggnu-privacy-guard란](https://www.44bits.io/ko/post/add-signing-key-to-git-commit-by-gpg#gpggnu-privacy-guard%EB%9E%80)

## 참고 자료

[https://www.44bits.io/ko/post/add-signing-key-to-git-commit-by-gpg#gpggnu-privacy-guard란](https://www.44bits.io/ko/post/add-signing-key-to-git-commit-by-gpg#gpggnu-privacy-guard%EB%9E%80)

[https://blog.iswan.kr/technical/create-gpg-signature/](https://blog.iswan.kr/technical/create-gpg-signature/)