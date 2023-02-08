#!/bin/bash
sysctl -w net.netfilter.nf_conntrack_max=1000000
echo "net.netfilter.nf_conntrack_max=1000000" >> /etc/sysctl.conf
sysctl -w net.bridge.bridge-nf-call-iptables=1
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -w net.bridge.bridge-nf-call-ip6tables=1
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
modprobe br_netfilter
modprobe overlay
sysctl --quiet --system
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo deb http://apt.kubernetes.io/ kubernetes-xenial main >> /etc/apt/sources.list.d/kubernetes.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -yq
DEBIAN_FRONTEND=noninteractive apt-get autoclean -yq
DEBIAN_FRONTEND=noninteractive apt-get autoremove -yq
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y containerd.io
cat << EOF > /etc/containerd/config.toml
version = 2
root = "/var/lib/containerd"
state = "/run/containerd"
oom_score = 0

[grpc]
  max_recv_message_size = 16777216
  max_send_message_size = 16777216

[debug]
  level = "info"

[metrics]
  address = ""
  grpc_histogram = false

[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    [plugins."io.containerd.grpc.v1.cri".containerd]
      default_runtime_name = "runc"
      snapshotter = "overlayfs"
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
EOF
systemctl daemon-reload --no-block
systemctl restart containerd --no-block

DEBIAN_FRONTEND=noninteractive apt-get install -y kubeadm=${cluster_version} kubectl=${cluster_version} kubelet=${cluster_version}
for i in `seq 300` ; do
echo "Trying to join the K8s cluster: attempt $i ..." | systemd-cat
echo [STARTUP_DEBUG] MASTER PRIVATE IP: ${master_ip} | systemd-cat
echo [STARTUP_DEBUG] nc ${master_ip} "6443" -w 1
nc ${master_ip} "6443" -w 1 > /dev/null 2>&1
result=$?
if [ $result -eq 0 ] ; then
  echo [STARTUP_DEBUG] kubeadm join --token=${token} --discovery-token-unsafe-skip-ca-verification --node-name=$(hostname -f) ${master_ip}:6443 | systemd-cat
  kubeadm join --token=${token} --discovery-token-unsafe-skip-ca-verification --node-name=$(hostname -f) ${master_ip}:6443
  exit 0
fi
sleep 5
done
echo "Unable to join master node: timeout" >&2 | systemd-cat
exit 1