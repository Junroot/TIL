---
title: Elasticsearch nested 타입으로 정렬하는 법
tags:
  - Elasticsearch
---

## 배경 

아래와 같은 인덱스가 있다고 해보자.

```js
{
	"mappings": {
		"properties": {
			"myFields": {
				"type": "nested",
				"properties": {
					"fieldName": { "type": "keyword" },
					"fieldType": { "type": "keyword" } ,
					"stringValue": { "type": "keyword" },
					"integerValue": { "type": "integer" },
					"dateValue": { "type": "date" }
				}
			}
		}
	}
}
```

예시와 같이 document에는 각 타입별로 사용하는 value 필드가 다르다.

```js
{
	"myFields": [
		{ 
			"fieldName": "custom01", 
			"fieldId": 1,
			"valueType": "STRING", 
			"stringValue": "value1" 
		},
		{ 
			"fieldName": "custom02", 
			"fieldId": 2,
			"valueType": "DATE", 
			"dateValue": "2025-10-01" 
		},
		{ 
			"fieldName": "custom03", 
			"fieldId": 3,
			"valueType": "INTEGER", 
			"integerValue": 123 
		}
	]
```

위 예시에서 `fieldName`이 `custom03` 인 필드의 `integerValue`를 기준으로 document를 정렬하고 싶다면 어떻게 해야될지 이해해본다.

## nested 타입 정렬 관련 옵션

- `path`: 정렬할 nested 객체를 선언한다. 정렬 기준이 되는 필드는 `path`에 선언한 객체의 필드로 있어야 된다. 필수값 옵션이다.
- `filter`: nested 객체가 `filter` 내에 선언한 조건과 일치할 때만 정렬 기준이 될 수 있다.
- `max_children`: 정렬 값을 계산할 때 참고할 nested 객체의 최대 개수 (성능 최적화를 위해 존재, 기본 값은 무제한)
- `nested`: nested 타입 객체 내의 필드를 정렬시 필요

## 예시

배경에서 나온 조건을 해결하기 위해서는 다음과 같이 정렬할 수 있다.

```js
POST /_search
{  
	//...
	"sort": [
		{
			"myFields.integerValue": {
				"order": "asc",
				"nested": {
					"path": "myFields",
					"filter": {
						"term": { "myFields.fieldName": "custom03" }
					}
				}
			}
		}
	]
}
```

## 예시2

아래 예시와 같이 nested  객체 안에 nested 객체 필드가 있다면, 재귀적으로 nested 정렬을 사용해야된다.

```json
POST /_search
{
	"sort": [
		{
			"parent.child.age": {
				"order": "asc",
				"nested": {
					"path": "parent",
					"filter": {
						"range": { "parent.age": {"gte": 21} }
					},
					"nested": {
						"path": "parent.child",
						"filter": {
							"match": {"parent.child.name": "matt"}
						}
					}
				}
			}
		}
	]
}
```

## 참고 자료

- https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results#nested-sorting
