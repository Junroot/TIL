---
tags:
  - Shell-Script
title: logrotate의 config 파일이 root 소유자가 아니면 실패하는 이슈
---


## 발생한 문제

- logrotate 명령어 수행시 `error: Ignoring {config 파일 경로} because the file owner is wrong (should be root or user with uid 0).` 가 발생함
- 이전 서버 환경에서는 이런 문제가 없었는데 신규 서버에서 발생함

## 원인 

- logrotate 3.8.0 부터 root 권한으로 logrotate 실행 시, config 파일의 파일 소유자가 root 인지 검증한다.
- 이전 서버에서는 3.8.0 보다 낮은 버전이어서 문제가 되지 않았다.
	- https://github.com/logrotate/logrotate/blob/master/ChangeLog.md
	- https://github.com/logrotate/logrotate/compare/r3-7-9...r3-8-0
	- ![](assets/Pasted%20image%2020230703190631.png)

## 참고 자료

- https://superuser.com/questions/793013/logrotate-no-longer-reads-symlinked-configuration-file-due-to-non-root-ownership
