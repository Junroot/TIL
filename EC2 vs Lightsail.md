---
tags:
  - AWS
---
# EC2 vs Lightsail

## Lightsail

컴퓨팅, 스토리지, 네트워킹 및 DNS를 제공하는 VPS(가상 사설 서버)다. VPS는 하나의 물리서버를 여러 개의 가상 서버로 쪼개서 사용하는 것을 의미한다. 그래서 하나의 물리 서버를 여러명의 클라이언트와 나누어 쓰게된다. 하지만 나누어진 서버들은 독립 적인 서버 공간을 가진다.

## EC2와 다른 점

Lightsail 인스턴스는 실제로 t2클래스의 EC2 인스턴스다. 하지만 Lightsail은 여러 가지 기능이 간소화 되어있다.

1. 고정된 EBS SSD 볼륨
2. 중지되어도 청구되는 요금
3. 유연하지 않은 보안 그룹

## Lightsail을 사용해야되는 경우

단순한 인프라 구조를 가지는 경우에 유리하다. 또한 EC2는 트래픽 당 별도로 요금을 또 내야되지만 Lightsail은 고정된 비용을 지불하기 때문에 규모가 작은 개발을 진행할 경우는 Lightsail이 유리해 보인다.

## 참고 자료

[https://devlog.jwgo.kr/2020/06/21/ec2-vs-lightsail/](https://devlog.jwgo.kr/2020/06/21/ec2-vs-lightsail/)

[https://stackoverflow.com/questions/40927189/what-is-difference-between-lightsail-and-ec2](https://stackoverflow.com/questions/40927189/what-is-difference-between-lightsail-and-ec2)

[https://searchcloudcomputing.techtarget.com/tip/Compare-Amazon-Lightsail-vs-EC2-for-your-web-app-needs](https://searchcloudcomputing.techtarget.com/tip/Compare-Amazon-Lightsail-vs-EC2-for-your-web-app-needs)