---
tags:
  - MySQL
---
# MySQL 스키마 복제하기

## 목표

- 새로 만든 MySQL 서버에 기존에 있던 MySQL 스키마를 그대로 가져오고 싶었다.

## 해결 방법

- mysql에서 제공하는 mysql client에서 db 데이터를 dumping하는 기능을 제공하주고 있다.
- `--no-data`는 테이블 내에있는 row 들은 복제하지 않겠다는 옵션이다.

```sh
mysqldump --user=<username> --host=<hostname> --password --no-data <original db> | mysql -u <user name> -p <new db>
```

- `mysqldump`와 관련된 추가적인 옵션들은 아래 링크에서 확인 가능하다.
	- https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html

## 참고 자료

- https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html
- https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html
- https://www.prisma.io/dataguide/mysql/short-guides/exporting-schemas

