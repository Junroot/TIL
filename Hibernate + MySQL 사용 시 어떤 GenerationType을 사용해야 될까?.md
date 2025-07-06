---
title: Hibernate + MySQL 사용 시 어떤 GenerationType을 사용해야 될까?
tags:
  - JPA
  - Hibernate
  - MySQL
---
## 목표

- MySQL 을 사용 중인 환경에서 Hibernate의 각 GenerationType이 PK를 생성하는 방식을 이해한다.

## GenerationType

- `GenerationType`: JPA에서 PK를 생성하는 전략을 나타내는 enum
	- `TABLE`: 데이터베이스 테이블을 사용해서 PK 할당
	- `SEQUENCE`: 데이터베이스 시퀀스를 사용해서 PK 할당
	- `IDENTITY`: 데이터베이스의 식별자 컬럼(MySQL의 AUTO_INCREMENT)을 사용해서 PK 할당
	- `UUID`: 애플리케이션에서 UUID를 생성해서 PK 할당
		- JPA 3.1, Hibernate 6.2부터 지원 시작
	- `AUTO`: 사용 중인 데이터베이스 종류에 따라서 자동으로 전략 선택

## GenerationType.AUTO의 전략 선택 과정

### Hibernate 5.2

- Spring Boot 2부터 `hibernate.id.new_generator_mappings` 가 `true`로 바뀌면서, MySQL 을 사용할 때 AUTO를 사용하면 UUID 타입의 경우를 제외하고는 TABLE 전략을 사용해서 PK를 생성하게 된다.

