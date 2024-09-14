---
tags:
  - JavaScript
---
# MetaStream

JavaScript에서 비디오 스트림을 캡쳐하여 분석 ,가공 저장 등을 가능하게 해준다. 예제를 기반으로 사용법을 익혀본다.

```jsx
const canvas = document.querySelector("canvas");

// Optional frames per second argument.
const stream = canvas.captureStream(25);
const recordedChunks = [];

console.log(stream);
const options = { mimeType: "video/webm; codecs=vp9" }; // 1
const mediaRecorder = new MediaRecorder(stream, options);

mediaRecorder.ondataavailable = handleDataAvailable; // 2
mediaRecorder.start();

function handleDataAvailable(event) {
  console.log("data-available");
  if (event.data.size > 0) {
    recordedChunks.push(event.data);
    console.log(recordedChunks);
    download();
  } else {
    // …
  }
}
function download() {
  const blob = new Blob(recordedChunks, {
    type: "video/webm"
  }); // 3
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  document.body.appendChild(a);
  a.style = "display: none";
  a.href = url;
  a.download = "test.webm";
  a.click();
  window.URL.revokeObjectURL(url);
}

// demo: to download after 9sec
setTimeout(event => {
  console.log("stopping");
  mediaRecorder.stop();
}, 9000);

```

1. 자신이 원하는 mimeType과 코덱 등 메타데이터를 지정할 수 있다.
2. stream에 새로운 데이터가 생성될 때마다 `dataavailable` 이벤트가 발생하므로, 핸들러를 정의해야 된다.
3. 다운도드를 하기위해서는 `Blob` 객체로 생성해야된다.

## 참고 자료

[https://developer.mozilla.org/en-US/docs/Web/API/MediaStream_Recording_API](https://developer.mozilla.org/en-US/docs/Web/API/MediaStream_Recording_API)[https://melius.tistory.com/59](https://melius.tistory.com/59)