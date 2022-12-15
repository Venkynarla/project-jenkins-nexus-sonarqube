pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage ('scm checkout') {
           steps {
               git 'https://github.com/Venkynarla/project-jenkins-nexus-sonarqube.git'
           }
        }
        stage ('mvn test') {
            steps {
                sh 'mvn test'
            }
        }
        stage ('static code analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId:'sonar-jenkins') {
                    sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
        stage ('quality gate status') {
            steps {
                waitForQualityGate abortPipeline: false, credentialsId: 'sonar-jenkins'
            }
        }
        stage ('upload artifacts to nexus') {
            steps {
                script {
                    def version = readMavenPom file: 'pom.xml'
                    def nexusRepo = version.version.endsWith("SNAPSHOT") ? "demo-task-1-snapshot" : "demo-task-1"
                    nexusArtifactUploader artifacts:
                    [
                        [
                             artifactId: 'springboot',
                             classifier: '',
                             file: 'target/Uber.jar',
                             type: 'jar'
                        ]
                    ],credentialsId:'nexus-creds',
                    groupId: 'com.example',
                    nexusUrl: '44.213.58.253:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: nexusRepo,
                    version: "${version.version}"
                }
            }
        }
        stage ('docker image build') {
            steps {
                sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID venkatnarla3/$JOB_NAME:v1.$BUILD_ID'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID venkatnarla3/$JOB_NAME:latest'
            }
        }
        stage ('docker container run') {
            steps {
                sh 'docker run -itd --name=task-1 -P $JOB_NAME:v1.$BUILD_ID'
            }
        }
    }
}
