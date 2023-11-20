# MariaDB 설치 하기

먼저 자신이 필요한 버전을 찾는다. 아래 링크에서 찾을 수 있다.

[https://downloads.mariadb.org/mariadb/repositories/](https://downloads.mariadb.org/mariadb/repositories/)

이 글은 MariaDB 10.6을 기준으로 진행한다.

1. MariaDB 레포지토리를 내 Ubuntu 시스템에 등록한다.

```groovy
sudo apt-get install software-properties-common
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.yongbok.net/mariadb/repo/10.6/ubuntu bionic main'
```

 2. MariaDB 10.6을 설치한다.

```groovy
sudo apt update
sudo apt install mariadb-server
```

## 참고 자료

[https://www.linuxbabe.com/mariadb/install-mariadb-10-5-ubuntu](https://www.linuxbabe.com/mariadb/install-mariadb-10-5-ubuntu)