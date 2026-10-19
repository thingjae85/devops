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

## Dockerfile을 내 말로 설명

| 구문 | guestbook에서 하는 일 |
|---|---|
| `FROM python:3.12-slim` | Python 실행 환경을 바탕으로 시작 |
| `WORKDIR /app` | 이후 작업할 컨테이너 내부 경로 지정 |
| `COPY requirements.txt .` | 의존성 목록부터 복사 |
| `RUN pip install ...` | 이미지를 만들 때 패키지 설치 |
| `COPY . .` | 앱 코드와 템플릿 복사 |
| `USER appuser` | 이후 앱을 일반 사용자로 실행 |
| `ENV` | 이미지의 기본 환경 변수 지정 |
| `EXPOSE 5000` | 앱이 쓰는 포트를 문서화; 호스트에 포트를 여는 기능은 아님 |
| `CMD ["python", "app.py"]` | 컨테이너가 시작할 때 실행할 기본 명령 |

`RUN`은 빌드할 때 실행되고 `CMD`는 컨테이너를 시작할 때 사용한다. 패키지 목록을 앱 코드보다 먼저 복사하면 코드만 바뀌었을 때 의존성 설치 레이어의 캐시를 재사용하기 좋다.

## 실행과 데이터에 대한 이해

```bash
docker run -d --name gb -p 8080:5000 \
  -e APP_TITLE="내 방명록" guestbook:v2
```

앱에서는 `os.environ.get()`으로 값을 읽는다. 실행할 때 넘긴 `-e APP_TITLE=...`이 이미지 기본값보다 우선한다. 이미지 태그는 버전을 구분하는 이름이며, 같은 태그를 다시 올리면 가리키는 이미지가 달라질 수 있다.

멀티 스테이지 빌드는 빌드에 필요한 파일과 실행에 필요한 파일을 나누는 방법이다. 실제 이미지 크기는 설치한 의존성과 복사한 파일에 따라 달라지므로 `docker images` 결과로 비교해야 한다.
