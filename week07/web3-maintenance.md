# 48쪽 호기심 문제 - web=3을 유지하는 방법

## 내 답

`web=3`을 한 번 실행하는 것과 계속 유지하는 것은 다르다. 수업에서 배운 셸 반복문으로 원하는 개수 3을 주기적으로 다시 적용하면 된다. 사람이 매번 복구 명령을 입력하던 일을 반복문이 대신한다.

## 왜 두 개만 남는가?

강의자료 48쪽에서는 `docker stop guestbook-web-2`로 하나를 직접 중지한다. `restart: unless-stopped`는 이 수동 중지를 존중하므로 곧바로 다시 켜지 않는다. `restart: always`로 바꾸어도 수동 중지 직후 자동 복구하는 답이 되지는 않는다. 수동 중지 시에는 그 컨테이너를 직접 시작하거나 Docker 데몬이 재시작되는 등 정책 조건이 달라져야 한다.

`docker compose up -d --scale web=3`은 호출된 시점에 원하는 개수로 맞추는 명령이다. 명령이 끝난 뒤 Compose CLI가 계속 남아서 개수를 감시하는 것은 아니다.

## 현재 배운 도구로 구현

먼저 기존 `guestbook/compose.yaml`과 `.env`로 전체 서비스를 준비한다. web의 호스트 포트 매핑은 없애고 nginx만 `8080:80`을 공개한다. web에 고정 `container_name`을 지정하지 않아야 복제본을 늘릴 수 있다.

```bash
cd ~/devops/guestbook
cp .env.example .env
# .env의 비밀번호를 로컬 실습용 값으로 수정
docker compose config --quiet
docker compose up -d --build --scale web=3
bash keep-web3.sh
```

`keep-web3.sh`의 핵심은 다음과 같다.

```bash
while :; do
  if ! docker compose up -d --no-deps --no-build --no-recreate --scale web=3 web; then
    echo "복구 실패: 5초 뒤 재시도" >&2
  fi
  sleep 5
done
```

- `while :`는 종료할 때까지 반복한다.
- `up`은 이미 존재하지만 중지된 컨테이너를 시작하고, 없는 컨테이너는 생성한다.
- `--scale web=3`은 web의 목표 개수를 3으로 맞춘다. 4개라면 줄이는 방향도 적용한다.
- `--no-recreate`는 기존 컨테이너를 설정 변경 때문에 다시 만들지 않게 한다. 중지된 컨테이너의 시작을 막는 옵션은 아니다.
- `--no-build`는 반복 중 이미지 빌드를 막는다. 이미지는 처음에 미리 빌드한다.
- `--no-deps`로 Redis 등 의존 서비스의 시작을 반복 제어하지 않는다. 처음 전체 서비스를 정상적으로 준비해야 한다.
- `sleep 5`는 과도한 반복 호출을 피한다. 명령 실행 시간에 더해 최대 약 5초의 다음 점검 대기가 생긴다.

스크립트는 같은 프로젝트에 한 개만 실행한다. 종료는 `Ctrl+C`로 하며, 점검 스크립트가 종료되어도 백그라운드 컨테이너는 계속 실행된다. 스크립트 실행 중에는 수동 중지도 다음 반복에 복구되므로, 의도적으로 점검하려면 먼저 스크립트를 종료한다.

## 의사코드

```text
목표 개수 = 3
반복:
    Compose에 web의 목표 개수 3을 적용한다
    중지되었으면 시작하고, 삭제되었으면 생성한다
    3개보다 많으면 3개로 줄인다
    실패하면 오류를 남긴다
    5초 기다린다
```

## 직접 확인할 절차

다음은 검증 절차이며 실행 결과를 조작해 적은 것이 아니다. 이 자료를 작성한 환경에는 Docker가 없어 실제 컨테이너 검증은 수행하지 않았다.

```bash
# 터미널 A: 감시 실행
cd ~/devops/guestbook
bash keep-web3.sh

# 터미널 B: 중지할 web 하나를 현재 프로젝트에서 선택
cd ~/devops/guestbook
victim=$(docker compose ps --status running -q web | head -n 1)
[ -n "$victim" ] && docker stop "$victim"
# 점검 주기 + 기동 시간을 기다린 뒤 확인
docker compose ps web
docker compose ps --status running -q web | wc -l
# 기대: 최종 실행 개수 3. 즉시 3개로 유지되는 것은 아님.

# 삭제 상황도 확인: web 하나만 삭제; Redis와 볼륨은 건드리지 않는다
victim=$(docker compose ps --status running -q web | head -n 1)
[ -n "$victim" ] && docker rm -f "$victim"
# 잠시 후 다시 ps로 3개인지 확인
```

기록할 항목: 중지 직후 실행 개수, 복구 후 실행 개수, 정상 상태까지 걸린 시간, `/readyz` 결과. 생성 직후에는 `starting`일 수 있어 실행 개수 3과 `healthy` 3개를 구분한다. nginx DNS 캐시와 기동 시간 때문에 잠깐 502가 날 수 있으므로 무중단을 보장한다고 쓰지 않는다.

## 보장 범위와 한계

여기서 “항상 유지”는 장애 후 목표 상태로 자동으로 되돌린다는 뜻이다. 고장 나는 순간까지 한 치의 공백도 없이 정상 web 3개를 보장하는 것은 아니다.

이 예제는 **개수 복구**를 다룬다. 프로세스가 실행 중인 채 `unhealthy`가 된 컨테이너는 `up`만으로 고쳐지지 않는다. 이를 다루려면 상태를 검사해 해당 web만 재시작하고, 일정 시간 후 재검사하며 반복 실패를 알리는 절차가 더 필요하다. Redis 장애로 web 전체가 불건강해졌다면 web만 계속 재시작하지 말고 Redis 원인부터 해결해야 한다.

호스트, Docker 엔진, 감시 스크립트가 꺼지거나 이미지 빌드·앱 자체가 실패하면 이 루프만으로 정상 3개를 보장할 수 없다. 장기간 실행하려면 호스트의 서비스 관리자로 스크립트를 관리해야 하고, 여러 서버에 걸친 장애 복구는 Kubernetes 등의 오케스트레이터가 필요한 다음 단계다.

## 참고

- 수업자료 「07. 도커 컴포즈」 42~48쪽, 52쪽
- [Docker 재시작 정책과 수동 중지 예외](https://docs.docker.com/engine/containers/start-containers-automatically/)
- [Compose up과 --scale 옵션](https://docs.docker.com/reference/cli/docker/compose/up/)
- [Compose healthcheck](https://docs.docker.com/reference/compose-file/services/#healthcheck)
