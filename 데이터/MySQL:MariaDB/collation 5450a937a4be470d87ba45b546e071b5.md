# collation

문자열을 비교할 때 어떤 규칙으로 비교하는지는 collation 설정에 따라 달렸다. mysql 기준으로 자주 사용하는 collation은 다음이 있다.

- utf8_general_ci
- utf8_unicode_ci
- utf8_bin

특수문자를 사용한다면 아래중 하나를 사용해야된다.

- utf8mb4_general_ci
- utf8mb4_unicode_ci

ut8_bin의 경우는 A < B < a < b로 처리된다.

utf8_general_ci는 정렬할 때는 A < a < B < b로 처리되고, 'a' = 'A'는 참이 나온다.

## 참고 자료

[https://sshkim.tistory.com/128](https://sshkim.tistory.com/128)

[https://m.blog.naver.com/writer0713/221806591790](https://m.blog.naver.com/writer0713/221806591790)