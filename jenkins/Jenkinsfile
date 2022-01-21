node {

   stage('Stage 1'){
      echo 'Hello there, shell scripts'
   }

   stage('Checkout'){
      git url: 'https://github.com/saisaran796/Task_DevOps.git'
   }

   stage('Permission Setting'){
      sh 'chmod +x *.sh'
   }

   stage('Build'){
      sh './job.sh'    
   }

   stage('Test'){
        parallel 'functional': {
          sh './job.sh' 
          sleep 60
        }, 'performance': {
           sh './job.sh'  // Test can seperated to different tests  ex: Integration and Qualit , Functional , Load and security
           sleep 30
        } 
     }


   stage('Aproval'){
      timeout(time:300, unit:'SECONDS') {  // DAYS , MINUTES
           input 'Do you approve deployment?'
      }
   }

   stage('Deploy'){     
      sh './job.sh'
   }
}
