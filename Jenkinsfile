pipeline {
    agent any
    tools {
        nodejs 'node'
    }
    environment {
      harborDomain = '192.168.233.131:8070'
      dockerName = "nginx-web:$version"
      storage = "repo"
      remoteDockerName = "$harborDomain/$storage/$dockerName"
    }
    stages {
        stage('check'){
          steps {
            checkout(scm)
          }
        }
        stage('login') {
          steps {
            withCredentials([usernamePassword(credentialsId: 'harbor', passwordVariable: 'HarborPassword', usernameVariable: 'HarborName')]) {
              sh "docker login -u $HarborName -p '$HarborPassword' $harborDomain"
            }
          }
        }
        stage('scanner analysis') {
            steps {
                script {
                    scannerHome = tool 'scanner'
                }
                withSonarQubeEnv('sonar') {
                    sh "$scannerHome/bin/sonar-scanner"
                }
            }
        }
        stage('build') {
          steps {
            sh "yarn config set registry http://registry.npm.taobao.org"
            sh "yarn install"
            sh "yarn build"
          }
        }
        stage('push'){
          steps {
            sh "echo $dockerName $remoteDockerName"
            sh "docker build -t $dockerName ."
            sh "docker tag $dockerName $remoteDockerName"
            sh "docker push $remoteDockerName"
            sh "docker rmi $dockerName"
            sh "docker rmi $remoteDockerName"
          }
        }
        stage("deploy") {
          steps {
            sshPublisher(
              publishers: 
                [
                  sshPublisherDesc(
                    configName: 'server', 
                    transfers: [
                      sshTransfer(
                        cleanRemote: false,
                        excludes: '', 
                        execCommand: "/root/deploy.sh nginx-web $version", 
                        execTimeout: 120000, 
                        flatten: false, 
                        makeEmptyDirs: false, 
                        noDefaultExcludes: false, 
                        patternSeparator: '[, ]+', 
                        remoteDirectory: '', 
                        remoteDirectorySDF: false, 
                        removePrefix: '', 
                        sourceFiles: '')
                        ], 
                      usePromotionTimestamp: false, 
                      useWorkspaceInPromotion: false, 
                      verbose: false
                    )
                ]
            )
          }
        }
    }
}