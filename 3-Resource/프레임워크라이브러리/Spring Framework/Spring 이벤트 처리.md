# Spring 이벤트 처리

도메인 간의 복잡한 의존성을 제거하기 위해서 Spring의 이벤트를 이용할 수 있다. 이벤트를 사용하기 위해서는 3가지를 사용해야된다. 참고로, Spring Framework 4.2부터 지원하는 어노테이션 방법을 다룬다.

1. 이벤트 클래스
2. 이벤트 퍼블리셔
3. 이벤트 리스너

## 이벤트 클래스

이벤트에 데이터를 저장하기 위한 클래스로 자유롭게 클래스를 선언하면 된다.

```java
public class MenuRegisteredEvent {

    private final Menu menu;

    public MenuRegisteredEvent(final Menu menu) {
        this.menu = menu;
    }

    public Menu getMenu() {
        return menu;
    }

    public Long getMenuGroupId() {
        return menu.getMenuGroupId();
    }
}
```

## 이벤트 퍼블리셔

이벤트를 발생시키는 곳에 해당한다. 

```java
@Service
public class SomeService {

    private ApplicationEventPublisher applicationEventPublisher;

		public SomeService(final ApplicationEventPublisher applicationEvnetPublisher) {
				this.applicationEventPublisher = applicationEventPublisher;
	}

    public void publishCustomEvent() {
				Menu = new Menu(1L);
        CustomSpringEvent customSpringEvent = new MenuRegisteredEvent(menu);
        applicationEventPublisher.publishEvent(customSpringEvent);
    }
}
```

서비스에서 수동으로 이벤트를 발생시키지 않고 도메인 내부에 특정 로직에서 이벤트를 발생시켜야될 때가 있다. `AbstractAggregateRoot` 를 상속하여 이를 해결할 수 있다. 상속을 받으면 `registerEvent` 라는 메서드가 존재하고 이 메서드를 통해 이벤트를 발행할 수 있다.

```java
@Entity
public class Menu extends AbstractAggregateRoot<Menu> {
	//...

	public Menu(final Longid) {
			this.id =id;
	    this.name =name;
	    this.price =price;
	    this.menuGroupId =menuGroupId;
	    this.menuProducts =menuProducts;
	    registerEvent(new MenuRegisteredEvent(this));
	}
}
```

## 이벤트 핸들러

발행된 이벤트를 받아서 처리하기 위해 필요하다. `@EventListener`라는 어노테이션을 사용해서 처리할 수 있다. 아래의 `@Async` 어노테이션은 이벤트를 비동기적으로 처리하기위해 필요한 어노테이션이다. 이를 통해 어느정도 성능 개선을 할 수 있다. 또한, 기본적으로 이벤트를 발행한 곳과 처리하는 곳의 트랜잭션에 참여할 수 있고 동기적으로 처리된다.

```java
@Component
public class AnnotationDrivenEventListener {

    @Async
    @EventListener
    @Transactional
    public void handle(final MenuRegisteredEvent event) {
        validate(event);
    }

		//...
}
```

## 참고 자료

- [https://www.baeldung.com/spring-events](https://www.baeldung.com/spring-events)
- [https://www.baeldung.com/spring-data-ddd](https://www.baeldung.com/spring-data-ddd)