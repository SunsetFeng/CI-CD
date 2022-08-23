# 一、固定ip地址(wifi虚拟机使用)
```
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.233.140
NETMASK=255.255.255.0
GATEWAY=192.168.233.1
DNS1=114.114.114.114
DNS2=8.8.8.8
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

tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz // 解压cni插件  下载地址https://github.com/containernetworking/plugins/releases
```