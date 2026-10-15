# 5주차 - Docker

## 실습 내용

- `docker --version`으로 Docker 설치를 확인하고 `docker run --rm hello-world`를 실행했다.
- nginx를 `web`이라는 이름으로 실행하고 `http://localhost:8080`에서 페이지를 확인했다. `curl -I` 요청도 정상 응답했다.
- `docker ps`에서 실행 중인 컨테이너를 확인했다.

## 혼자 해보기

nginx 컨테이너 세 개를 8091, 8092, 8093 포트에 각각 실행했다. 컨테이너 안의 `index.html`을 바꿔 각 페이지를 구분하고 브라우저와 `curl`로 확인했다. 실습이 끝난 뒤 `nginx1`, `nginx2`, `nginx3`, `web` 컨테이너를 정리했다.
