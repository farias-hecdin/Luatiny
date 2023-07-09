#!/bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Module setup ----------------------------------------------------------------
set -o errexit
set -o nounset
set -o pipefail
shopt -s globstar nullglob

# Global variables
BGRED="\e[41m"
BGBLUE="\e[44m"
TXGRAY="\e[37m"
TXBLUE="\e[34m"
TXRED="\e[31m"
TXYELLOW="\e[33m"
BOLD="\e[1m"
COEND="\e[0m"
SPACE="  "
IN_DIR=$1
FILES_LIST=()
FILES_TOTAL=0


# Module config ---------------------------------------------------------------

# Find files in the directory
function fn_findFiles() {
  local FORMAT=$1
  FILES_LIST=($(find ${IN_DIR} -type f -name "${FORMAT}"))
  FILES_TOTAL=${#FILES_LIST[@]}

  echo -e "${SPACE}${TXGRAY} Searching for files..."
  echo -e "${SPACE}"

  # Empty directory
  if [[ $FILES_TOTAL == 0 ]]; then
    echo -e "${SPACE}${TXYELLOW} No ${FORMAT} files were found"
    echo -e "${SPACE}${TXYELLOW} Please make sure there are files in this directory."
    echo -e "${SPACE}"
    exit
  # File limit (by default 99 files)
  elif [[ $FILES_TOTAL -gt 99 ]]; then
    echo -e "${SPACE}${TXRED} You exceeded the 99 file limit."
    echo -e "${SPACE}"
    exit
  # Show files
  else
    for ELM in ${FILES_LIST[@]}; do
      echo -e "${SPACE}${TXBLUE}⭙${COEND} $ELM"
    done
    echo -e "${SPACE}"
    echo -e "${SPACE}${TXGRAY} There are ${FILES_TOTAL} ${FORMAT}"
  fi
  echo -e "${SPACE}"
}


# Minify files with format .lua
function fn_minifyLuaFiles() {
  local COUNTER=0

  echo -e "${SPACE}${BOLD} Do you want to minify the files? ${COEND}"
  echo -ne "${SPACE}${TXGRAY} Answer (y/n): "
  read -r RES
  echo -e "${SPACE}"

  # Start minify Lua files
  if [[ $RES == "y" ]]; then
    for ELM in ${FILES_LIST[@]}; do
      (( COUNTER += 1 ))
       echo -ne "${SPACE} ${BGBLUE} LOAD  ${COEND}${TXBLUE} Processed files ${COUNTER}/${FILES_TOTAL}${COEND}"\\r
      # Execute Luamin
      luamin -f "$ELM" > "${ELM}_tiny" || {
        echo -e "${SPACE} ${BGRED} ERROR ${COEND}${TXRED} Luamin failed for file:${COEND} ${ELM}"
      }
      wait
      sleep 0.2s
    done
    echo -e "${SPACE}\n"
    fn_replaceFiles
  # Cancel script
  elif [[ $RES == "n" ]]; then
    echo -e "${SPACE}${TXGRAY} Script canceled."
  fi
}


# Replace the files in their directories
function fn_replaceFiles() {
  local FILE_OLD=$(find ${IN_DIR} -type f -name "*.lua")
  local FILE_NEW=$(find ${IN_DIR} -type f -name "*.lua_tiny")

  echo -e "${SPACE}${BOLD} Would you like to use the minified files and replace the old files? ${COEND}"
  echo -ne "${SPACE}${TXGRAY} Answer (y/n/d): "
  read -r RES
  echo -e "${SPACE}"

  # Replace the old files
  if [[ "$RES" == "y" ]]; then
    echo -e "${SPACE}${TXGRAY} Replacing files..."
    for ELM_1 in ${FILE_OLD[@]}; do
      rm -rf "$ELM_1"
      wait
    done
    for ELM_2 in ${FILE_NEW[@]}; do
      mv "$ELM_2" "${ELM_2%%_tiny}"
      wait
    done
    echo -e "${SPACE}${TXGRAY} Operation completed."
  # Delete the minified files
  elif [[ "$RES" == "d" ]]; then
    echo -e "${SPACE}${TXGRAY} Deleting the minified files..."
    for ELM in ${FILE_NEW[@]}; do
      rm -rf "$ELM"
      wait
    done
    echo -e "${SPACE}${TXGRAY} Operation completed."
  # Cancel script
  elif [[ "$RES" == "n" ]]; then
    echo -e "${SPACE}${TXGRAY} Script canceled."
  fi
}


# Main script
function fn_main() {
  echo -e "${SPACE}"
  echo -e "${SPACE}${BOLD} **** Luatiny v0.1.6 **** ${COEND}"
  echo -e "${SPACE}"
  echo -e "${SPACE}${BOLD} What do you want to do? ${COEND}"
  echo -e "${SPACE}${SPACE}${TXGRAY} 1) Minify *.lua files"
  echo -e "${SPACE}${SPACE}${TXGRAY} 2) Replace old files"
  echo -e "${SPACE}${SPACE}${TXGRAY} 3) Exit the script"
  echo -e "${SPACE}"
  echo -ne "${SPACE}${TXGRAY} Answer: "
  read -r OPTION
  echo -e "${SPACE}"

  if [[ $OPTION == "1" ]]; then
    fn_findFiles "*.lua"
    fn_minifyLuaFiles
  elif [[ $OPTION == "2" ]]; then
    fn_findFiles "*.lua_tiny"
    fn_replaceFiles
  elif [[ $OPTION == "3" ]]; then
    echo -e "${SPACE} Exiting the script..."
  else
    echo -e "${SPACE} Invalid option."
  fi
  echo -e "${SPACE}"
  exit
}

fn_main
