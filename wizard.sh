#!/bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Module setup ----------------------------------------------------------------
set -o errexit
set -o nounset
set -o pipefail

# Global variables
ICON="\e[33m? \e[0m"
TXGRAY="\e[37m"
TXRED="\e[31m"
TXYELLOW="\e[33m"
BOLD="\e[1m"
END="\e[0m"
SPACE="  "
filename="Luatiny.sh"
repo_dir=$PWD
source_file="luatiny"
target_dir=""

# Module config ---------------------------------------------------------------

# Installer
function fn_install_script() {
    # Delete old files
    if [[ -f "${target_dir}/${source_file}" ]]; then
        echo -e "${ICON}${TXYELLOW} Deleting old files from previous installation..."
        echo -e "${SPACE}"
        rm -r "${target_dir}/${source_file}"
        wait
    fi
    # Copy files
    echo -e "${ICON}${TXGRAY} Installing: Copying files to: ${target_dir}"
    ln -s "${repo_dir}/${source_file}.sh" "${target_dir}/${source_file}"
    wait
    echo -e "${ICON}${TXGRAY} Operation completed."
}


# Desinstaller
function fn_uninstall_script() {
    # Delete files
    if [[ -f "${target_dir}/${source_file}" ]]; then
        echo -e "${ICON}${TXGRAY} Uninstalling: Deleting files..."
        rm -r "${target_dir}/${source_file}"
        wait
    else
        echo -e "${ICON}${TXRED} ${source_file} not installed."
    fi
    echo -e "${ICON}${TXGRAY} Operation completed."
}


# Main script
function fn_main() {
    echo -e "${SPACE}"
    echo -e "${ICON}${BOLD} **** Wizard (${filename}) **** ${END}"
    echo -e "${ICON}"
    echo -e "${ICON}${BOLD} What do you want to do? ${END}"
    echo -e "${ICON}${SPACE}${TXGRAY} 1) Install script"
    echo -e "${ICON}${SPACE}${TXGRAY} 2) Uninstall script"
    echo -e "${ICON}${SPACE}${TXGRAY} 3) Exit"
    echo -e "${ICON}"
    echo -ne "${ICON}${TXGRAY} Answer: "
    read -r OPTION
    echo -e "${SPACE}"

    if [[ $OPTION == 1 ]]; then
        fn_install_script
    elif [[ $OPTION == 2 ]]; then
        fn_uninstall_script
    elif [[ $OPTION == 3 ]]; then
        echo -e "${ICON}${TXGRAY} Exiting script..."
    else
        echo -e "${ICON}${TXGRAY} Invalid option."
    fi
    echo -e "${SPACE}"
    exit
}

# Change directory to "usr/bin/"
cd $HOME
trap 'echo "# There has been an error, directory \"usr/bin\" not found."' ERR
cd ../usr/bin/

target_dir=$PWD

fn_main
