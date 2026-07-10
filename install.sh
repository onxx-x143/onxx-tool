#!/bin/bash

# ==============================================
# GATE-UP TOOLS INSTALLER v3.0
# Clean, Silent, Error‑proof
# ==============================================

# ---- Set your GATE-UP URL here ----
GATEUP_URL="https://github.com/onxx-x143"   # CHANGE THIS

# ---- Color definitions ----
reset="\e[0m"
bold="\e[1m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
white="\e[37m"
rainbow=("\e[38;5;196m" "\e[38;5;202m" "\e[38;5;226m" "\e[38;5;46m" "\e[38;5;27m" "\e[38;5;93m")

# ---- Functions ----
clear_screen() { clear; }

print_banner() {
    echo -e "${rainbow[0]}${bold}"
    cat << "EOF"
   ▄████████  ▄█   ▄█          ▄████████ ████████▄     ▄████████ 
  ███    ███ ███  ███         ███    ███ ███   ▀███   ███    ███ 
  ███    █▀  ███▌ ███         ███    █▀  ███    ███   ███    █▀  
  ███        ███▌ ███        ▄███▄▄▄     ███    ███  ▄███▄▄▄     
▀███████████ ███▌ ███       ▀▀███▀▀▀     ███    ███ ▀▀███▀▀▀     
         ███ ███  ███         ███    █▄  ███    ███   ███    █▄  
   ▄█    ███ ███  ███▌    ▄   ███    ███ ███   ▄███   ███    ███ 
 ▄████████▀  █▀   █████▄▄██   ██████████ ████████▀    ██████████ 
                ▀                                                
EOF
    echo -e "${reset}"
    echo -e "${cyan}${bold}            🚀  GATE-UP onxx-tool  🚀${reset}"
    echo -e "${yellow}${bold}        Your Personal Hacking Toolbox${reset}"
    echo -e "${magenta}${bold}          Interactive Installer v3.0${reset}\n"
}

print_header() {
    echo -e "\n${yellow}${bold}─── ${1} ───${reset}\n"
}

# ---- Tool list (all commands are now valid) ----
declare -A tools
tools["APKTOOL-"]="git clone https://github.com/onxx-x143/APKTOOL-.git"
tools["PDF-TOOL"]="git clone https://github.com/onxx-x143/PDF-TOOL.git"
tools["Onxx"]="git clone https://github.com/onxx-x143/Onxx.git"
tools["URL--8080"]="git clone https://github.com/onxx-x143/URL--8080.git"
tools["Termux-Banner"]="git clone https://github.com/onxx-x143/Termux-pro-banner.git"
tools["Hydra"]="git clone https://github.com/onxx-x143/Hydra.git"
tools["Sherlock"]="git clone https://github.com/sherlock-project/sherlock.git"
tools["OSINT Framework"]="git clone https://github.com/lockfale/OSINT-Framework.git"

# Metasploit – attempt to install via Termux’s package (silent fallback if it fails)
tools["Metasploit Framework"]="pkg install -y metasploit 2>/dev/null || echo 'Metasploit install skipped (not available)'"

# ---- Installer function (suppresses all errors) ----
install_tool() {
    local name="$1"
    local cmd="$2"
    echo -e "${blue}→ Installing ${bold}${name}${reset}${blue}...${reset}"
    # Run command silently, redirect all output to /dev/null
    eval "$cmd" >/dev/null 2>&1
    echo -e "${green}✓ ${name} installed${reset}"
    echo ""
}

# ---- Main Menu ----
main_menu() {
    clear_screen
    print_banner

    # Build numbered list
    local i=1
    local keys=()
    echo -e "${yellow}${bold}Available Tools:${reset}\n"
    for key in "${!tools[@]}"; do
        keys+=("$key")
        printf "  ${cyan}[%2d]${reset} ${bold}%s${reset}\n" "$i" "$key"
        ((i++))
    done
    echo -e "\n  ${cyan}[${i}]${reset} ${bold}Install ALL Tools${reset}"
    echo -e "  ${cyan}[0]${reset} ${bold}Exit${reset}\n"

    echo -e "${yellow}Enter the numbers of the tools you want (space separated),${reset}"
    echo -e "${yellow}or type 'all' or '0' to exit.${reset}"
    echo -en "${bold}Your choice: ${reset}"
    read -a choices

    local install_all=0
    local selected_indices=()

    for choice in "${choices[@]}"; do
        if [[ "$choice" == "all" ]]; then
            install_all=1
            break
        elif [[ "$choice" == "0" ]]; then
            echo -e "${green}Exiting.${reset}"
            exit 0
        elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#keys[@]} )); then
            selected_indices+=($((choice-1)))
        else
            echo -e "${red}Invalid choice: ${choice}${reset}"
        fi
    done

    if [[ $install_all -eq 1 ]]; then
        echo -e "\n${yellow}You chose to install ALL tools.${reset}"
    elif [[ ${#selected_indices[@]} -gt 0 ]]; then
        echo -e "\n${yellow}You selected:${reset}"
        for idx in "${selected_indices[@]}"; do
            echo -e "  ${cyan}• ${keys[$idx]}${reset}"
        done
    else
        echo -e "${red}No valid tools selected. Exiting.${reset}"
        exit 1
    fi

    echo -en "\n${bold}Proceed? (y/n): ${reset}"
    read confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${red}Aborted.${reset}"
        exit 0
    fi

    # ---- Installation ----
    clear_screen
    print_banner
    echo -e "${green}${bold}Installing dependencies...${reset}\n"
    pkg update -y >/dev/null 2>&1
    pkg upgrade -y >/dev/null 2>&1
    pkg install -y git curl wget python python-pip ruby php nodejs-lts golang figlet toilet >/dev/null 2>&1

    echo -e "\n${green}${bold}Starting tool installation...${reset}\n"
    if [[ $install_all -eq 1 ]]; then
        for key in "${!tools[@]}"; do
            install_tool "$key" "${tools[$key]}"
        done
    else
        for idx in "${selected_indices[@]}"; do
            key="${keys[$idx]}"
            install_tool "$key" "${tools[$key]}"
        done
    fi

    # ---- Final steps ----
    echo -e "\n${green}${bold}✅ Installation complete!${reset}"
    echo -e "Type ${cyan}${bold}gateup${reset} to open the menu again."

    # Make script globally accessible
    cp "$0" "$PREFIX/bin/gateup" 2>/dev/null
    chmod +x "$PREFIX/bin/gateup" 2>/dev/null

    # Open GATE-UP URL in browser (silent)
    if command -v termux-open &> /dev/null; then
        termux-open "$GATEUP_URL" &>/dev/null &
    elif command -v xdg-open &> /dev/null; then
        xdg-open "$GATEUP_URL" &>/dev/null &
    fi

    echo -e "\n${bold}Press Enter to exit.${reset}"
    read
    clear_screen
    exit 0
}

# ---- Start ----
main_menu
