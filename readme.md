The Yammer Plugin for Jenkins enables notifications to be sent to a Yammer group on the success or failure of a build.

This is an example of a successful build notification sent to the "Test" group:

![Success notification in Yammer](https://github.com/mattriley/yammer-plugin-for-jenkins/raw/master/readme/success_notification_in_yammer.png)

TODO: Provide a better example.

## Installation

The plugin is not currently listed in Jenkins, but is expected to be soon. Until then:

1. Install the ruby-runtime plugin.
2. Install the [Token Macro Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Token+Macro+Plugin). It may already be installed.
3. Download the latest Yammer Plugin .hpi file from: [http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/ruby-plugins/yammer](http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/ruby-plugins/yammer).
4. Upload the .hpi file into Jenkins from Plugin Manager > Advanced.
5. Restart Jenkins.

## Obtain an OAuth token from Yammer

The plugin requires 4 OAuth parameters: Client Key, Client Secret, Token Key, Token Secret.

See [Yammer API Documentation for OAuth](https://developer.yammer.com/api/#oauth) for more information.

TODO: Expand this section. To have this section expanded sooner, please contact: matthew-github@matthewriley.name.

## Enable a Yammer Notifications for a job

TODO: Expand this section.
