---
tags:
  - Python
---
# sort 기준 변경

`sort()` 함수의 `key` 파라미터를 통해서 정렬 기준을 변경할 수 있다. 이 파라미터는 람다를 파라미터로 받는다.

람다는 요소를 파라미터로 받고, 우선 순위가 높은 정렬 기준을 앞으로 오도록 하는 튜플을 반환하면 된다. 역순으로 정렬하고 싶다면 `-x[0]` 와 같이 두면 역순으로 정렬된다.

```python
temp.sort(key=lambda x : (x[0], x[1]))  # '-'부호를 이용해서 역순으로 가능
```

좀 더 복잡한 비교 연산이 필요한 경우 함수를 사용해야된다.

`functools` 모듈을 불러와서 `functools.cmp_to_key()` 의 파라미터로 자신이 커스텀한 함수를 주면 된다. 왼쪽의 값이 먼저 오고싶다면 -1을, 오른쪽 값이 먼저 오고싶다면 1을, 같다면 0을 반환하면된다.

```python
import functools

def compare(number1, number2):
    concat1, concat2 = number1 + number2, number2 + number1
    if concat1 > concat2:
        return -1
    if concat1 == concat2:
        return 0
    return 1

def solution(numbers):
    converted_numbers = list(map(str, numbers))
    converted_numbers.sort(key=functools.cmp_to_key(compare))
    return str(int("".join(converted_numbers)))
```

## 참고 자료

[https://ooyoung.tistory.com/59](https://ooyoung.tistory.com/59)