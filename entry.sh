#!/usr/bin/env sh
if [ "$1" = "daemon" ];  then 
    if [ ! -f "$LE_CONFIG_HOME/crontab" ]; then 
        echo "$LE_CONFIG_HOME/crontab not found, generating one" 
        time=$(date -u "+%s") 
        random_minute=$(($time % 60)) 
        random_hour=$(($time / 60 % 24)) 
        echo "$random_minute $random_hour * * * \"$LE_WORKING_DIR\"/acme.sh --cron --home \"$LE_WORKING_DIR\" --config-home \"$LE_CONFIG_HOME\"" > "$LE_CONFIG_HOME"/crontab 
    fi
    echo "Running Supercronic using crontab at $LE_CONFIG_HOME/crontab" 
    exec -- /usr/bin/supercronic "$LE_CONFIG_HOME/crontab" 
else 
    exec -- "$@"
fi