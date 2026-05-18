---
tags:
  - Shell-Script
title: set -o pipefail
---

- `set -o pipefail`: 파이프라인의 종료 코드를 **가장 오른쪽에서 실패한 명령의 종료 코드**로 바꾸는 Bash 옵션.
	- 모든 명령이 성공하면 0을 반환한다.
	- 기본 동작에서는 파이프라인의 종료 코드가 **마지막 명령의 종료 코드**만 따르기 때문에, 중간 명령이 실패해도 마지막 명령이 성공하면 파이프라인 전체가 성공으로 간주된다.

## 기본 동작과의 차이

- 기본 동작:

	```bash
	false | true
	echo $?  # 0 (마지막 명령인 true의 종료 코드)
	```

- `pipefail` 적용:

	```bash
	set -o pipefail
	false | true
	echo $?  # 1 (false의 종료 코드)
	```

## 왜 필요한가

- 스크립트에서 중간 명령이 실패해도 마지막 명령(`tee`, `grep`, `awk` 등)이 성공하면 그대로 다음 단계로 넘어가는 경우가 많다.
- 데이터 파이프라인이나 빌드 스크립트처럼 **각 단계가 모두 성공해야 의미 있는 경우** 실패를 놓치기 쉽다.
- `set -e`(errexit)와 함께 쓰면 파이프라인 중간 실패도 즉시 스크립트를 중단시킬 수 있다.

	```bash
	set -euo pipefail
	curl -fsSL https://example.com/data.json | jq '.items' > out.json
	```

	- `curl`이 실패하면 `jq`의 성공 여부와 관계없이 스크립트가 거기서 멈춘다.

## 안전한 스크립트의 관용구

- Bash 스크립트 상단에 자주 등장하는 조합:

	```bash
	set -euo pipefail
	```

	- `-e`: 명령이 실패하면 즉시 종료.
	- `-u`: 정의되지 않은 변수를 참조하면 에러.
	- `-o pipefail`: 파이프라인 중간 실패도 감지.

## 주의 사항

- POSIX `sh`에서는 지원하지 않는다. Bash, Zsh, Ksh 등에서만 동작한다.
	- 스크립트 첫 줄을 `#!/bin/bash`로 명시해야 안전하다.
- 파이프라인에서 의도적으로 일부 명령 실패를 무시해야 한다면, 해당 부분만 `|| true`로 감싸 우회한다.

## 참고 자료

- [Bash Reference Manual — The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
