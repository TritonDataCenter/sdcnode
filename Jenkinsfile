/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/*
 * Copyright 2022 Joyent, Inc.
 */

@Library('jenkins-joylib@v1.0.8') _

pipeline {

    agent none

    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
        timestamps()
    }
    environment {
        MIN_PLATFORM_STAMP = '20181206T011455Z'
        MIN_PLATFORM_STAMP_NG = '20210826T002459Z'
    }
    stages {
        stage('build sdcnode versions') {
            when {
                triggeredBy cause: 'UserIdCause'
            }
            parallel {
                stage('1.6.3') {
                    agent {
                        node {
                            label joyCommonLabels(image_ver: '1.6.3', pkgsrc_arch: 'i386')
                        }
                    }
                    steps {
                        sh('''
./tools/build_jenkins -u fd2cc906-8938-11e3-beab-4359c665ac99 -p $MIN_PLATFORM_STAMP
        ''')
                    }
                }
                stage('sdc-minimal-multiarch-lts@15.4.1') {
                    agent {
                        node {
                            label joyCommonLabels(image_ver: '15.4.1')
                        }
                    }
                    steps {
                        sh('''
./tools/build_jenkins -u 18b094b0-eb01-11e5-80c1-175dac7ddf02 -p $MIN_PLATFORM_STAMP
        ''')
                    }
                }
                stage('minimal-64-lts 18.4.0') {
                    agent {
                        node {
                            label joyCommonLabels(image_ver: '18.4.0')
                        }
                    }
                    steps {
                        sh('''
./tools/build_jenkins -u c2c31b00-1d60-11e9-9a77-ff9f06554b0f -p $MIN_PLATFORM_STAMP
        ''')
                    }
                }
                stage('minimal-64-lts 19.4.0') {
                    agent {
                        node {
                            label joyCommonLabels(image_ver: '19.4.0')
                        }
                    }
                    steps {
                        sh('''
./tools/build_jenkins -u 5417ab20-3156-11ea-8b19-2b66f5e7a439 -p $MIN_PLATFORM_STAMP
        ''')
                    }
                }
                stage('minimal-64-lts 21.4.0') {
                    agent {
                        node {
                            label joyCommonLabels(image_ver: '19.4.0')
                        }
                    }
                    steps {
                        sh('''
./tools/build_jenkins -u a7199134-7e94-11ec-be67-db6f482136c2 -p $MIN_PLATFORM_STAMP_NG
        ''')
                    }
                }
            } // end parallel
        }
    }

    post {
        always {
            joySlackNotifications()
        }
    }
}
