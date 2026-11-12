# 8주차 - Kubernetes 기초

## 클러스터 시작

Docker Desktop을 실행한 뒤 minikube 클러스터를 시작하고 노드 상태와 현재 컨텍스트를 확인합니다.

    minikube start --driver=docker
    kubectl config use-context minikube
    kubectl get nodes
    kubectl config current-context

노드가 Ready인지 확인합니다.

## 단일 Pod

    kubectl run mynginx --image=nginx
    kubectl get pods -o wide
    kubectl describe pod mynginx

직접 만든 Pod는 삭제하면 자동 복구되지 않습니다.

    kubectl delete pod mynginx
    kubectl get pods

## Deployment의 자가 복구

    kubectl create deployment mynginx --image=nginx --replicas=3
    kubectl get deployments
    kubectl get pods -l app=mynginx

Pod 하나를 삭제하고 새 Pod가 생겨 다시 3개가 되는지 관찰합니다.

    POD=$(kubectl get pods -l app=mynginx -o jsonpath='{.items[0].metadata.name}')
    kubectl delete pod "$POD"
    kubectl get pods -l app=mynginx -w

관찰을 마치려면 Ctrl+C를 누릅니다. Deployment를 정리합니다.

    kubectl delete deployment mynginx

방명록 이미지와 배포는 [6주차](../week06/README.md), [9주차](../week09/README.md), [11주차](../week11/README.md)에서 이어갑니다.
