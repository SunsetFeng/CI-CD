# 一、固定ip地址(wifi虚拟机使用)

```
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.233.140
NETMASK=255.255.255.0
GATEWAY=192.168.233.2
```

# 二、关闭swap

```
swapoff -a
vim /etc/fstab //注释swap行
reboot
free -h
```

# 三、设置桥接流量模块

```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
```

# 四、修改内核命令，使用CGroup2

```
grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=1"
```

# 五、安装容器运行时

```
tar Cxzvf /usr/local containerd-1.6.2-linux-amd64.tar.gz // 解压containerd包 下载地址https://github.com/containerd/containerd/releases

拷贝https://github.com/containerd/containerd/blob/main/containerd.service内容到/usr/local/lib/systemd/system/containerd.service 启用containerd服务
systemctl daemon-reload
systemctl enable --now containerd

install -m 755 runc.amd64 /usr/local/sbin/runc // 运行runc 下载地址https://github.com/opencontainers/runc/releases

mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz // 解压cni插件  下载地址https://github.com/containernetworking/plugins/releases

// 配置容器
containerd config default > /etc/containerd/config.toml
sandbox_image = "registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.6"
SystemdCgroup = true
```

# 六、关闭防火墙

```
systemctl stop firewalld.service 
systemctl disable firewalld.service 
```

# 七、安装kubeadm,kubelet,kubectl

```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet
systemctl enable kubelet && systemctl start kubelet

ps: 由于官网未开放同步方式, 可能会有索引gpg检查失败的情况, 这时请用 yum install -y --nogpgcheck kubelet 安装

```
# 八、修改主机名
```
hostnamectl set-hostname your-new-host-name
# 查看修改结果
hostnamectl status
# 设置 hostname 解析
echo "127.0.0.1   $(hostname)" >> /etc/hosts
```

# 九、安装控制面
```
kubeadm init --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16

//查看discovery-token-ca-cert-hash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

//查看token
kubeadm token list
//创建token
kubeadm create token

kubeadm join --token 67koez.usgl1t7hgpdyq1rc 192.168.233.141:6443 --discovery-token-ca-cert-hash sha256:99245f5062bd1124e4bf52453fbc17d5d3df06a6d17e9aa8d747942d67f9cd74
```
