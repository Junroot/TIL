---
tags:
  - MySQL
---
# Pagination 쿼리 최적화

## 목표

- pagination 쿼리 최적화 방법을 이해한다.
- pagination을 사용중일 때 데이터 개수를 어떻게 구할지 이해한다.

## Pagination 최적화 방법

### offset의 문제점

- 단순하게 pagination을 구현할 때, offset과 limit을 사용해서 구현한다.

```sql
select *
from news
order by date desc, id desc
limit 50
offset 4950;

create index .. on news(date, id);
```

- 이 방식은 5000개의 데이터를 가져와서 4950개의 행을 버리는 방식이다.
- 페이지가 넘어갈수록 심각하게 느려지는 문제가 있다.
- 중간에 데이터가 추가되는경우, 다음 페이지네이션에 중복된 데이터가 보일 수 있다.

### Seek method(Keyset pagination)

- offset을 사용하지 않는 방법이다.

```sql
select *
from news
where (date, id) < (prev_date, prev_id)
order by date desc, id desc
limit 50;

create index .. on news(date, id);
```

- 마지막 행의 데이터 이후로 50개의 데이터를 가져오게된다.
- 무한 스크롤 등 최근 모바일에서 많이 사용하는 UI에서는 문제가 없지만, 처음부터 특정 페이지로 가는 방법이 불가능해진다.

### Covering Index

- covering index: 조회할 데이터가 모두 index에 포함되어 있어서, clustered index에 추가 조회를 하지 않게 해주는 index를 의미한다.
- join 문 내에서 covering index를 통해 실제로 조회할 데이터의 id를 구하면 조회할 데이터의 수를 줄일 수 있다.
- 가능하면 keyset pagination을 사용하고, 사용이 불가능한 경우에 covering index를 이용하면 좋다.

```sql
select n.*  
from news as n  
         join (select id  
               from news  
               order by date desc, id desc  
                   limit 50 offset 4950) as cover  
              on n.id = cover.id

create index .. on news(date, id);
```

## Pagination 중에 데이터의 총 개수를 구해야 되는 경우

- 한번에 조회할 데이터 수를 줄이기 위해서 pagination을 사용하는데, 데이터의 총 개수를 알기 위해서는 모든 데이터를 스캔해야되는 문제가 있다.
- 결론부터 말하면 쿼리를 통한 최적화 방법은 없다!
	- 가능하면 데이터 개수 출력을 하지 않는다.
	- 대략적인 결과를 출력한다. (구글 검색도 정확한 개수를 표시하지는 않는다.)
	- 정확한 결과가 꼭 필요한 경우는 별도의 옵션으로 만들고, 활성화 했을 때만 출력되도록 한다.
	- 데이터 개수 조회 쿼리가 최대한 발생하지 않도록 캐싱 등의 방법을 사용한다.

## 참고 자료

- https://www.cybertec-postgresql.com/en/pagination-problem-total-result-count/
- https://use-the-index-luke.com/no-offset
- https://tecoble.techcourse.co.kr/post/2021-10-12-covering-index/

