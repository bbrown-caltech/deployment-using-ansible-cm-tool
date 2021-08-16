pipeline {
    agent {
        label 'caltech'
    }
    tools {
        nodejs "node"
    }
    environment {
        GIT_BASE_PATH = "deployment-using-ansible-cm-tool"
        GIT_MAVEN_PROJECT_PATH = "project01"
        NEXUS_GROUP_URL = "http://nexus:8081/repository/maven-group/"
        NEXUS_SNAPSHOT_URL = "http://nexus:8081/repository/maven-snapshots/"
        NEXUS_RELEASE_URL = "http://nexus:8081/repository/maven-releases/"
        POM_VERSION = ''
        FULL_NAME = ''
    }
    stages {
        stage('Get POM Version') {
            steps {
                POM_VERSION = sh(returnStdout: true, script: "mvn -f ./${GIT_BASE_PATH}/${GIT_MAVEN_PROJECT_PATH}/pom.xml org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.version -q -DforceStdout").trim()
                echo "Pom Version: ${POM_VERSION}"
            }
        }
        stage('Build Web App') {
            steps {
                sh "mvn -f ./${GIT_BASE_PATH}/${GIT_MAVEN_PROJECT_PATH}/pom.xml clean deploy -Dnexus.group.url=${NEXUS_GROUP_URL} -Dnexus.snapshots.url=${NEXUS_SNAPSHOT_URL} -Dnexus.release.url=${NEXUS_RELEASE_URL}"
            }
        }
        stage('Publish Changes') {
            steps {
                if ( env.POM_VERSION.contains("SNAPSHOT") ) {
                    echo "No Changes to Deploy"
                } else {
                    FULL_NAME = "${GIT_MAVEN_PROJECT_PATH}-${POM_VERSION}.war"
                    echo "Full Name: ${FULL_NAME}"
                    echo "Deploying Changes"
                }
            }
        }
    }
    
}