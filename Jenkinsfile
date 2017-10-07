pipeline {
    agent {
        label 'mikero'
    }

    environment {
        DISCORD_WEBHOOK_URL = credentials('ZLUSKEN_DISCORD_WEBHOOK_URL')
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
                    sendNotificationToDiscord()
                }
            }
        }
    }
}

void sendNotificationToDiscord() {
    def description = "**Log:** ${BUILD_URL}console\n**Artifacts:** ${BUILD_URL}artifact/"
    def successful = currentBuild.resultIsBetterOrEqualTo('SUCCESS')
    def title = JOB_NAME

    if (env.CHANGE_TITLE) {
        title += " - ${env.CHANGE_TITLE}"
    }

    if (env.CHANGE_URL) {
        description += "\n**GitHub:** ${env.CHANGE_URL}"
    }

    discordSend description: description, link: BUILD_URL, title: title, successful: successful, webhookURL: DISCORD_WEBHOOK_URL
}
