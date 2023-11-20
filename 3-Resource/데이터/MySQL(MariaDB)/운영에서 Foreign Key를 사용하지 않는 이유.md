# 운영에서 Foreign Key를 사용하지 않는 이유

## 배경

- ERD diagram을 최신화 하는 도중 실제 운영 DB에서는 FK가 따로 설정되어 있지 않아서 테이블 간의 관계를 파악하는 것에 어려움이 있었다.
- 일반적으로 한국 회사에서 이 방법을 많이 사용하는 것으로 보인다.

## 설명

- 성능에 영향을 미친다. FK의 정합성을 체크하는 과정에서 부하가 발생한다.
- 데이터를 처리하는 순서를 신경쓸 필요가 없다. 부모 테이블에 작업할 때 자식 테이블의 간섭을 피할 수 있다.
- 데이터베이스 대신 애플리케이션에서 체크를 한다. 이를 통해 유동적으로 검증 과정을 수정할 수 있다.
- 데이터베이스 샤딩을 할 때 FK가 방해된다.
- OSC가 제대로 작동하지 않을 수 있다.

## 참고 자료

- https://dba.stackexchange.com/questions/168590/not-using-foreign-key-constraints-in-real-practice-is-it-ok
- https://github.com/github/gh-ost/issues/331#issuecomment-266027731
- https://martin-son.github.io/Martin-IT-Blog/mysql/foreign%20key/performance/2022/02/28/foreign-key-Performance.html