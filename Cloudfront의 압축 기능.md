---
tags:
  - AWS
title: Cloudfront의 압축 기능
---

Cloudfront에서 파일을 전송해줄 때 데이터의 용량을 줄이기위해서 파일을 압축해서 전송한다. 하지만 압축가능한 형식이 제한되어 있으므로 아래 문서를 확인해야된다.

[https://docs.aws.amazon.com/ko_kr/AmazonCloudFront/latest/DeveloperGuide/ServingCompressedFiles.html#compressed-content-cloudfront-file-types](https://docs.aws.amazon.com/ko_kr/AmazonCloudFront/latest/DeveloperGuide/ServingCompressedFiles.html#compressed-content-cloudfront-file-types)

### 이미지 전송 크기 문제

이미지 용량 때문에 로딩이 느려지는 문제를 해결 하기위해 방법을 좀 찾아봤다. 이미지를 요청할 때 이미지 크기도 같이 기입하여 적절하게 리사이징 하는 기법이 있는데 이 방법은 Lambda를 사용해야되어서 현재는 사용이 불가하다. 포기!

[https://stackoverflow.com/questions/42187592/best-way-to-save-images-on-amazon-s3-and-distribute-them-using-cloudfront](https://stackoverflow.com/questions/42187592/best-way-to-save-images-on-amazon-s3-and-distribute-them-using-cloudfront)

[https://aws.amazon.com/ko/blogs/networking-and-content-delivery/resizing-images-with-amazon-cloudfront-lambdaedge-aws-cdn-blog/](https://aws.amazon.com/ko/blogs/networking-and-content-delivery/resizing-images-with-amazon-cloudfront-lambdaedge-aws-cdn-blog/)
