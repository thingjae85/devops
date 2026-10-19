# DevOps 수업 실습

리눅스·셸 스크립트·Git/GitHub·Docker 실습을 주차별로 정리한 공개 저장소입니다.

**공개 저장소:** https://github.com/thingjae85/devops

## 주차별 README

| 주차 | 주제 | 학습 기록 |
|---|---|---|
| 02 | 가상화, WSL2, 리눅스 명령과 Git | [README](./week02/README.md) |
| 03 | Ollama와 Qwen 웹 화면 | [README](./week03/qwen-web/README.md) |
| 04 | 셸 스크립트와 백업 로그 | [README](./week04/README.md) |
| 05 | Docker 실행과 포트 매핑 | [README](./week05/README.md) |
| 06 | Dockerfile, 환경 변수와 이미지 공유 | [README](./week06/README.md) |
| 07 | Compose, Redis, nginx와 healthcheck | [README](./week07/README.md) |

## 과제 항목 안내

- 저장소 링크와 공개 여부: 이 저장소의 `Public` 표시로 확인
- 최소 3개 주차 README: 위 표에서 2~7주차 기록으로 이동
- Issue부터 Merge까지: [과제 보완 Issue #2](https://github.com/thingjae85/devops/issues/2)와 이 Issue를 닫는 PR 기록 확인
- 7주차 48쪽 호기심 문제: [web=3 자동 복구 풀이](./week07/web3-maintenance.md)
- 예제 코드: [keep-web3.sh](./guestbook/keep-web3.sh)

## 실습 앱

[guestbook](./guestbook/)은 Flask 방명록이며 Redis에 데이터를 저장하고 nginx를 통해 여러 web 컨테이너에 요청을 전달합니다. 비밀번호가 담긴 `.env`는 올리지 않고 `.env.example`만 공유합니다.

기존 README의 실습 기록과 새로 제시한 재현 명령은 구분해서 적었습니다. 이번 보완 과정에서 Docker를 실제로 실행하지 못한 항목은 실행 성공 결과로 표시하지 않았습니다.
