---
tags:
  - Jackson
title: Jackson byte를 List 형태로 반환하는 법
---

```java
List<Map<String,Object>> participantJsonList = mapper.readValue(jsonString, new TypeReference<List<Map<String,Object>>>(){});
```

## 참고 자료
