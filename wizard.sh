#!/bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Script setup ----------------------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail

# Script definition -----------------------------------------------------------

co_bold="\e[1m"
co_gray="\e[37m"
co_red="\e[31m"
co_yellow="\e[33m"
end="\e[0m"
icon="\e[33m? \e[0m"
space="  "

# Main variables
main_directory="$HOME/.local/share"
target_directory="$HOME/.local/share/luatiny"
script_name="luatiny"


# Installer
function f_install_script() {
  if [[ -d "$target_directory" ]]; then
    # Delete old files
    echo -e "$icon$co_yellow Deleting old files from previous installation... \n"
    rm -rf "$target_directory"
  fi
  # Copy files
  echo -e "$icon$co_gray Installing: Copying files to: $main_directory"
  mkdir $script_name
  mv "$script_name" "$main_directory"
  cp "./${script_name}.sh" "$target_directory"
  ln -s "${target_directory}/${script_name}.sh" "${target_directory}/${script_name}"
  echo -e "$icon$co_gray Operation completed!"
}


# Desinstaller
function f_uninstall_script() {
  if [[ -d "$target_directory" ]]; then
    # Delete files
    echo -e "$icon$co_gray Uninstalling: Deleting files..."
    rm -rf "$target_directory"
    echo -e "$icon$co_gray Operation completed!"
  else
    echo -e "$icon$co_red $script_name not installed."
  fi
}


# Main script
function f_main() {
  echo -e "$space"
  echo -e "$icon$co_bold **** Wizard ($script_name) **** $end"
  echo -e "$icon"
  echo -e "$icon$co_bold What do you want to do? $end"
  echo -e "$icon$space$co_gray 1) Install script"
  echo -e "$icon$space$co_gray 2) Uninstall script"
  echo -e "$icon$space$co_gray 3) Exit"
  echo -e "$icon"
  echo -ne "$icon$co_gray Answer: "
  read -r option
  echo -e "$space"

  if [[ "$option" == 1 ]]; then
    f_install_script
  elif [[ "$option" == 2 ]]; then
    f_uninstall_script
  elif [[ "$option" == 3 ]]; then
    echo -e "$icon$co_gray Exiting script..."
  else
    echo -e "$icon$co_gray Invalid option."
  fi
  echo -e "$space"
  exit
}

f_main
