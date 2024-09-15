---
tags:
  - Elasticsearch
title: keyword의 최대 길이
---


## 배경

- `fields` 매핑을 이용해 특정 text를 keyword로도 사용할 수 있도록 설정해둠
- 그러나 keyword 필드에 값이 존재하지 않음

## 원인

- keyword 타입 매핑시에 처리 가능한 최대 길이를 설정할 수 있다.
- `"ignore_above" : <자연수>` 옵션이며, 다이나믹 매핑으로 keyword가 생성될 때는 기본값인 256으로 설정된다.

## 참고 자료

- https://esbook.kimjmin.net/07-settings-and-mappings/7.2-mappings/7.2.1#keyword
- https://www.elastic.co/guide/en/elasticsearch/reference/current/ignore-above.html
