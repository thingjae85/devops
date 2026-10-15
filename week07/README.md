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
