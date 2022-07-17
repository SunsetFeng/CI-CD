### 一、安装jenkins(docker)

1. docker pull jenkins/jenkins:lts-jdk11 // docker安装jenkins lts长期稳定版本

### 二、启动jenkins

1. 编写docker-compose.yml
2. docker compose up -d 启动服务

    - 文件权限错误:jenkins容器内部的用户id是1000 数据卷映射时,容器内部无法修改容器外的映射数据卷 因此需要更改映射文件权限

      ```
      chown -R 1000 ./data // data为映射数据卷 1000为容器内部id
      ```

### 三、根据宿主机ip和映射端口访问jenkins服务
