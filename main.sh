#!/bin/bash
while true; do
    clear
    echo -e "\e[1;36m"
    figlet -f small "Onxx-tool"
    echo -e "\e[0m"
    echo -e "\e[1;33m1.\e[0m Install Tools"
    echo -e "\e[1;33m2.\e[0m View Errors"
    echo -e "\e[1;33m3.\e[0m Write Report"
    echo -e "\e[1;33m4.\e[0m Exit"
    read -p "Choose: " opt
    case $opt in
        1) bash install.sh ;;
        2) cat errors.txt 2>/dev/null || echo "No errors!"; read -p "Press Enter..." ;;
        3) echo "Report likho:"; read report; echo "[$(date)] $report" >> \~/gateup-reports.log; echo "Saved!"; read -p "Press Enter..." ;;
        4) exit 0 ;;
        *) echo "Galat option!"; sleep 1 ;;
    esac
done
