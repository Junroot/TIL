---
tags:
  - Elasticsearch
title: properties vs fields
---


## 목표

- 인덱스 mapping 정보에서 `properties`와 `fields`의 차이점을 이해한다.

## properties

- 서브 필드를 가지고 있는 `object`와 `nsteds` 타입 매핑에서 사용된다.
- 새로운 속성을 추가하기 위해서 사용한다.

## fields

- 같은 필드를 다른 목적으로 사용한다는 의미다.
- 예를 들어, `string` 타입의 필드를 full-text search를 위한 `text` 필드와 정렬 을위한 `keyword`로 매핑할 때 사용할 수 있다.
- ![](assets/Pasted%20image%2020231102193350.png)

## 참고 자료

- https://www.elastic.co/guide/en/elasticsearch/reference/current/properties.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html
