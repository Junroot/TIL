---
tags:
  - Nodejs
title: express에서 request body 가져오는 법
---

express에서 POST 요청의 request body를 가져오지 못하는 문제가 있었다.

이를 해결하기 위해서는 express가 body 정보를 parsing할 수 있도록 별도의 설정을 해야된다. body-parser이라는 패키지를 가져와서, express app에서 사용하도록 설정해준다. 여기서 body-parser는 이름과 같이 raw body를 가져와서 파싱을 해준다.

나는 json content-type의 body 정보를 가져올 것이기 때문에 아래와 같이 설정했다. 다른 content-type을 사용할 경우에는 아래와 동일한 방법으로 추가해줄 수 있다.

```jsx
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json())
```
