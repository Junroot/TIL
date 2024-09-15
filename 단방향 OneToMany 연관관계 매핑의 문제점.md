---
tags:
  - JPA
title: 단방향 OneToMany 연관관계 매핑의 문제점
---

단방향 연관관계 매핑을 사용하면 insert 이후에, FK를 저장하기 위해 update 쿼리를 한 번더 실행하는 문제가 있다.

```java
@Entity
public class Menu {
		
		//...

		@OneToMany(cascade = CascadeType.PERSIST)
		@JoinColumn(name = "menu_id")
	  private final List<MenuProduct> menuProducts;

		//...
}

@Entity
public class MenuProduct {

		//...
}
```

위 상황의 경우 `MenuProduct` 엔티티의 `menu_id`라는 FK가 저장된다. 하지만 `Menu` 를 저장할 때, `MenuProduct`에 FK 값을 지정하기 위해서 update 쿼리가 한 번더 실행되기 때문에 성능상 좋지않다. 단방향 OneToMany를 사용하는 것 보다는 양방향 ManyToOne을 사용하는 것이 좋다.

## 참고 자료

[https://velog.io/@ynoolee/JPA-일대다-다대일-쿼리](https://velog.io/@ynoolee/JPA-%EC%9D%BC%EB%8C%80%EB%8B%A4-%EB%8B%A4%EB%8C%80%EC%9D%BC-%EC%BF%BC%EB%A6%AC)
