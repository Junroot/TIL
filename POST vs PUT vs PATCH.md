---
tags:
  - 네트워크
  - HTTP
---
# POST vs PUT vs PATCH

이를 이해하기 위해서는 멱등성이라는 개념을 알아야된다. 멱등성은 동일한 요청을 한 번 보내는 것과 여러 번 연속으로 보내는 것이 같은 효과를 지니는지를 나타내는 성질이다. 대표적으로 GET, PUT, DELETE가 멱등성을 가지고, POST, PATCH는 멱등성을 가지지 않는다. PUT의 경우에는 요청의 body 내용을 그대로 리소스를 교체하게 되지만, PATCH는 사이드 이펙트가 있는 업데이트다.

[https://junroot.github.io/programming/REST/#http-메서드를-사용하여-요청의-의미를-가지게-하기](https://junroot.github.io/programming/REST/#http-%EB%A9%94%EC%84%9C%EB%93%9C%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%98%EC%97%AC-%EC%9A%94%EC%B2%AD%EC%9D%98-%EC%9D%98%EB%AF%B8%EB%A5%BC-%EA%B0%80%EC%A7%80%EA%B2%8C-%ED%95%98%EA%B8%B0)