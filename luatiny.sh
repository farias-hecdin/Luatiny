#!/bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Module setup ----------------------------------------------------------------
export PATH=$PATH:.

set -o errexit
set -o nounset
set -o pipefail
shopt -s globstar nullglob

# Global variables
BGBLUE="\e[44m"
BGRED="\e[41m"
TXBLUE="\e[34m"
TXGRAY="\e[37m"
TXRED="\e[31m"
TXYELLOW="\e[33m"
BOLD="\e[1m"
END="\e[0m"
SPACE="  "
dir_input=${1}
files_error=()
list_lua_files=()
list_minified_files=()
total_files=0

# Module config ---------------------------------------------------------------

# Find files in the directory
function fn_find_files() {
    local format_file=${1}
    list_lua_files=($(find ${dir_input} -type f -name "${format_file}"))
    total_files=${#list_lua_files[@]}

    echo -e "${SPACE}${TXGRAY} Searching for files..."
    echo -e "${SPACE}"

    # Empty directory
    if [[ ${total_files} == 0 ]]; then
        echo -e "${SPACE}${TXYELLOW} No ${format_file} files were found."
        echo -e "${SPACE}${TXYELLOW} Please make sure there are files in this directory."
        echo -e "${SPACE}"
        exit
        # File limit (by default 99 files)
    elif [[ ${total_files} -gt 199 ]]; then
        echo -e "${SPACE}${TXRED} You exceeded the 199 file limit."
        echo -e "${SPACE}"
        exit
        # Show files
    else
        for ELM in ${list_lua_files[@]}; do
            echo -e "${SPACE}${TXBLUE}⭙${END} ${ELM}"
        done
        echo -e "${SPACE}"
        echo -e "${SPACE}${TXGRAY} There are ${total_files} ${format_file}"
    fi
    echo -e "${SPACE}"
}

# Minify files with format .lua
function fn_minify_lua_files() {
    local counter=0
    local error=0

    echo -e "${SPACE}${BOLD} Do you want to minify the files? ${END}"
    echo -ne "${SPACE}${TXGRAY} Answer (y/n): "
    read -r RES
    echo -e "${SPACE}"

    # Start minify Lua files
    if [[ $RES == "y" ]]; then
        local message=""

        for ELM in ${list_lua_files[@]}; do
            ((counter += 1))
            message="${SPACE} ${BGBLUE} LOAD  ${END}${TXBLUE} Processed files ${counter}/${total_files}${END}"
            echo -ne "${message}"\\r
            # Execute Luamin
            luamin -f "${ELM}" >"${ELM}_tiny" || {
                # Error handle
                local now=$(date +'%d/%m/%Y %X')
                ((error += 1))
                echo -e "${SPACE} ${BGRED} ERROR ${END}${TXRED} Luamin failed for file:${END} ${ELM}"
                echo "[ERROR][${now}] $ELM" >>luatiny-error.log
                rm -rf "${ELM}_tiny"
            }
            wait
            sleep 0.2s
        done
        echo -e "${message}"
        echo -e "${SPACE}\n"
        list_minified_files+=$(find ${dir_input} -type f -name "*.lua_tiny")

        if [[ ${error} > 0 ]]; then
            echo -e "${SPACE} ${error} files with errors were found. Those files will not be minified."
            echo -e "${SPACE} Check ${TXYELLOW}luatiny-error.log${END} for more information.\n"
        fi
        fn_replace_files
        # Cancel script
    elif [[ $RES == "n" ]]; then
        echo -e "${SPACE}${TXGRAY} Script canceled."
    fi
}

# Replace the files in their directories
function fn_replace_files() {
    local new_files=$(find ${dir_input} -type f -name "*.lua_tiny")
    local old_files=()

    for ELM in ${list_minified_files[@]}; do
        old_files+=("${ELM%%_tiny}")
    done
    echo -e "${SPACE}${BOLD} Would you like to use the minified files and replace the old files? ${END}"
    echo -ne "${SPACE}${TXGRAY} Answer (y/n/d): "
    read -r RES
    echo -e "${SPACE}"

    # Replace the old files
    if [[ $RES == "y" ]]; then
        echo -e "${SPACE}${TXGRAY} Replacing files..."
        for ELM_A in ${old_files[@]}; do
            rm -rf "${ELM_A}"
            wait
        done
        for ELM_B in ${new_files[@]}; do
            mv "${ELM_B}" "${ELM_B%%_tiny}"
            wait
        done
        echo -e "${SPACE}${TXGRAY} Operation completed."
        # Delete the minified files
    elif [[ $RES == "d" ]]; then
        echo -e "${SPACE}${TXGRAY} Deleting the minified files..."
        for ELM in ${new_files[@]}; do
            rm -rf "$ELM"
            wait
        done
        echo -e "${SPACE}${TXGRAY} Operation completed."
        # Cancel script
    elif [[ $RES == "n" ]]; then
        echo -e "${SPACE}${TXGRAY} Script canceled."
    fi
}

# Main script
function fn_main() {
    echo -e "${SPACE}"
    echo -e "${SPACE}${BOLD} **** Luatiny v0.1.7 **** ${END}"
    echo -e "${SPACE}"
    echo -e "${SPACE}${BOLD} What do you want to do? ${END}"
    echo -e "${SPACE}${SPACE}${TXGRAY} 1) Minify *.lua files"
    echo -e "${SPACE}${SPACE}${TXGRAY} 2) Replace old files"
    echo -e "${SPACE}${SPACE}${TXGRAY} 3) Exit the script"
    echo -e "${SPACE}"
    echo -ne "${SPACE}${TXGRAY} Answer: "
    read -r OPTION
    echo -e "${SPACE}"

    if [[ $OPTION == "1" ]]; then
        fn_find_files "*.lua"
        fn_minify_lua_files
    elif [[ $OPTION == "2" ]]; then
        fn_find_files "*.lua_tiny"
        fn_replace_files
    elif [[ $OPTION == "3" ]]; then
        echo -e "${SPACE} Exiting the script..."
    else
        echo -e "${SPACE} Invalid option."
    fi
    echo -e "${SPACE}"
    exit
}

fn_main
