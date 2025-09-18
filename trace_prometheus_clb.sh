#!/bin/bash
# trace_prometheus_clb.sh
# End-to-end backtracking & curl tests for Prometheus behind a Classic ELB
# Usage: ./trace_prometheus_clb.sh stg-prometheus.na.internal.samsung.com monitoring prometheus-k8s

set -euo pipefail

DOMAIN=${1:-"stg-prometheus.na.internal.samsung.com"}
NAMESPACE=${2:-"monitoring"}
SERVICE=${3:-"prometheus-k8s"}
PORT=${4:-"9090"}

echo "🔎 Tracing domain: $DOMAIN"
echo "==================================================="

# 1. DNS resolution
echo "1️⃣ DNS Resolution"
dig +short $DOMAIN || nslookup $DOMAIN
LB_HOST=$(dig +short $DOMAIN | head -n1)
if [[ -z "$LB_HOST" ]]; then
  echo "❌ Domain did not resolve"
  exit 1
fi
echo "✅ CLB DNS: $LB_HOST"
echo

# 2. Curl test to CLB
echo "2️⃣ Curl Test to Classic LB ($LB_HOST)"
curl -vk --max-time 5 "https://$LB_HOST" || echo "⚠️ Curl failed"
echo

# 3. AWS CLB Info
echo "3️⃣ Classic Load Balancer Info"
aws elb describe-load-balancers --query "LoadBalancerDescriptions[?DNSName=='$LB_HOST'].{Name:LoadBalancerName,State:Scheme,DNS:DNSName,Listeners:ListenerDescriptions}" --output json || true
echo "Instance health in CLB:"
aws elb describe-instance-health --load-balancer-name <YOUR-CLB-NAME> --output table || echo "⚠️ Provide CLB name"
echo

# 4. Ingress in EKS
echo "4️⃣ Ingress Rules in namespace $NAMESPACE"
kubectl get ingress -n $NAMESPACE
kubectl describe ingress -n $NAMESPACE | grep -A5 "Host:" || true
echo "Curl test via Ingress host..."
curl -vk --max-time 5 "https://$DOMAIN" || echo "⚠️ Curl failed"
echo

# 5. Service details
echo "5️⃣ Service $SERVICE in namespace $NAMESPACE"
kubectl -n $NAMESPACE get svc $SERVICE -o wide
kubectl -n $NAMESPACE describe svc $SERVICE | grep -A5 Endpoints || true
echo

# 6. Service curl test (inside cluster)
SVC_IP=$(kubectl -n $NAMESPACE get svc $SERVICE -o jsonpath='{.spec.clusterIP}')
if [[ -n "$SVC_IP" ]]; then
  echo "Curl test to Service ClusterIP ($SVC_IP:$PORT) from inside cluster:"
  kubectl -n $NAMESPACE run curltest --rm -it --image=curlimages/curl --restart=Never -- \
    curl -s -o /dev/null -w "%{http_code}\n" "http://$SVC_IP:$PORT" || echo "⚠️ Curl failed"
fi
echo

# 7. Endpoints & Pods
echo "6️⃣ Endpoints behind $SERVICE"
kubectl get endpoints -n $NAMESPACE $SERVICE -o wide
EP_IPS=$(kubectl get endpoints -n $NAMESPACE $SERVICE -o jsonpath='{.subsets[*].addresses[*].ip}')

for ip in $EP_IPS; do
  echo "🔹 Endpoint Pod for $ip:"
  kubectl get pod -n $NAMESPACE -o wide --field-selector status.phase=Running | grep $ip || true
  echo "Curl test directly to Pod IP ($ip:$PORT) from inside cluster:"
  kubectl -n $NAMESPACE run curltest-$ip --rm -it --image=curlimages/curl --restart=Never -- \
    curl -s -o /dev/null -w "%{http_code}\n" "http://$ip:$PORT" || echo "⚠️ Curl failed"
done
echo

# 8. Pod logs
echo "7️⃣ Prometheus Pod Health"
kubectl -n $NAMESPACE get pods -l app=prometheus -o wide
for pod in $(kubectl -n $NAMESPACE get pods -l app=prometheus -o jsonpath='{.items[*].metadata.name}'); do
  echo "🔹 Checking logs for $pod"
  kubectl -n $NAMESPACE logs --tail=20 $pod | tail -n 10
done
echo

echo "==================================================="
echo "✅ Trace & curl tests completed."
echo "Follow chain: DNS → CLB (curl) → Ingress (curl) → SVC (curl) → Endpoints (curl) → Pods (logs)"