#!/bin/bash

echo "=== Helm Releases ==="
helm list --all-namespaces

echo -e "\n=== Pod Status ==="
kubectl get pods -n helm-demo

echo -e "\n=== Service Status ==="
kubectl get svc -n helm-demo

echo -e "\n=== Recent Events ==="
kubectl get events -n helm-demo --sort-by='.lastTimestamp' | tail -10
