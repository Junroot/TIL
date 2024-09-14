---
tags:
  - MySQL
---
# 그룹 별 상위 n개 가져오기

## 배경

- 어떤 테이블에 대해서 컬럼 A 기준으로 group을 만들고 그룹 내에서 컬럼 B 기준으로 상위 n개를 가져와야 되는 목적이 생겼다.

## 해결 방법

- 예시를 들어 설명을 한다.

- 아래와 같이 테이블과 행이 존재한다.

```sql
create table player  
(  
    user_id bigint auto_increment primary key,
    team_id bigint not null,  
    score   bigint not null  
);
```

![](assets/Pasted%20image%2020240823193244.png)

- 다음과 같이 데이터가 존재하고, `team_id` 별로 상위 2등까지 플레이어를 확인하고 싶다면 아래와 같이 작성하면된다.

```sql
SELECT * FROM(  
    SELECT *, RANK() OVER (PARTITION BY player.team_id ORDER BY player.score DESC) as ranking  
    FROM player  
 ) as player_ranking  
where player_ranking.ranking < 3;
```

![](assets/Pasted%20image%2020240823193459.png)

- `RANK()`는 윈도우 함수로 `team_id`를 그룹으로 나눠서 `score` 로 정렬 후 가장 큰 순서대로 랭킹을 매긴다.
	- https://dev.mysql.com/doc/refman/8.4/en/window-function-descriptions.html#function_rank
- 윈도우 함수를 사용할 때는 인덱스를 사용하지 못하는 경우가 많기 때문에 가능하면 윈도우 함수를 사용하지 않는 다른 방법이 있다면 그것을 사용하는 것이 좋다.

## 참고 자료

- https://dev.mysql.com/doc/refman/8.4/en/window-function-descriptions.html#function_rank
