# 5주차 - Docker

## 실습 내용

- `docker --version`으로 Docker 설치를 확인하고 `docker run --rm hello-world`를 실행했다.
- nginx를 `web`이라는 이름으로 실행하고 `http://localhost:8080`에서 페이지를 확인했다. `curl -I` 요청도 정상 응답했다.
- `docker ps`에서 실행 중인 컨테이너를 확인했다.

## 혼자 해보기

nginx 컨테이너 세 개를 8091, 8092, 8093 포트에 각각 실행했다. 컨테이너 안의 `index.html`을 바꿔 각 페이지를 구분하고 브라우저와 `curl`로 확인했다. 실습이 끝난 뒤 `nginx1`, `nginx2`, `nginx3`, `web` 컨테이너를 정리했다.

## 핵심 개념을 내 말로 정리

이미지는 앱 실행에 필요한 파일과 설정을 담은 바탕이고, 컨테이너는 그 이미지를 실제로 실행한 인스턴스다. 같은 이미지로 컨테이너를 여러 개 만들 수 있다.

`-p 8091:80`은 호스트 8091번으로 들어온 요청을 컨테이너 80번으로 전달한다. 세 컨테이너가 내부적으로 같은 80번을 써도 각각의 공간이 나뉘어 있어 괜찮다. 반면 호스트의 같은 IP와 포트는 동시에 차지할 수 없어서 서로 다른 8091·8092·8093을 사용했다.

## 명령어 복습

```bash
docker --version
docker run --rm hello-world
docker run -d --name nginx1 -p 8091:80 nginx:alpine
docker run -d --name nginx2 -p 8092:80 nginx:alpine
docker run -d --name nginx3 -p 8093:80 nginx:alpine
docker ps
curl -I http://localhost:8091
docker logs nginx1
# 실습이 끝난 컨테이너만 정리
docker stop nginx1 nginx2 nginx3
docker rm nginx1 nginx2 nginx3
```

위 명령은 재현 예시다. `docker ps`는 실행 중인 컨테이너를, `docker ps -a`는 중지된 것까지 보여 준다. `--rm`은 실행이 끝난 컨테이너를 자동 삭제하는 옵션이다.
