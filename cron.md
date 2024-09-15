---
tags:
  - Shell-Script
title: cron
---


## cron 목적

- 미리 정해진 시간에 예약된 작업 실행을 자동화하는 도구.
- 백그라운드 프로세스로 실행되며 사용자의 개입 없이 특정 이벤트나 조건이 트리거될 떄 미리 정의된 시간에 지정된 작업을 수행하는 데몬 프로세스다.

```sh
cron [-f] [-l] [-L loglevel]
```

## crontab

- cron이 실행할 작업을 나열한 파일
- 실행할 작업을 추가, 제거, 수정이 가능하다.
- crontab의 커맨드는 공백단위로 분리되며, 순서대로 나음을 의미한다.
	- Minute (holds a value between 0-59)
	- Hour (holds value between 0-23)
	- Day of Month (holds value between 1-31)
	- Month of the year (holds a value between 1-12 or Jan-Dec, the first three letters of the month’s name shall be used)
	- Day of the week (holds a value between 0-6 or Sun-Sat, here also first three letters of the day shall be used)
	- Command
- 예시

```
30 08 10 06 * /home/maverick/full-backup
```

## anacron

- 일, 주, 월 빈도로 작업을 실행할 수 있는 명령어
- cron 보다 좋은 점: cron은 예약된 시간에 컴퓨터가 꺼져있으면 실행하지 않지만, anacron은 마지막 작업 시각을 확인해서 마지막 실행 시각을 비교해서 시간이 지났으면 실행한다.
- anacron에서 지정한 디렉토리에 작업을 추가하면 된다.
	- 아래의 예에선 `/etc/cron.daily`, `/etc/cron.weekly`, `/etc/ron/monthly`
	- ![](assets/Pasted%20image%2020230622201625.png)

## 참고 자료

- https://www.geeksforgeeks.org/cron-command-in-linux-with-examples/
- https://www.geeksforgeeks.org/crontab-in-linux-with-examples/
- https://www.geeksforgeeks.org/anacron-command-in-linux-with-examples/
