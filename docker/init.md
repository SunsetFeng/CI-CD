### 一、安装(CentOS7)

1. yum install -y yum-utils  // docker依赖工具
2. yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo // 阿里镜像源
3. yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin //安装
4. systemctl start docker //启动服务
5. systemctl enable docker //启动服务
6. docker --version // 检查docker
7. docker compose version // 检查docker-compose
8. sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.3.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose  // 安装docker-compose
9. sudo chmod +x /usr/local/bin/docker-compose // 设置执行权限
10. vim /etc/docker/daemon.json // 修改镜像下载源

    ```
{
  "registry-mirrors":["https://ukyyrvrh.mirror.aliyuncs.com"],  // 阿里云镜像加速地址 每个阿里云账户的都不一样
  "insecure-registries": ["http://192.168.233.131:8070"] //私有镜像仓库地址
}
    ```
11. docker login -u [username] -p [password] http://192.168.233.131:8070 // 登录私有镜像仓库
12. 修改docker.sock 文件的权限
    ```
    // /var/run 文件路径
    chown root:root docker.sock // 修改用户组
    chmod o+rw docker.sock  // 修改读写权限
    ```


