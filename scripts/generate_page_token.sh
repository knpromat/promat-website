#!/bin/bash
# user musi mieć:
# - pages_read_engagement
# - pages_read_user_content

if [[ -v APP_ID ]]; then
    echo "- [X] APP_ID is defined"
else
    echo "- [ ] Please app ID and assign APP_ID variable."
    exit 1
fi

if [[ -v APP_SECRET ]]; then
    echo "- [X] APP_SECRET is defined"
else
    echo "- [ ] Please app ID and assign APP_SECRET variable."
    exit 1
fi


if [[ -v USER_TOKEN ]]; then
    echo "- [X] USER_TOKEN is defined"
else
    echo "- [ ] Please obtain a valid token and assign USER_TOKEN variable."
    echo "- [ ] Visit https://developers.facebook.com/tools/explorer/ for token generation."
    exit 1
fi

echo "- [X] Everything OK. Getting new token."

APP_TOKEN=`curl -G \
  -d "grant_type=fb_exchange_token" \
  -d "client_id=$APP_ID" \
  -d "client_secret=$APP_SECRET" \
  -d "fb_exchange_token=$USER_TOKEN" \
  "https://graph.facebook.com/v23.0/oauth/access_token" |jq '.access_token' |tr -d '"'`

if [[ "$?" != "0" ]]; then
    echo "- [ ] Unable to get new APP_TOKEN. See lok above"
else
    echo "- [X] New APP_TOKEN obtained]"
fi

# try to get page token
response=`curl -G \
        -d "access_token=$APP_TOKEN" \
        https://graph.facebook.com/v23.0/me/accounts`

if [[ "$?" != "0" ]]; then
    echo "- [ ] Unable to receive PAGE_TOKEN"
else
    echo "- [X] New APP_TOKEN obtained]"
fi

PAGE_TOKEN=`echo $response | jq -r '.data[0].access_token'`
TOKEN_INFO=$(curl -G \
        -d "access_token=$APP_TOKEN" \
        -d "input_token=$PAGE_TOKEN" \
        "https://graph.facebook.com/v23.0/debug_token")

echo "- [X] Token for App: $(echo $TOKEN_INFO | jq .data.application)"
echo "- [X] Token Expires: $(date -d @$(echo $TOKEN_INFO | jq .data.data_access_expires_at))"
echo "- [X] Here is your PAGE_TOKEN. Save it and DO NOT show it to anyone!"
echo $PAGE_TOKEN
