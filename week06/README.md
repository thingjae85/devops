# 6주차 - Dockerfile

## 방명록 이미지 만들기

`guestbook/`을 빌드해 컨테이너로 실행했다. 제목과 테마 값을 바꾸고, 템플릿의 문구와 화면도 수정해 v2 이미지를 만들었다. 이미지를 GitHub Container Registry에 올린 뒤 다시 받아 실행했다. 친구가 공유한 이미지도 실행해 서로 다른 이미지가 동작하는 것을 확인했다.

```bash
cd ~/devops/guestbook
docker build -t guestbook:v2 .
docker tag guestbook:v2 ghcr.io/thingjae85/guestbook:v2
docker push ghcr.io/thingjae85/guestbook:v2
docker pull ghcr.io/thingjae85/guestbook:v2
```

실행할 때 `-e`로 환경 변수를 넘겨 Dockerfile에 넣어 둔 값과 어떻게 달라지는지 확인했다. 코드의 기본값, Dockerfile의 `ENV`, `docker run -e`는 각각 코드 수정, 이미지 빌드, 컨테이너 실행 시점에 적용된다. 실행 옵션으로 지정한 값이 우선한다.

`Dockerfile.multistage`로도 빌드해 일반 이미지와 크기를 비교했다.
