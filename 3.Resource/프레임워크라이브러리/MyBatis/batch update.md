# batch update

## 목표

- 한꺼번에 다수의 row를 업데이트 해야될 때, 하나씩 update 쿼리를 보내면 부하가 많이 발생할 수 있다.
- mybatis에서 batch update 방법을 알아본다.

## 방법

- `SqlSessionFactory`를 통해 `SqlSession`을 생성하고 `flush`와 `commit`을 한다.

```kotlin
sqlSessionFactory.openSession(ExecutorType.BATCH).use { sqlSession ->
	val xxxMapper = sqlSession.getMapper(XXXMaper::class.java)
	xxxs.forEach {
		xxxMapper.update(it)
	}
	sqlSession.flushStatements()
	sqlSession.commit()
}
```

## SqlSession

- 트랜잭션을 commit 또는 rollback하고, Mapper 인스턴스를 획득할 수 있다.
- auto-commit이 꺼져있다면, `commit` 메서드를 호출하기 전까지 데이터베이스에 커밋되지 않는다. `commit` 메서드를 호출하지 않고 `SqlSession`이 닫힌다면 롤백된다.
- `sqlSessionFactory.openSession(ExecutorType.BATCH)`를 통해서 생성한 `sqlSession`는 auto-commit이 꺼져 있는 상태다.

## 참고 자료

- https://github.com/mybatis/mybatis-3/wiki/FAQ#how-do-i-code-a-batch-insert
- https://mybatis.org/mybatis-3/java-api.html