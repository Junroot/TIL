---
tags:
  - MyBatis
title: DynamicSQL
---


## 목표

- MyBatis의 dynamic sql 사용법을 이해한다.

## if 

- 조건을 만족했을 때만 쿼리 추가

```sql
<select id="findActiveBlogWithTitleLike"
     resultType="Blog">
  SELECT * FROM BLOG
  WHERE state = ‘ACTIVE’
  <if test="title != null">
    AND title like #{title}
  </if>
</select>
```

## choose, when, otherwise

- Java의 switch 문과 같이 조건을 만족하는 하나의 구문만 추가
- 모두 만족하지 않을 경우 otherwise 구문 추가

```sql
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG WHERE state = ‘ACTIVE’
  <choose>
    <when test="title != null">
      AND title like #{title}
    </when>
    <when test="author != null and author.name != null">
      AND author_name like #{author.name}
    </when>
    <otherwise>
      AND featured = 1
    </otherwise>
  </choose>
</select>
```

## trim, where, set

```sql
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG
  WHERE
  <if test="state != null">
    state = #{state}
  </if>
  <if test="title != null">
    AND title like #{title}
  </if>
  <if test="author != null and author.name != null">
    AND author_name like #{author.name}
  </if>
</select>
```

- 위 예시의 경우 모든 if문이 다 false면 sql 문법 에러가 발생한다.

```sql
SELECT * FROM BLOG
WHERE
```

- 또한, 첫 번째 조건문이 false인 경우에도 sql 문법 에러가 발생한다.

```sql
SELECT * FROM BLOG
WHERE
AND title like ‘someTitle’
```

- `<where>` 태그를 사용하면 WHERE 아래에 값이 일을 때만 WHERE 이 추가된다.
	- 또한 WHERE 뒤 값이 AND나 OR로 시작하면 이를 제거해준다.

```sql
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG
  <where>
    <if test="state != null">
         state = #{state}
    </if>
    <if test="title != null">
        AND title like #{title}
    </if>
    <if test="author != null and author.name != null">
        AND author_name like #{author.name}
    </if>
  </where>
</select>
```

- 만약 `<where>`이 내가 원하는대로 정확하게 동작하지 않으면 `<trim>` 태그로 직접 구성할 수도 있다.
	- `prefix` 뒤에 값이 없으면 `prefix`도 추가되지 않음
	- `prefix` 뒤에 `prefixOverrides`로 시작하는 경우 해당 글자 제거
		- `|` 기호로 여러개 지정 가능 

```sql
<trim prefix="WHERE" prefixOverrides="AND |OR ">
  ...
</trim>
```

- update 문에서도 `<where>`와 비슷한 `<set>` 태그가 있다.

```sql
<update id="updateAuthorIfNecessary">
  update Author
    <set>
      <if test="username != null">username=#{username},</if>
      <if test="password != null">password=#{password},</if>
      <if test="email != null">email=#{email},</if>
      <if test="bio != null">bio=#{bio}</if>
    </set>
  where id=#{id}
</update>
```

- `<set>` 태그를 `<trim>`으로 표현하면 다음과 같다.

```sql
<trim prefix="SET" suffixOverrides=",">
  ...
</trim>
```

## foreach

- 이터레이터 클래스에서 각 요소를 참조해야될 때 사용한다.
	- `Map` 객체에서 사용할 때는 키가 `index`에, 값이 `item`에 매핑된다.

```sql
<select id="selectPostIn" resultType="domain.blog.Post">
  SELECT *
  FROM POST P
  <where>
    <foreach item="item" index="index" collection="list"
        open="ID in (" separator="," close=")" nullable="true">
          #{item}
    </foreach>
  </where>
</select>
```

## script

- Java mapper 클래스에서 사용할 때는 `<script>` 태그를 붙여야된다.

```sql
@Update({"<script>",
  "update Author",
  "  <set>",
  "    <if test='username != null'>username=#{username},</if>",
  "    <if test='password != null'>password=#{password},</if>",
  "    <if test='email != null'>email=#{email},</if>",
  "    <if test='bio != null'>bio=#{bio}</if>",
  "  </set>",
  "where id=#{id}",
  "</script>"})
void updateAuthorValues(Author author);
```

## 참고 자료

- https://mybatis.org/mybatis-3/dynamic-sql.html
