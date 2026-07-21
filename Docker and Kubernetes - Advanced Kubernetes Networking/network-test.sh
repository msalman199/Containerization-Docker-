#!/bin/bash

echo "=== Kubernetes Network Connectivity Test ==="

# Test DNS resolution
echo "1. Testing DNS resolution..."
kubectl exec deployment/app1 -- nslookup kubernetes.default.svc.cluster.local

# Test service-to-service communication
echo "2. Testing service-to-service communication..."
kubectl exec deployment/app1 -- curl -s http://app2-service/

# Test pod-to-pod communication
echo "3. Testing pod-to-pod communication..."
APP2_POD_IP=$(kubectl get pod -l app=app2 -o jsonpath='{.items[0].status.podIP}')
kubectl exec deployment/app1 -- curl -s http://$APP2_POD_IP/

# Test external connectivity (if allowed by network policies)
echo "4. Testing external connectivity..."
kubectl exec deployment/app1 -- curl -s -m 5 http://httpbin.org/ip || echo "External access blocked by network policy"

# Test ingress connectivity
echo "5. Testing ingress connectivity..."
INGRESS_URL=$(minikube service ingress-nginx-controller -n ingress-nginx --url)
curl -s $INGRESS_URL/app1 | grep -o "<title>.*</title>"

echo "=== Network test completed ==="
