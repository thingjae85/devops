# 2주차

## 오늘 배운 내용
- 가상화 (서버, 베어메탈/하이퍼바이저/컨테이너 비교)
- WSL2
- 리눅스 기본 명령어
- Git / GitHub

## 새로 배운 명령어
```bash
pwd
ls
cd
mkdir
git status
git add .
git commit -m "메시지"
git push
```

## 핵심 개념을 내 말로 정리

가상머신은 하이퍼바이저 위에서 운영체제까지 나누고, 컨테이너는 호스트 커널을 공유하면서 앱 실행 환경을 분리한다. WSL2는 Windows에서 Linux 환경을 사용할 수 있게 해 준다.

`pwd`로 현재 위치를 확인하고, `ls`로 목록을 보고, `cd`로 이동한다. `mkdir`은 디렉터리를 만든다. 상대 경로는 현재 위치를 기준으로 하므로 명령을 실행하기 전에 위치를 확인해야 한다.

Git은 파일 변경 이력을 관리하고 GitHub는 원격 저장소를 공유하는 서비스다. `git add`는 다음 커밋에 넣을 변경을 고르고, `git commit`은 로컬 이력을 남기며, `git push`는 그 이력을 원격에 올린다. 따라서 커밋만 하면 GitHub에 자동으로 올라가는 것은 아니다.

## 작업 순서

```bash
git status
git add README.md
git commit -m "docs: 학습 내용 정리"
git push
git status
```

올릴 파일을 확인한 뒤 필요한 파일만 추가한다. 비밀번호나 개인 설정은 커밋 대상에서 제외한다.
