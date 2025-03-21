---
tags:
  - AWS
title: Cloudwatch 에러 로그 발생 시 알림 오게 구성 하기
---

슬랙이나 디스코드에 알림이 오게 구성하고 싶었지만, 이는 AWS Lambda가 필요하다. 하지만 우리에겐 이 권한이 없기 때문에 따로 사용할 수 없다. 따라서, 에러 로그 발생 시 이메일이 전송되도록 구현했다.

![Cloudwatch%20%E1%84%8B%E1%85%A6%E1%84%85%E1%85%A5%20%E1%84%85%E1%85%A9%E1%84%80%E1%85%B3%20%E1%84%87%E1%85%A1%E1%86%AF%E1%84%89%E1%85%A2%E1%86%BC%20%E1%84%89%E1%85%B5%20%E1%84%8B%E1%85%A1%E1%86%AF%E1%84%85%E1%85%B5%E1%86%B7%20%E1%84%8B%E1%85%A9%E1%84%80%E1%85%A6%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%20%E1%84%92%20adbe43f0e85f4aa09f6069d05684fdff/Untitled.png](assets/Untitled-4551533.png)

이를 구현하기 위해서는 Simple Notification Service가 필요하다.

## 1. Amazon SNS 주제 생성

![Untitled](assets/Untitled%201_15.png)

- 이메일로 받을 것이기 때문에 표준으로 설정

![Untitled](assets/Untitled%202_10.png)

알림 받을 이메일 구독 생성

## 2. Log Metric Filter 만들기

![Untitled](assets/Untitled%203_6.png)

Log groups → 작업 → 지표 필터 생성

![Untitled](assets/Untitled%204_5.png)

패턴 필터링: ERROR(에러 로그에 ERROR라는 단어가 포함되기 때문)

![Untitled](assets/Untitled%205_5.png)

지표 네임스페이스와 지표 이름은 적당히 지어주면된다. 지표 값은 에러 로그가 생길 때마다 값을 1씩 늘려주기 위해서 1로 설정.

## 3. Alarm 생성하기

![Untitled](assets/Untitled%206_3.png)

CloudWatch → 경보 → 경보 생성

![Untitled](assets/Untitled%207_3.png)

지표 선택

![Untitled](assets/Untitled%208_3.png)

error 로그가 발생할 때 알림을 보내야 되므로 임계값을 1로 둔다. 기간은 적당히 설정.

![Untitled](assets/Untitled%209_3.png)

아까 전에 만들어둔 SNS 주제 선택

## 참고 자료

[https://theithollow.com/2017/12/11/use-amazon-cloudwatch-logs-metric-filters-send-alerts/](https://theithollow.com/2017/12/11/use-amazon-cloudwatch-logs-metric-filters-send-alerts/)

[https://medium.com/analytics-vidhya/generate-slack-notifications-for-aws-cloudwatch-alarms-e46b68540133](https://medium.com/analytics-vidhya/generate-slack-notifications-for-aws-cloudwatch-alarms-e46b68540133)
