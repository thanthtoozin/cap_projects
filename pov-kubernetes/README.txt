 # 1. create cluster
kind create cluster --config kindconfig/kindconfig-v131.yml

# 2. install metallb (system)
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml

# 3. apply YOUR metallb config
kubectl apply -f metallb/metallb-config.yaml

# 4. deploy your apps
kubectl apply -f app/