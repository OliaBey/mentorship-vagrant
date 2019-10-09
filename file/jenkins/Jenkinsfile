pipeline {
    agent any
    stages {
        stage('Get code') { // Get some code from a GitHub repository
	    steps {
      		git 'https://github.com/OliaBey/spring-petclinic.git'
	    }
        }
    stage('Maven package') { // Run the maven build
 	    steps {
      		sh label: '', script: "/usr/local/src/apache-maven/bin/mvn -Dmaven.test.failure.ignore clean package"
            }
    }

  }
}