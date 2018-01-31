#!/bin/bash
if [ -n "$(env |grep '^DEPLOY_SSH_KEY')" ];then
    eval $(ssh-agent -s);
    [ -f "${DEPLOY_SSH_KEY_FILE}" ] && ssh-add "${DEPLOY_SSH_KEY_FILE}" || true;
    [ -n "${DEPLOY_SSH_KEY_BASE64}" ] && echo -n "$DEPLOY_SSH_KEY_BASE64" | base64 -d - | ssh-add - || true;
    [ -n "${DEPLOY_SSH_KEY}" ] && echo "$DEPLOY_SSH_KEY" | ssh-add - || true;
fi

if [ -z "$1" ] || [ "${1#-}" != "$1" ];then
   set -- dep  "$@"
   echo "Calling default Command: Deployer"
fi
   
exec "$@"
