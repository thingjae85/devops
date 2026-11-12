# 9주차 - Deployment와 Service

저장소 루트에서 실행합니다.

## YAML로 배포하기

    kubectl apply -f week09/deployment.yaml --dry-run=server
    kubectl apply -f week09/deployment.yaml
    kubectl get deployments,replicasets,pods -l app=guestbook
    kubectl get pods --show-labels

Deployment의 selector와 Pod template의 label이 app: guestbook으로 일치해야 합니다.

## Service로 연결하기

    kubectl apply -f week09/service.yaml
    kubectl get svc guestbook
    kubectl describe svc guestbook
    kubectl get endpoints guestbook

Service는 label selector로 방명록 Pod를 찾습니다. port-forward를 실행한 채 브라우저에서 http://localhost:8080 을 엽니다.

    kubectl port-forward svc/guestbook 8080:80

## 스케일링과 롤링 업데이트

    kubectl scale deployment guestbook --replicas=4
    kubectl rollout status deployment/guestbook
    kubectl get pods -l app=guestbook -w

새 이미지를 빌드하고 GHCR에 올린 뒤 배포 이미지를 바꿉니다.

    docker build -t guestbook:v3 ./guestbook
    docker tag guestbook:v3 ghcr.io/thingjae85/guestbook:v3
    docker push ghcr.io/thingjae85/guestbook:v3
    kubectl set image deployment/guestbook web=ghcr.io/thingjae85/guestbook:v3
    kubectl rollout status deployment/guestbook
    kubectl rollout history deployment/guestbook

    kubectl rollout undo deployment/guestbook
    kubectl rollout status deployment/guestbook

GHCR 패키지의 공개 여부를 확인합니다. 비공개 패키지라면 토큰을 저장소에 넣지 말고 Kubernetes imagePullSecret을 사용합니다.

정리:

    kubectl delete -f week09/
