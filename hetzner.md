https://blog.kay.sh/kubernetes-hetzner-cloud-loadbalancer-nginx-ingress-cert-manager/
https://community.hetzner.com/tutorials/install-vanilla-k8s-with-kubeadm
https://community.hetzner.com/tutorials/install-kubernetes-cluster

22.04 | 24.04

https://medium.com/@priyantha.getc/step-by-step-guide-to-creating-a-kubernetes-cluster-on-ubuntu-22-04-using-containerd-runtime-0ead53a8d273

sudo apt update
sudo apt -y full-upgrade
sudo vim /etc/modules-load.d/k8s.conf
```
overlay
br_netfilter
```
sudo modprobe overlay 
sudo modprobe br_netfilter
lsmod | grep "overlay\|br_netfilter"
sudo vim /etc/sysctl.d/k8s.conf
```
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
```
sudo sysctl --system
sudo apt-get install -y apt-transport-https ca-certificates curl gpg gnupg2 software-properties-common
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable"
sudo apt update
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo vim /etc/containerd/config.toml
`SystemdCgroup = true`
sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status containerd
sudo vim /etc/crictl.yaml
```
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: true # <- if you don't want to see debug info you can set this to false
pull-image-on-create: false
```
sudo systemctl enable kubelet
sudo kubeadm config images pull --cri-socket unix:///var/run/containerd/containerd.sock

kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=0.0.0.0 \
  --cri-socket unix:///var/run/containerd/containerd.sock \
  --upload-certs 

\
  --control-plane-endpoint=k8s-master

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule-

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

kubectl -n kube-system create secret generic hcloud \
  --from-literal=token=mMMcr1Wrn3a0LvhaQ2lp4cfu5z6Xpfd5f70mdjbqA1mruFjwYD0hc5rWPYMuM4BD \
  --from-literal=network=10078743

kubectl -n kube-system apply -f https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/download/v1.20.0/ccm-networks.yaml

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install \
    ingress-nginx ingress-nginx/ingress-nginx \
    -f ingress-nginx-values.yml \
    --namespace ingress-nginx \
    --create-namespace

helm repo add jetstack https://charts.jetstack.io --force-update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.3 \
  --set crds.enabled=true


hetzner api token
mMMcr1Wrn3a0LvhaQ2lp4cfu5z6Xpfd5f70mdjbqA1mruFjwYD0hc5rWPYMuM4BD
