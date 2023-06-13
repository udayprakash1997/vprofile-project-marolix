pipeline{

agent any

tools{
maven "maven"

}

	environment {
	credentials = 'ecr:us-east-1:aws-credentials'
	url = "https://327575778641.dkr.ecr.us-east-1.amazonaws.com"
	imagename = "327575778641.dkr.ecr.us-east-1.amazonaws.com/uday-ecr-repo"
	cluster = "uday-cluster"
        service = "ecs"
    }
/*
triggers{
pollSCM('* * * * *')
}

options{
timestamps()
buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '5', daysToKeepStr: '', numToKeepStr: '5'))
}
*/
stages{

  stage('CheckOutCode'){
    steps{
    git 'https://github.com/udayprakash1997/vprofile-project-marolix.git'
	}
  }
  
  stage('Build'){
  steps{
  sh  "mvn clean package"
  }
  }

  stage('ExecuteSonarQubeReport'){
  steps{
  sh  "mvn clean package sonar:sonar"
  }
  }

  stage('UploadArtifactsIntoNexus'){
  steps{
  sh  "mvn clean deploy"
  }
  }

  stage('DeployAppIntoTomcat'){
  steps{
  sshagent(['a0f49bd7-1701-4818-83e2-2d7bc77b8615']) {
   sh "scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/vprofile/target/vprofile-v2.war ec2-user@44.201.193.92:/opt/tomcat/webapps/"    
  }
  }
  }

/*
 stage('Build Docker Image') {
  steps {
    sh 'docker build -t imagename1 .'
  }
}

 stage('Run Docker Container') {
  steps {
    sh 'docker run -itd -p 89:8080 --name cont1 imagename1'
  }
}
*/

	 stage('build docker image') {
	       steps {
	         script  {
	            dockerImage =docker.build(imagename)
	         }
	       }
	 }	  
	    stage('upload to ecr') {
	    steps {
	        script {
	          docker.withRegistry(url,credentials) {   
	          dockerImage.push("$BUILD_NUMBER")
	          dockerImage.push('latest') }
	        
	        }

	    }
	  }
	/*
	  stage('Deploy to ecs') {
          steps {
          withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
          sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
        }
      }
     }
     */
	stage('Send EMAIL Notification'){
		steps{
		emailext body: '''The build is completed!!

       Regards,
       Uday.
       ''', subject: 'build is success', to: 'udaya.marolix@gmail.com'
}
}				
}
}
