---
tags:
  - 알고리즘
title: 이진탐색 lower bound, upper bound
---

알고리즘 문제 풀이 중 이진탐색 lower bound, upper bound를 사용해야되는 경우가 발생했다. 이론은 알고 있지만 이를 코드로 구현하는 것에 어려움을 겪어 아직 이해가 부족하다고 생각해서 글로 정리하게 되었다.

## lower bound

정렬된 데이터에서 처음으로 해당 값 이상이 되는 인덱스를 찾는 것이다. 

```python
def find_lower_bound(number):
    start = 0
    end = n
    while start < end:
        mid = (start + end) // 2
        if cards[mid] >= number:
            end = mid
        else:
            start = mid + 1
    return start
```

여기서 기존 이진 탐색과 end의 의미가 다른 것을 알아야된다. 기존 end값은 inclusive여서 초기값이 n - 1 이지만, lower bound와 upper bound에서는 end가 exclusive여서 초기값이 n이 된다. 그 이유는 찾고자하는 값이 리스트 내에 존재하지 않을 경우 처리를 위해서다. 만약 lower bound와 upper bound의 end를 inclusive로 설정한다면, 결과값이 0 또는 n - 1가 나오게 되어서 값을 찾은 경우와 구분이 힘들다.

- start와 end가 같아지는 순간의 start 값이 lower bound다.
- `cards[mid]` 와 `number` 가 같은 경우는 현재 보다 앞에서 같은 값이 나올 수도 있으므로 현재 위치(`mid`)로 `end`를 수정한다.

### upper bound

정렬된 데이터에서 처음으로 해당 값 초과가 되는 인덱스를 찾는 것이다.

```python
def find_upper_bound(number):
    start = 0
    end = n
    while start < end:
        mid = (start + end) // 2
        if cards[mid] <= number:
            start = mid + 1
        else:
            end = mid
    return start
```

lower bound와 같은 이유로 end 값은 exclusive로 처리한다.

- start와 end가 같아지는 순간의 start값이 upper bound다.
- `cards[mid]` 와 `number` 가 같은 경우는 현재 위치는 upper bound보다 모자라므로 `start`를 `mid + 1` 로 지정한다.

## 활용 사례

정렬된 데이터에서 특정 데이터의 개수를 찾을 때 사용할 수 있다. `upper bound` 인덱스 이상 `lower bound` 미만의 인덱스들은 특정 데이터와 값이 같다는 것을 의미하게 되므로 `upper bound` - `lower bound` 가 특정 데이터의 개수가 된다.

## 참고 자료

[https://jackpot53.tistory.com/33](https://jackpot53.tistory.com/33)
