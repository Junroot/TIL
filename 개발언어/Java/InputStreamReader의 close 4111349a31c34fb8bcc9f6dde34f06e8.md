# InputStreamReader의 close

InputStream을 character stream으로 사용할 수 있게해주는 InputStreamReader는 close를 하게되면 내부에 가지고 있는 InputStream도 함께 close되기 때문에 주의해서 사용해야된다.

[https://stackoverflow.com/questions/55549248/do-i-need-to-close-inputstreamreader-even-if-inputstream-should-remain-open](https://stackoverflow.com/questions/55549248/do-i-need-to-close-inputstreamreader-even-if-inputstream-should-remain-open)