#!/bin/bash

export PATH=$PATH:/usr/local/bin

# ダミーファイルのパス
DUMMY_FILE="/home/username/tmp/minecraft_no_players.flag"

# mcrconを使ってログイン人数を取得
PLAYER_COUNT=$(mcrcon -H localhost -P 25575 -p XXX_PASSWORD_XXX -c "list" | grep -oP '(?<=There are )[0-9]+')

# プレイヤーがいない場合
if [ "$PLAYER_COUNT" -eq 0 ]; then
    # ダミーファイルが存在しない場合、ダミーファイルを作成
    if [ ! -f "$DUMMY_FILE" ]; then
        # Discord Webhook URL
        WEBHOOK_URL="Discord webhook url here"
        MESSAGE="Minecraft Server daremo imasen. If 3 minutes later same too, server will shutdown."
        # WebhookにPOSTリクエストを送信
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"$MESSAGE\"}" \
              $WEBHOOK_URL
        touch "$DUMMY_FILE"
    else
        rm "$DUMMY_FILE"
	/home/username/scripts/shutdown.sh
    fi
# プレイヤーがいる場合
else
    # ダミーファイルが存在する場合、削除
    if [ -f "$DUMMY_FILE" ]; then
        rm "$DUMMY_FILE"
    fi
fi

