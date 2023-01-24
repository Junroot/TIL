# RestAssured 사용시 @Autowired를 사용하면 안되는 이유

- RestAssured를 사용하면 Spring boot 애플리케이션을 실행하는 별도의 컨테이너를 실행시킨다. 따라서 `@Transactional`을 붙여도 별도의 다른 트랜잭션이 생겨 db에 반영할 수 없다. 따라서 RestAssured의 경우는 Repository를 Autowired 해서 사전 데이터를 설정할 수 없고, `@Sql` 어노테이션을 사용해야된다.
- WebSocket 테스트에서 사용하는 WebSocketStompClient도 마찬가지의 이유로 `@Sql` 어노테이션을 사용해야된다.
- [https://stackoverflow.com/a/43259419](https://stackoverflow.com/a/43259419)