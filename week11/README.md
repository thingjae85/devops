# 11주차 - 설정과 상태 점검

## ConfigMap과 Secret

ConfigMap에는 민감하지 않은 앱 설정을 둡니다.

    kubectl apply -f week11/configmap.yaml

실제 비밀번호를 파일이나 Git에 저장하지 않습니다. 클러스터에 수업용 임시값으로 Secret을 만듭니다.

    kubectl create secret generic guestbook-secret --from-literal=REDIS_PASSWORD='devops-local-only'

Secret 값은 base64 인코딩일 뿐 암호화가 아닙니다. 실제 비밀번호나 토큰을 실습 저장소에 넣지 않습니다.

## Redis와 방명록 배포

    kubectl apply -f week11/redis.yaml
    kubectl rollout status deployment/redis
    kubectl apply -f week11/deployment.yaml
    kubectl apply -f week09/service.yaml
    kubectl rollout status deployment/guestbook
    kubectl get pods,svc
    kubectl get endpoints guestbook

Redis는 ClusterIP로만 노출됩니다. 방명록은 NodePort Service로 연결합니다.

    kubectl port-forward svc/guestbook 8080:80

## 환경변수와 Redis 연결 확인

    kubectl exec deployment/guestbook -- printenv APP_TITLE THEME_COLOR REDIS_HOST REDIS_PORT
    kubectl logs -l app=guestbook --tail=50
    kubectl exec deployment/redis -- sh -c 'REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli ping'

정상 응답은 PONG입니다. Secret을 조회하면 값이 base64로 표시될 수 있습니다.

    kubectl get secret guestbook-secret -o yaml
    kubectl get secret guestbook-secret -o jsonpath='{.data.REDIS_PASSWORD}' | base64 -d

## 설정 변경과 probe

ConfigMap 변경은 기존 Pod에 자동 반영되지 않으므로 Deployment를 다시 시작합니다.

    kubectl edit configmap guestbook-config
    kubectl rollout restart deployment/guestbook
    kubectl rollout status deployment/guestbook

Readiness는 /readyz, liveness는 /healthz를 확인합니다. Readiness가 실패하면 Service가 해당 Pod로 요청을 보내지 않고, liveness가 반복해서 실패하면 컨테이너가 재시작됩니다.

    kubectl get pods -w
    kubectl describe pod <pod-name>
    kubectl logs <pod-name>
    kubectl logs <pod-name> --previous

## 트러블슈팅 순서

    kubectl get pods
    kubectl describe pod <pod-name>
    kubectl logs <pod-name>
    kubectl get events --sort-by=.lastTimestamp

정리:

    kubectl delete -f week11/
    kubectl delete -f week09/
    kubectl delete configmap guestbook-config
    kubectl delete secret guestbook-secret
