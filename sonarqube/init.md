### 一、启动sonarqube

1. 编写docker-compose.yml
2. docker compose up -d 启动服务

    - 内存太小报错:sonarqube需要262144的最大虚拟内存

      ```
      vm.max_map_count=262144  // ./etc/sysctl.conf文件内添加如下配置
      
      sysctl -p //重新加载配置
      ```

### 二、根据宿主机ip和映射端口访问sonarqube服务
1. 创建访问令牌
2. 项目内创建.properties文件并修改配置

### 三、jenkins添加配置