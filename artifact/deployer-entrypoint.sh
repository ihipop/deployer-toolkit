#!/bin/bash
#ls -la "${DEPLOY_SSH_KEY_FILE}" 
[ -f "${DEPLOY_SSH_KEY_FILE}" ] && \
eval $(ssh-agent -s) && \
cat "${DEPLOY_SSH_KEY_FILE}" | ssh-add -;
/usr/local/bin/deployer "$@"