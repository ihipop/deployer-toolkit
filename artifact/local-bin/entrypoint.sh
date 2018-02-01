#!/bin/bash
if [ -n "$(env |grep '^DEPLOY_SSH_KEY')" ];then
    echo "Calling SSH Agent"
    eval $(ssh-agent -s);
    [ -f "${DEPLOY_SSH_KEY_FILE}" ] && ssh-add "${DEPLOY_SSH_KEY_FILE}" || true;
    [ -n "${DEPLOY_SSH_KEY_BASE64}" ] && echo -n "$DEPLOY_SSH_KEY_BASE64" | base64 -d - | ssh-add - || true;
    [ -n "${DEPLOY_SSH_KEY}" ] && echo "$DEPLOY_SSH_KEY" | ssh-add - || true;
fi

if [ -f "/ssh/config" ];then
    echo "Dispatching SSH Keys"
    cp -rf /ssh/* $HOME/.ssh
    chmod 600 -R $HOME/.ssh/
fi


if [ -z "$1" ] || [ "${1#-}" != "$1" ];then
   set -- dep  "$@"
   echo "Calling default Command: Deployer"
fi
   
exec "$@"
