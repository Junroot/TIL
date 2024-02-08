# Nginx에서 URS1 signal을 받으면 발생하는 일

## 배경

- 배포 스크립트를 읽어보는 중 `` kill -USR1 `cat {nginx pid 파일 경로}` `` 라는 내용이 있었다.
- 해당 명령의 의미를 이해해본다.

## signal 종류

- `kill` 명령어를 통해서 특정 프로세스에 signal을 보낼 수 있다.
- 그 중 `SIGUSR1`, `SIGUSR2`는 커스터마이징이 가능한 signal이다.
	- 참고: https://man7.org/linux/man-pages/man7/signal.7.html

## pid 파일

- nginx는 자신의 pid(프로세스 id)를 파일 형태로 저장해둔다.
	- http://nginx.org/en/docs/ngx_core_module.html#pid
- 따라서 위 명령어는 nginx 프로세스에 SIGUSR1 signal을 보내는 것이다.

## Nginx가 SIGUSR1 signal을 받은 경우

- Nginx에서는 각 signal에 따른 동작이 미리 정의되어 있다.
	- http://nginx.org/en/docs/control.html

| signal    | 동작                                                                                                                                                                                        |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TERM, INT | fast shutdown                                                                                                                                                                               |
| QUIT      | graceful shutdown                                                                                                                                                                           |
| HUP       | changing configuration, keeping up with a changed time zone (only for FreeBSD and Linux), starting new worker processes with a new configuration, graceful shutdown of old worker processes |
| USR1      | re-opening log files                                                                                                                                                                        |
| USR2      | upgrading an executable file                                                                                                                                                                |
| WINCH     | graceful shutdown of worker processes                                                                                                                                                       |

- 따라서 위 명령어는 Nginx에서 logging 파일을 reopen 하는 과정이다.
