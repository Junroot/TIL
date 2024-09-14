---
tags:
  - Java
---
# Progressive JPEG 파일 저장

[https://www.notion.so/85433ee030e7453b86ef84f399faa415](../../../3.Resource/%EA%B0%9C%EB%B0%9C%EC%96%B8%EC%96%B4/Java/%E1%84%8B%E1%85%B5%E1%84%86%E1%85%B5%E1%84%8C%E1%85%B5%20%E1%84%85%E1%85%B5%E1%84%89%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8C%E1%85%B5%E1%86%BC%20%E1%84%86%E1%85%B5%E1%86%BE%20%E1%84%8B%E1%85%A1%E1%86%B8%E1%84%8E%E1%85%AE%E1%86%A8%20%E1%84%89%E1%85%A1%E1%86%B8%E1%84%8C%E1%85%B5%E1%86%AF%2085433ee030e7453b86ef84f399faa415.md)

여기에서 이어지는 내용이다. JPEG파일을 Progressive JPEG로 저장되도록 구현하려고 했다.

```java
ImageWriter imageWriter = ImageIO.getImageWritersByFormatName("jpg").next();
JPEGImageWriteParam imageWriteParam = new JPEGImageWriteParam(null);
imageWriteParam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
imageWriteParam.setCompressionQuality(0.4f);
imageWriteParam.setProgressiveMode(ImageWriteParam.MODE_DEFAULT);
imageWriter.setOutput(imageOutputStream);

image = ImageIO.read(file);

IIOImage iioImage = new IIOImage(image, null, null);

imageWriter.write(null, iioImage, imageWriteParam);
```

위 코드와 같이 `setProgressiveMode()` 메서드를 사용하면 쉽게 설정이 가능하다.

## 참고 자료

[https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true\&blogId=kkforgg\&logNo=221499435383](https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true\&blogId=kkforgg\&logNo=221499435383)

[https://stackoverflow.com/questions/34178759/how-to-use-cfimage-to-save-image-as-progressive-jpg](https://stackoverflow.com/questions/34178759/how-to-use-cfimage-to-save-image-as-progressive-jpg)
