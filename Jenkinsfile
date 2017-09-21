pipeline {
    agent {
        label 'mikero'
    }

    stages {
        stage('Build') {
            steps {
                withCredentials([
                    file(credentialsId: 'ZLUSKEN_PRIVATE_KEY', variable: 'ZLUSKEN_PRIVATE_KEY'),
                    file(credentialsId: 'ZLUSKEN_PUBLIC_KEY', variable: 'ZLUSKEN_PUBLIC_KEY')
                ]) {
                    bat 'copy %ZLUSKEN_PRIVATE_KEY% Keys'
                    bat 'copy %ZLUSKEN_PUBLIC_KEY% Keys'
                }

                bat 'build.bat' 
                archiveArtifacts artifacts: '@zsn_surrender/**/*'
            }
            post {
                always {
                    bat 'subst p: /d > nul || exit /b 0'
                }
            }
        }
    }
}
