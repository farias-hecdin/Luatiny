#!/bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Module setup ----------------------------------------------------------------
set -o errexit
set -o nounset
set -o pipefail

# Global variables
COLOR="\e[33m? \e[0m"
TXGRAY="\e[37m"
TXRED="\e[31m"
TXYELLOW="\e[33m"
BOLD="\e[1m"
COEND="\e[0m"
SPACE="  "
FILE="luatiny"
NAME="Luatiny"
# PATH: "If you are using Termux, please use this path exactly as it is written.
# Only modify it if you are not using Termux.
PATH="/data/data/com.termux/files/usr/bin"


# Module config ---------------------------------------------------------------

# Installer
function fn_installScript() {
  if [[ -f $PATH/$FILE ]]; then
    # Delete old files
    echo -e "${COLOR}${TXYELLOW} Deleting old files from previous installation..."
    echo -e "${SPACE}"
    rm -r $PATH/${FILE}
    wait
  fi
  # Copy files
  echo -e "${COLOR}${TXGRAY} Installing: Copying files to: ${PATH}"
  ln -s $(pwd)/${FILE}.sh $PATH/${FILE}
  wait
  echo -e "${COLOR}${TXGRAY} Operation completed."
}


# Desinstaller
function fn_uninstallScript() {
  if [[ -f $PATH/$FILE ]]; then
    # Delete files
    echo -e "${COLOR}${TXGRAY} Uninstalling: Deleting files..."
    rm -r $PATH/${FILE}
    wait
  else
    echo -e "${COLOR}${TXRED} ${FILE} not installed."
  fi
  echo -e "${COLOR}${TXGRAY} Operation completed."
}


# Main script
function fn_main() {
  echo -e "${SPACE}"
  echo -e "${COLOR}${BOLD} **** Wizard (${NAME}) **** ${COEND}"
  echo -e "${COLOR}"
  echo -e "${COLOR}${BOLD} What do you want to do? ${COEND}"
  echo -e "${COLOR}${SPACE}${TXGRAY} 1) Install script"
  echo -e "${COLOR}${SPACE}${TXGRAY} 2) Uninstall script"
  echo -e "${COLOR}${SPACE}${TXGRAY} 3) Exit"
  echo -e "${COLOR}"
  echo -ne "${COLOR}${TXGRAY} Answer: "
  read -r OPTION
  echo -e "${SPACE}"

  if [[ $OPTION == 1 ]]; then
    fn_installScript
  elif [[ $OPTION == 2 ]]; then
    fn_uninstallScript
  elif [[ $OPTION == 3 ]]; then
    echo -e "${COLOR}${TXGRAY} Exiting script..."
  else
    echo -e "${COLOR}${TXGRAY} Invalid option."
  fi
  echo -e "${SPACE}"
  exit
}

# Check $PATH
if [[ -d $PATH ]]; then
  fn_main
else
  echo -e "${SPACE}${TXYELLOW} Looks like there was a problem!"
  echo -e "${SPACE}${TXYELLOW} You are not running this script in Termux."
  echo -e "${SPACE}${TXYELLOW} Therefore, edit this file and change the directory path."
  exit
fi
