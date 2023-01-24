# 정적 페이지 배포시 Cloudfront 캐시 지우기

![%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%A5%E1%86%A8%20%E1%84%91%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%8C%E1%85%B5%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%E1%84%89%E1%85%B5%20Cloudfront%20%E1%84%8F%E1%85%A2%E1%84%89%E1%85%B5%20%E1%84%8C%E1%85%B5%E1%84%8B%E1%85%AE%E1%84%80%E1%85%B5%207abd5d95020c42159eec39bbda34f61f/Untitled.png](assets/Untitled.png)

새로 배포할 때마다 cloudfront에 캐싱 되어 있는 파일을 지워야된다면 invalidation을 생성하면된다. 하지만 여기서 주의할 점이 invalidation은 설정 값이 아니다. 배포할 때마다 매번 invalidation을 생성해서 무효화 해줘야된다. 우리는 이 또한 자동화 해주고싶어서 aws cli를 사용했다.

```bash
aws cloudfront create-invalidation --distribution-id ${{ secrets.DISTRIBUTION_ID }} --paths "/index.html" "/bundle.js"
```

위의 명령어를 사용하려면 IAM에 CreateInvalidation 접근 권한이 필요하다. 우리의 경우 CU 코치님에게 요청을 해서 받을 수 있었다.

## 참고 자료

[https://docs.aws.amazon.com/cli/latest/reference/cloudfront/create-invalidation.html](https://docs.aws.amazon.com/cli/latest/reference/cloudfront/create-invalidation.html)