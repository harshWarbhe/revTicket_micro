pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'harshwarbhe'
        PROJECT_NAME = 'revticket_microservice_micro'
        MAVEN_OPTS = '-Dmaven.repo.local=.m2/repository'
        PLATFORMS = 'linux/amd64,linux/arm64'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup Tools') {
            steps {
                sh '''
                    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                    mvn --version
                    docker --version
                '''
            }
        }
        
        stage('Build Maven Services') {
            parallel {
                stage('Build User Service') {
                    steps {
                        dir('Microservices-Backend/user-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Movie Service') {
                    steps {
                        dir('Microservices-Backend/movie-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Theater Service') {
                    steps {
                        dir('Microservices-Backend/theater-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Showtime Service') {
                    steps {
                        dir('Microservices-Backend/showtime-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Booking Service') {
                    steps {
                        dir('Microservices-Backend/booking-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Payment Service') {
                    steps {
                        dir('Microservices-Backend/payment-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Review Service') {
                    steps {
                        dir('Microservices-Backend/review-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Search Service') {
                    steps {
                        dir('Microservices-Backend/search-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Notification Service') {
                    steps {
                        dir('Microservices-Backend/notification-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Settings Service') {
                    steps {
                        dir('Microservices-Backend/settings-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build Dashboard Service') {
                    steps {
                        dir('Microservices-Backend/dashboard-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
                stage('Build API Gateway') {
                    steps {
                        dir('Microservices-Backend/api-gateway') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                mvn clean package -DskipTests
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Setup Multi-Arch Builder') {
            steps {
                sh '''
                    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                    
                    if ! docker buildx ls | grep -q multiarch-builder; then
                        docker buildx create --name multiarch-builder --platform ${PLATFORMS} --use
                        docker buildx inspect --bootstrap
                    else
                        docker buildx use multiarch-builder
                    fi
                '''
            }
        }
        
        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    '''
                }
            }
        }
        
        stage('Build & Push Multi-Arch Images') {
            parallel {
                stage('Frontend') {
                    steps {
                        dir('Frontend') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('API Gateway') {
                    steps {
                        dir('Microservices-Backend/api-gateway') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-api-gateway:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-api-gateway:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('User Service') {
                    steps {
                        dir('Microservices-Backend/user-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-user-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-user-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Movie Service') {
                    steps {
                        dir('Microservices-Backend/movie-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-movie-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-movie-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Theater Service') {
                    steps {
                        dir('Microservices-Backend/theater-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-theater-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-theater-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Showtime Service') {
                    steps {
                        dir('Microservices-Backend/showtime-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-showtime-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-showtime-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Booking Service') {
                    steps {
                        dir('Microservices-Backend/booking-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-booking-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-booking-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Payment Service') {
                    steps {
                        dir('Microservices-Backend/payment-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-payment-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-payment-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Review Service') {
                    steps {
                        dir('Microservices-Backend/review-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-review-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-review-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Search Service') {
                    steps {
                        dir('Microservices-Backend/search-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-search-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-search-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Notification Service') {
                    steps {
                        dir('Microservices-Backend/notification-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-notification-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-notification-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Settings Service') {
                    steps {
                        dir('Microservices-Backend/settings-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-settings-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-settings-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
                stage('Dashboard Service') {
                    steps {
                        dir('Microservices-Backend/dashboard-service') {
                            sh '''
                                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                                docker buildx build \
                                    --platform ${PLATFORMS} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-dashboard-service:${BUILD_NUMBER} \
                                    --tag ${DOCKER_REGISTRY}/${PROJECT_NAME}-dashboard-service:latest \
                                    --push \
                                    .
                            '''
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh '''
                export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
                docker logout || true
                docker system prune -f || true
            '''
        }
        success {
            echo 'Multi-architecture build and push successful!'
        }
        failure {
            echo 'Multi-architecture build failed!'
        }
    }
}