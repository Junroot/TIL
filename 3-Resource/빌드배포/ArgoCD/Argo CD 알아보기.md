# Argo CD 알아보기

## 목표

- Argo CD의 용도가 무엇인지 이해한다.
- Argo CD 사용을 시작하는 방법을 이해한다.

## Argo CD란

- 쿠버네티스를 위해 사용되는 GitOps 패턴의 CD(Continuous Delivery) 도구이다.
- GitOps: git 레포지토리를 사용하여 인프라 프로비저닝 프로세스를 자동화하는 DevOps 기법이다.
- 쿠버네티스 매니페스트을 git 레포지토리에 명시하면, Argo CD는 지정된 환경에 애플리케이션 상태를 모니터링하고 원하는 상태가 되도록 배포를 자동화한다.
## Argo CD 구조

- 3가지 컴포넌트로 나뉜다.
	- API Server: 웹 UI, CLI 및 CI/CD 시스템에 소비하는 API를 노출하는 gRPC/REST 서버이다.
	- Repository Server: 애플리케이션 매니페스트를 보관하는 git 레포지토리의 로컬 캐시를 유지하는 내부 서비스다.
	- Application Controller: 실행 중인 애플리케이션을 지속적으로 모니터링하고 현재 상태를 원하는 목표 상태와 비굘하는 쿠버네티스 컨트롤러다. 동기화 되지 않은 애플리케이션 사태를 감지하면 수정 조치를 취한다. 라이프사이클 이벤트(`PreSync`, `Sync`, `PostSync`)에 대한 사용자 정의 후크를 호출한다.
- ![](assets/Pasted%20image%2020240901170050.png)

## Argo CD 시작하기

###  1. Argo CD 설치

- `argocd`라는 namespace를 만들고
- Argo CD 서비스와 애플리케이션 리소스를 생성한다.

```sh
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 2. Argo CD CLI 다운로드

```sh
brew install argocd
```

### 3. Argo CD API 서버 접근

- 기본적으로 Argo CD API는 외부 API로 노출되어 있지않다.
- 아래 방법 중 하나로 API 서버로 접근 가능하게 해야된다.
	- Load Balancer
	- Ingress
	- Port Forwarding
- 필자는 Load Balancer 를 사용했고, 아래의 명령어를 사용하면 된다.

```sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

### 4. CLI를 사용해서 로그인

- 아래 명령어를 통해 `admin` 계정의 초기 비밀번호를 생성하고, `argocd` 네임스페이스의 `argocd-initial-admin-secret` 이름의 secret의 `password` 필드로 저장한다.

```sh
argocd admin initial-password -n argocd
```

- 아래 명령어를 통해 `admin` 계정으로 로그인할 수 있다. `<ARGOCD_SERVER>`는 IP나 호스트명을 입력하면 된다.

```sh
argocd login <ARGOCD_SERVER>
```

- 아래 명령어로 패스워드를 변경할 수 있다.

```sh
argocd account update-password
```

### 5. Git 레포지토리로부터 애플리케이션 생성

- CLI를 사용하는 방법 UI를 사용하는 방법 두 가지가 가능하다.
- CLI를 사용하는 방법은 아래와 같다.

```sh
kubectl config set-context --current --namespace=argocd
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
```

### 6. 애플리케이션 Sync(Deploy)

- 여기서도 CLI와 UI 두 가징 방법이 있다.
- 아래는 CLI를 사용하는 방법이다.
- 생성된 애플리케이션 상태 확인
	- 아래 예시에서는 애플리케이션이 아직 배포되지 않았고 쿠버네티스 리소스가 생성되지 않았기 때문에 `OutOfSync` 상태이다.

```sh
$ argocd app get guestbook 
Name: guestbook 
Server: https://kubernetes.default.svc 
Namespace: default 
URL: https://10.97.164.88/applications/guestbook 
Repo: https://github.com/argoproj/argocd-example-apps.git 
Target: 
Path: guestbook 
Sync Policy: <none> 
Sync Status: OutOfSync from (1ff8a67) 
Health Status: Missing 

GROUP KIND NAMESPACE NAME STATUS HEALTH 
apps Deployment default guestbook-ui OutOfSync Missing 
     Service default guestbook-ui OutOfSync Missing
```

- sync(deploy) 하기위해서는 아래와 같이 명령어를 사용할 수 있다.
	- 아래 명령어는 git 레포지토리에서 매니페스트를 탐색하고, 매니페스트의 `kubectl apply`를 실행한다.

```sh
argocd app sync guestbook
```

- UI로는 아래와 같이 상태를 확인하고 sync할 수 있다.
	- ![](assets/Pasted%20image%2020240901173338.png)
	- ![](assets/Pasted%20image%2020240901173342.png)

## 참고 자료

- https://argo-cd.readthedocs.io/en/stable/
