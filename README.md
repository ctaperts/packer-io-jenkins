# Packer io set up of jenkins

Will setup a jenkins ci server without having to go through wizard

## Notes
Couple of waits due to jenkins being set up initially

## Plugins Included

- cloudbees-folder
- github-api
- antisamy-markup-formatter
- build-timeout
- credentials-binding
- timestamper
- ws-cleanup
- ant
- gradle
- workflow-aggregator
- github-branch-source
- pipeline-github-lib
- pipeline-stage-view
- git
- subversion
- ssh-slaves
- matrix-auth
- email-ext
- mailer

## Setup

Create a file named `secrets.json` with the following content
```
{
  "secret_api_token": "change_me",
  "image_region": "nyc3",
  "jenkins_username": "change_me_username",
  "jenkins_password": "change_me_password"
}
```

Run using
```
packer-io build -var-file=secrets.json do-jenkins.json
```

