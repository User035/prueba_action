#!/bin/sh -l

CLASPRC=$(cat <<-END
    {
        "token": {
            "access_token": "${{ secrets.ACCESSTOKEN }}",
            "refresh_token": "${{ secrets.REFRESHTOKEN }}",
            "scope": "https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/drive.file https://www.googleapis.com/auth/service.management https://www.googleapis.com/auth/script.deployments https://www.googleapis.com/auth/logging.read https://www.googleapis.com/auth/script.webapp.deploy https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/script.projects https://www.googleapis.com/auth/drive.metadata.readonly",
            "token_type": "Bearer",
            "id_token": "${{ secrets.IDTOKEN }}"
        },
        "oauth2ClientSettings": {
            "clientId": "${{ secrets.CLIENTID }}",
            "clientSecret": "${{ secrets.CLIENTSECRET }}",
            "redirectUri": "http://localhost"
        },
        "isLocalCreds": false
    }
END
)

echo $CLASPRC > ~/.clasprc.json

CLASP=$(cat <<-END
    {
        "scriptId": "${{ secrets.SCRIPTID }}"
    }
END
)

if [ -n "${{ secrets.ROOTDIR }}" ]; then
  if [ -e "${{ secrets.ROOTDIR }}" ]; then
    cd "${{ secrets.ROOTDIR }}"
  else
    echo "rootDir is invalid. ${{ secrets.ROOTDIR }}"
    exit 1
  fi
fi

echo $CLASP > .clasp.json
clasp open
clasp push -f
