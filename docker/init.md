### 一、安装(CentOS7)

1. yum install -y yum-utils  // docker依赖工具
2. yum-config-manager --add-repo <http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo> // 阿里镜像源
3. yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin //安装
4. systemctl start docker //启动服务
5. systemctl enable docker //启动服务
6. docker --version // 检查docker
7. docker compose version // 检查docker-compose
8. vim /etc/docker/daemon.json // 修改镜像下载源

    ```
    {
      "registry-mirrors":["https://ukyyrvrh.mirror.aliyuncs.com"]  // 阿里云镜像加速 每个阿里云账户的都不一样
    }
    ```
