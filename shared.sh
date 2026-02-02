#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

# Bold
BOLD='\033[1m'

# Underline
UNDERLINE='\033[4m'


# Utils

## Prints messages
psuccess() {
    echo -e "${GREEN}${BOLD}[✔] ${RESET}${1}${RESET}"
}
perror() {
    echo -e "${RED}${BOLD}[✖] ${RESET}${1}${RESET}"
}
pwarn() {
    echo -e "${YELLOW}${BOLD}[⚠] ${RESET}${1}${RESET}"
}
pinfo() {
    echo -e "${BLUE}${BOLD}[ℹ] ${RESET}${1}${RESET}"
}
