---
tags:
  - Spring-Framework
---
# 통합테스트에 @Transactional을 붙이면 안되는 이유

## 배경

- 통합 테스트중에 DB에 추가된 데이터를 제거하기 위해서 `@Transactional`을 사용하는 경우가 있다.
	- 이럴 경우 버그가 있어 실패해야될 테스트가 통과되어버리는 문제가 발생할 수 있다.

```java
@SpringBootTest
@Transactional
internal class CartItemsControllerTests {

    ...

    @Test
    fun getAllCartItems() {
        val cart = Cart()
        cart.addProduct(product, 3)
        cartsRepository.save(cart)

        mockMvc.perform(get("/carts/{id}/items", cart.id))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.[*].id").value(hasItem(cart.items[0].id.toString())))
            .andExpect(jsonPath("$.[*].product.id").value(hasItem(product.id.toString())))
            .andExpect(jsonPath("$.[*].product.name").value(hasItem(product.name)))
            .andExpect(jsonPath("$.[*].quantity").value(3))
    }
}
```

## 이유

- 서비스에 `@Transactional`이 붙어있지 않아서 실패되어야할 요청이 통과되어버린다.
	- lazy loading이 동작하지 않아서 실패해야 되는 경우에도 통과 되어버린다.
	- 변경 탐지가 동작하지 않아서 실패해야 되는 경우에도 통과 되어버린다.
- hibernate 등을 사용하면, 실제로 DB에 있는 데이터를 가져오지 않고 1차 캐시에서 데이터를 가져올 수도 있다.

## 권장 방법

- `@Transactional`을 사용하지 않고, 각 테스트마다 쿼리를 보내서 데이터를 추가, 삭제한다.

## 참고 자료

- https://dev.to/henrykeys/don-t-use-transactional-in-tests-40eb
- https://stackoverflow.com/questions/26597440/how-do-you-test-spring-transactional-without-just-hitting-hibernate-level-1-cac