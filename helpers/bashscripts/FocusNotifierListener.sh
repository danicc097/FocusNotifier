#!/bin/bash

FocusNotifier_VARDIR="/tmp/FocusNotifier";

while read -r FocusNotifier_line; do
    if [[ ! "$FocusNotifier_line" == "§"* ]]; then
        continue;
    fi

    FocusNotifier_value="$(echo "$FocusNotifier_line" | grep -o ": .*" | cut -c3-)";
    mkdir -p "$FocusNotifier_VARDIR";

    case "$FocusNotifier_line" in
        §pid*)
            echo "$FocusNotifier_value" > "$FocusNotifier_VARDIR/pid.txt";
            pname="$(ps -p "$FocusNotifier_value" -o comm=)";
            echo "$pname" > "$FocusNotifier_VARDIR/pname.txt";

            echo "$pname";
            echo "pid: $FocusNotifier_value";
            echo "pname: $pname";
        ;;

        §wname*)
            echo "$FocusNotifier_value" > "$FocusNotifier_VARDIR/wname.txt";
            echo "name: $FocusNotifier_value";
        ;;

        §wclass*)
            echo "$FocusNotifier_value" > "$FocusNotifier_VARDIR/wclass.txt";
            echo "class: $FocusNotifier_value";
        ;;

        §wcaption*)
            echo "$FocusNotifier_value" > "$FocusNotifier_VARDIR/wcaption.txt";
            echo "caption: $FocusNotifier_value";
        ;;

        §end)
            FocusNotifier_configdir="$HOME/.config/FocusNotifier"
            FocusNotifier_listfile="$FocusNotifier_configdir/listeners.txt"

            if [ -f $FocusNotifier_listfile ]; then
                for FocusNotifier_listener in $(cat "$FocusNotifier_listfile")
                do
                    echo "Calling listener: $FocusNotifier_listener"
                    source "$FocusNotifier_listener"
                done
            fi
        ;;
    esac
done < <(dbus-monitor "destination=scot.massie.FocusNotifier,path=/scot/massie/FocusNotifier,interface=scot.massie.FocusNotifier")
