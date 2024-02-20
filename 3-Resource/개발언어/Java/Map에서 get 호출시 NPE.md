# Map에서 get 호출 시 NPE

## 배경

- `map.get(null)`을 호출하면 NPE가 발생할 것으로 예측했는데 발생하지 않았다.
- NPE가 발생하지 않는 이유를 이해한다.

## Map 인터페이스

- `get()` 메서드 호출시 파라미터가 null이면 NPE가 발생한다고 명시되어 있다.
- ![](assets/Pasted%20image%2020240220183545.png)

## HashMap

- 하지만 `HashMap`은 `Map` 인터페이스의 구현체임에도 key가 null인 경우를 허용하고 있어, `get()` 메서드 호출 시 null을 넘길 수 있다.
- ![](assets/Pasted%20image%2020240220183712.png)

## TreeMap

- `Map`의 또 다른 구현체인 `TreeMap`의 경우는 null을 넘기면 NPE가 발생한다.
- ![](assets/Pasted%20image%2020240220183826.png)

## 참고 자료

- [https://www.baeldung.com/java-treemap-vs-hashmap](https://www.baeldung.com/java-treemap-vs-hashmap)
