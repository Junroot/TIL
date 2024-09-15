---
tags:
  - Shell-Script
title: 윈도우에서 작성한 Shell script를 실행하면
---

윈도우 환경에서는 파일 마지막 줄에 `^M` 가 추가되어서 UNIX 환경과 달라 에러가 발생할 수 있다.

이를 해결하기 위해서는 vi로 열어서 

```bash
:set fileformat=unix
```

위와 같이 입력하고 파일을 닫으면 된다.

## 참고 자료

[https://stackoverflow.com/questions/2920416/configure-bin-shm-bad-interpreter](https://stackoverflow.com/questions/2920416/configure-bin-shm-bad-interpreter)
