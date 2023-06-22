# logrotate

## 목적

- Linux에 존재하는 로그 로테이팅 명령어다.
- `logrotate` 는 로그 로테이트 과정을 관리하는데 사용되고, `cron`을 통해서 보통 실행한다.

## logrotate 실행에 필요한 파일

- `/usr/sbin/logrotate`: `logrotate` 명령어(실행 파일)
- `/etc/cron.daily/logrotate`: anacron을 이용해 매일 실행할 `logrotate`
- `/etc/logrotate.conf`: 로그 로테이트 설정 파일

## conf 파일

- 아래와 같이 로테이트 할 로그 파일 경로와 설정을 명시한다.
	- 정규식을 이용한 표현도 가능하다.

```
/var/log/mail.info
/var/log/mail.warn
/var/log/mail.err
/var/log/mail.log
/var/log/daemon.log
/var/log/kern.log
/var/log/auth.log
/var/log/user.log
/var/log/lpr.log
/var/log/cron.log
/var/log/debug
/var/log/messages
{
        rotate 4
        weekly
        missingok
        notifempty
        compress
        delaycompress
        sharedscripts
        postrotate
                invoke-rc.d rsyslog rotate > /dev/null
        endscript
}
```

- 각 설정의 의미
	- weekly: 일주일에 한 번 로테이트
	- missingok: 로테이트 대상 파일이 존재하지 않아도 무시
	- rotate \#: 로테이트할 때 남겨둘 파일의 수. 위의 예시에서 로그 로테이트가 발생할 때 4주 전의 파일들은 삭제된다.
	- compress: gzip 압축
	- delaycompress: 두 번째 파일이 될 때까지 압축 지연
	- compresscmd: 어떤 커맨드로 압축할 건지 명시(기본값: gzip)
	- notifempty: 빈 파일은 rotate 금지
	- create 640 adm: 새로운 로그 파일을 생성할 때 설정할 permissions/owner/group
	- postrotate: 로테이트가 끝나고 실행할 명령어
	- prerotate: 로테이트가 시작하기전 실행할 명령어
	- size: 로테이트 할 파일의 최대 사이즈
	- su user group: 로테이트 한 파일의 owner/group
	- dateext: 과거 버전의 로그 파일에 YYYYMMDD 형식으로 이름 추가.
	- dateyesterday: dateext 사용할 때, 오늘 대신 어제 날짜로 추가.

## 참고 자료

- https://www.networkworld.com/article/3218728/how-log-rotation-works-with-logrotate.html