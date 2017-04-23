#!/usr/bin/bash

TELEGRAM_CHAT_ID=""
TELEGRAM_BOT_TOKEN=""
URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"

if [ "$PAM_TYPE" != "close_session" ]; then
    msg="$PAM_TTY $PAM_USER@$(hostname) from $PAM_RHOST"
    /usr/bin/curl "$URL" -d text="$msg" -d chat_id="$TELEGRAM_CHAT_ID"
fi
