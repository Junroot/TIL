# pem 키가 필요한 인스턴스에 scp 명령어로 파일 전송하기

```bash
scp -i [pem파일경로] [업로드할 파일 이름] [ec2-user계정명]@[ec2 instance의 public DNS]:~/[경로]
```

[https://ict-nroo.tistory.com/40](https://ict-nroo.tistory.com/40)