[![](https://mermaid.ink/img/pako:eNptkUFrnEAYhv_KMKcWjKhxXddDoRt3NyallzWHRpcw0S-udB3t7JjUykIpPQRySQ8hoQ0hl1IK_Qn9R7X_oeMkMVnoHJzx-573_d5hahzlMWAHHy3yk2hOGEe-G9KQIvQyaM6um5svM7Sx8QIN6x1yTJBfFbBqu0NRRXt7niu7W0F7nAAFRnjOZh3R3F40p1d_ry6egZqo6FVOEwV5lEMC7LmUuoEXd8IpFxskVUuwgoH4Sq-7KaN6nh4CowJR01ilcHKQPCgPMlIUKU2WMt2onc1ZCVI3DqbwrgQawZRXC1iPOZbIdu0Om8vz5vM1Wt6zqPnxsfl2Lv221_y8J36sjHjJBPzpV_P156yDj8hieUfvBD45XPwfHa2jk0DcLT0G2ZvI0u5jMM8dvfY9_82f77-fZttdzxYD5Smvukt2yOOYcUixgjNgGUlj8fZ1y4SYzyGDEDviGBP2NsQhXQmOlDyfVjTCTjtEwSwvkzl2pJ2CyyIWz-GmJGEk66oFoft5nj1IxC92avweO4beUw1rYBo9Y9DvD2y7p-AKO7qpGgPDsjYNbVMzxdJXCv4gHTTVtnRN7_ds09a0vqEZCk5Ym_s-DtAY2FZeUi58LNtc_QMhu_bF?type=png)](https://mermaid.live/edit#pako:eNptkUFrnEAYhv_KMKcWjKhxXddDoRt3NyallzWHRpcw0S-udB3t7JjUykIpPQRySQ8hoQ0hl1IK_Qn9R7X_oeMkMVnoHJzx-573_d5hahzlMWAHHy3yk2hOGEe-G9KQIvQyaM6um5svM7Sx8QIN6x1yTJBfFbBqu0NRRXt7niu7W0F7nAAFRnjOZh3R3F40p1d_ry6egZqo6FVOEwV5lEMC7LmUuoEXd8IpFxskVUuwgoH4Sq-7KaN6nh4CowJR01ilcHKQPCgPMlIUKU2WMt2onc1ZCVI3DqbwrgQawZRXC1iPOZbIdu0Om8vz5vM1Wt6zqPnxsfl2Lv221_y8J36sjHjJBPzpV_P156yDj8hieUfvBD45XPwfHa2jk0DcLT0G2ZvI0u5jMM8dvfY9_82f77-fZttdzxYD5Smvukt2yOOYcUixgjNgGUlj8fZ1y4SYzyGDEDviGBP2NsQhXQmOlDyfVjTCTjtEwSwvkzl2pJ2CyyIWz-GmJGEk66oFoft5nj1IxC92avweO4beUw1rYBo9Y9DvD2y7p-AKO7qpGgPDsjYNbVMzxdJXCv4gHTTVtnRN7_ds09a0vqEZCk5Ym_s-DtAY2FZeUi58LNtc_QMhu_bF)

### Hibernate 6.0부터

- 6.0 부터는 동작이 단순화되었다.
- 아래와 같이 동작하면서 MySQL에서 AUTO 방식을 사용할 때는 IDENTITY로 동작하는 경우가 절대 없어졌다.

[![](https://mermaid.ink/img/pako:eNpVkb9OwzAQxl_FugmkEDmmf5IMSJRABYKp7ULSwSTXtKKxi-sAJarEwIDEAgOiEhVi4-XCO5CkpQJP57vffffpLoNQRgguDMbyJhxypUnXC0QgCNn386dl_vHSJzs7e6SVnfBrTrqzCc7LaqvIkl7v2KuqB34ZtlGg4lqq_obIP1_zx8X34nULzdgkp1LEBjkWGmNU21Wr53fwKkURYkfPxvhfY6V-mHmt_O05f1iS6Zol-dd9_v5cWTksB2mVYgUf_dFTaahThf0NNeDj6Qpr-11-Mf7HgAEJqoSPomIfWdkTgB5iggG4RRhxdRlAIOYFx1MtOzMRglvONUDJNB6CW8kbkE4irtEb8VjxZJOdcHEuZfLbUnzBzeAWXGbVTdZwaqzOnGbTse26ATNwrZrJHNZo7DK6S2vFs-YG3FUK1LQbFrWadbtmU9pklBkQq9L32g6KCNWBTIUu5Cl1DMBoVCz1bHXs6ubzH8RLpzY?type=png)](https://mermaid.live/edit#pako:eNpVkb9OwzAQxl_FugmkEDmmf5IMSJRABYKp7ULSwSTXtKKxi-sAJarEwIDEAgOiEhVi4-XCO5CkpQJP57vffffpLoNQRgguDMbyJhxypUnXC0QgCNn386dl_vHSJzs7e6SVnfBrTrqzCc7LaqvIkl7v2KuqB34ZtlGg4lqq_obIP1_zx8X34nULzdgkp1LEBjkWGmNU21Wr53fwKkURYkfPxvhfY6V-mHmt_O05f1iS6Zol-dd9_v5cWTksB2mVYgUf_dFTaahThf0NNeDj6Qpr-11-Mf7HgAEJqoSPomIfWdkTgB5iggG4RRhxdRlAIOYFx1MtOzMRglvONUDJNB6CW8kbkE4irtEb8VjxZJOdcHEuZfLbUnzBzeAWXGbVTdZwaqzOnGbTse26ATNwrZrJHNZo7DK6S2vFs-YG3FUK1LQbFrWadbtmU9pklBkQq9L32g6KCNWBTIUu5Cl1DMBoVCz1bHXs6ubzH8RLpzY)

## IDENTITY 전략의 특징

- IDENTITY 방식은 INSERT 쿼리를 먼저 실행해야 ID를 얻을 수 있기 때문에 쓰기 지연을 할 수가 없다.
- 또한 IDENTITY 방식은 batch insert를 할 수 없어 대량의 쓰기가 자주 발생한다면 성능에 영향을 줄 수 있다.

## TABLE 전략의 특징

- `allocationSize` 만큼 테이블에서 id를 가져와서 메모리에 가져와서 DB 왕복을 줄인다.
- id를 가져오고 업데이트하기 위한 쿼리는 원래 저장하려는 엔티티와 별도 트랜잭션으로 실행되어 동시성 성능이 떨어지는 것을 방지한다.
- 예를 들어 아래와 같은 `Product` 엔티티를 저장할 때 현재 메모리에 id 정보가 없다면 3개의 쿼리가 발생할 것이다.
	- ![](assets/Pasted%20image%2020250706213736.png)
	- ![](assets/Pasted%20image%2020250706213819.png)

## IDENTITY vs TABLE

- IDENTITY는 batch insert가 지원되지 않고, TABLE은 insert를 위해 추가적인 쿼리가 발생한다는 단점이 존재한다.
- 조사를 해보다가 Hibernate 개발자의 의견을 확인할 수 있었다.
	- https://discourse.hibernate.org/t/choosing-the-best-strategy-for-oracle-and-mysql/6728
	- https://discourse.hibernate.org/t/generated-value-strategy-auto/6481
	- Hibernate 개발자는 `SequenceStyleGenerator` 사용이 더 좋은 성능을 보여줄 것이라고 주장하면서도, 온라인에 있는 정보만으로 결정하는 것보다는 직접 실험해보기를 이야기하고 있다. 
	- ![](assets/Pasted%20image%2020250707000402.png)
	- ![](assets/Pasted%20image%2020250707000507.png)

### 실험해보기

- hibernate 6.4.1을 기준으로 여러 개의 엔티티를 추가할 때의 성능을 비교해본다.
- `Player`: TABLE 전략 사용. allocationSize=1000
- `Player2`: IDENTITY 전략 사용.
	- ![](assets/Pasted%20image%2020250706234324.png)
	- ![](assets/Pasted%20image%2020250706234335.png)
- 아래와 같이 Spring 통합 테스트로 `saveAll()` 메서드를 사용해서 batch-insert 를 시도했을 때 성능을 비교해본다.
	- `hibernate.jdbc.batch_size:1000` 으로 batch size를 설정했다.
	- 아래 표와 같이 엔티티의 수가 적을 때는 id 채번을 위해 추가 쿼리가 발생하여 TABLE 방식이 느리지만, 엔티티 수가 많을 수록 기하급수적으로 IDENTITY 방식의 처리 시간이 느려지는 것을 확인할 수 있다.

| n(엔티티 수) | TABLE(ms) | IDENTITY(ms) | 증가 비율 |
| -------- | --------- | ------------ | ----- |
| 1        | 151       | 92           | 0.61  |
| 2        | 225       | 94           | 0.42  |
| 10       | 220       | 190          | 0.86  |
| 50       | 233       | 905          | 3.88  |
| 250      | 296       | 3640         | 12.3  |
| 500      | 364       | 6963         | 19.13 |
| 1000     | 428       | 13417        | 31.35 |
| 5000     | 1179      | 60513        | 51.33 |

## 결론

- 적은 개수를 insert 할 때는 절대적은 ms 차이가 크게 나는것은 아니지만, 개수가 늘어날 수록 IDENTITY는 기하급수적으로 느려지고 있었다.
- 직접 테스트해본 결과를 믿고 TABLE 방식을 사용하고자 한다.

## 참고 자료

- https://docs.jboss.org/hibernate/orm/current/userguide/html_single/Hibernate_User_Guide.html#identifiers-generators-auto
- https://techblog.woowahan.com/2663/
- https://docs.jboss.org/hibernate/orm/5.6/javadocs/org/hibernate/id/MultipleHiLoPerTableGenerator.html
- https://docs.jboss.org/hibernate/orm/6.5/javadocs/org/hibernate/id/enhanced/TableGenerator.html
- https://jaehun2841.github.io/2020/11/22/2020-11-22-spring-data-jpa-batch-insert/#hibernate-jdbc-batch-size
