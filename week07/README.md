# 7주차 Docker Compose

## Compose 실행

방명록, Redis, nginx를 Compose로 실행했다. `docker compose ps`에서 서비스 상태를 확인했고, Redis가 준비된 뒤 웹 서비스가 시작되는 것을 확인했다. 웹 화면은 `http://localhost:8080`에서 열었다.

```bash
docker compose up -d
docker compose ps
```

## 웹 서비스 확장

web을 세 개로 늘린 뒤 nginx를 통해 접속했다. 요청을 새로 보낼 때 `Pod/Host` 이름이 바뀌어 서로 다른 web 컨테이너가 응답하는 것을 확인했다. 방명록 데이터는 Redis를 함께 사용하므로 어느 web 컨테이너로 접속해도 같은 글이 보였다.

```bash
docker compose up -d --scale web=3
```

## 데이터 유지

`docker compose down`은 컨테이너와 네트워크를 정리하지만 Redis 볼륨은 남겨 글이 유지된다. `docker compose down -v`는 볼륨까지 삭제하므로 다시 실행하면 저장했던 글도 사라진다.

## 비밀번호 파일

Compose에서 읽는 비밀번호는 `.env`에 두고 Git에는 올리지 않는다. `.env.example`에는 필요한 변수 이름과 형식만 남겼다.

## 핵심 개념을 내 말로 정리

Compose는 web·Redis·nginx를 합쳐 한 컨테이너로 만드는 도구가 아니다. 각각의 역할을 나누고 연결 관계를 `compose.yaml`에 적어 한 번에 관리하는 도구다.

- 같은 Compose 네트워크에서는 서비스 이름 `redis`를 DNS 이름으로 사용한다. IP를 코드에 고정할 필요가 없다.
- nginx만 호스트 `8080` 포트를 열고 web은 내부 `5000` 포트를 쓴다. web마다 호스트 `8080`을 열면 포트 충돌이 난다.
- `depends_on`의 `service_healthy`는 Redis가 준비된 뒤 web을 시작하게 한다. 실행 중의 모든 장애를 해결하는 기능은 아니다.
- `healthcheck`는 준비 상태를 검사하고 `restart`는 종료된 프로세스의 재시작 정책을 정한다. `unhealthy`가 되었다고 자동 재시작하는 것은 아니다.
- `.env`는 실제 설정을 담아 커밋에서 제외하고, `.env.example`은 필요한 변수 형식을 공유한다.

## 실행 전 확인

```bash
cd ~/devops/guestbook
cp .env.example .env
# .env의 REDIS_PASSWORD를 로컬 실습용 값으로 수정
docker compose config --quiet
docker compose up -d --build --scale web=3
docker compose ps
```

## 48쪽 호기심 문제

[`web=3` 유지 풀이](./web3-maintenance.md)에 원인·셸 반복문·검증 방법·한계를 정리했다. 실행 예제는 [`guestbook/keep-web3.sh`](../guestbook/keep-web3.sh)다.

## 결과 기록과 캡처

위쪽 실습 내용은 기존 README에 기록되어 있던 내용이다. 이번 문서 보완 환경에는 Docker가 없어 새 실행 결과나 healthy 화면을 생성하지 않았다. 추가 실습 시에는 `docker compose ps`의 web 세 개 상태와, nginx 경유 응답의 서로 다른 Pod/Host 화면을 실제로 캡처한다. 실행 예시를 측정 결과로 취급하지 않는다.
