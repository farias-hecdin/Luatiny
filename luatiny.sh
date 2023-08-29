#!/bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Script setup ----------------------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail
shopt -s globstar nullglob

# Script definition -----------------------------------------------------------

bg_blue="\e[44m"
bg_red="\e[41m"
co_blue="\e[34m"
co_gray="\e[37m"
co_red="\e[31m"
co_yellow="\e[33m"
co_bold="\e[1m"
end="\e[0m"
space="  "

# Main variables
list_lua_files=()
list_minified_files=()
total_files=0

# Display help
function f_show_help() {
  cat << EOF

  USAGE
    luatiny [directory]

  VARIABLES
    directory : You can only enter a directory.
              : If no directory is specified, the current path will be selected.
  FLAGS
    -h --help    : Display help.
    -v --version : Display version.

EOF
}

# Check if the dependencies are installed
function f_check_dependencies() {
  if ! [[ $(command -v luamin) ]]; then
    echo "Luamin is not installed"
    exit
  fi
}

# Find files in the directory
function f_find_files() {
  local format_file=$1
  list_lua_files=($(find "$dir_input" -type f -name "$format_file"))
  total_files=${#list_lua_files[@]}

  echo -e "$space$co_gray Searching for files... \n"

  if (( total_files == 0 )); then
    # Empty directory
    echo -e "$space$co_yellow No $format_file files were found."
    echo -e "$space$co_yellow Please make sure there are files in this directory. \n"
    exit
  elif (( total_files > 199 )); then
    # File limit (by default 199 files)
    echo -e "$space$co_red You exceeded the 199 file limit. \n"
    exit
  else
    # Show files
    for elem in "${list_lua_files[@]}"; do
      echo -e "$space${co_blue}*$end $elem"
    done
    echo -e "$space"
    echo -e "$space$co_gray There are $total_files $format_file \n"
  fi
}

# Minify files with format .lua
function f_minify_lua_files() {
  local counter_files=0
  local counter_error=0

  echo -e "$space$co_bold Do you want to minify the files? $end"
  echo -ne "$space$co_gray Answer (y/n): "
  read -r res
  echo -e "$space"

  if [[ "$res" == "y" ]]; then
    # Start minify Lua files
    local message=""

    for elem in "${list_lua_files[@]}"; do
      ((counter_files += 1))
      message="$space$bg_blue LOAD  $end$co_blue Processed files ${counter_files}/$total_files $end"
      echo -ne "$message" \\r
      # Execute Luamin
      luamin -f "$elem" >"${elem}_tiny" ||
        {
          # Error handle
          local now
          now=$(date +'%d/%m/%Y %X')
          ((counter_error += 1))
          echo -e "$space$bg_red ERROR $end$co_red luamin failed for file:$end $elem"
          echo "[ERROR][$now] $elem" >> luatiny-error.log
          rm -rf "${elem}_tiny"
        }
      wait
      sleep 0.2s
    done
    echo -e "$message"
    echo -e "$space \n"
    list_minified_files+=($(find "$dir_input" -type f -name "*.lua_tiny"))

    if (( counter_error > 0 )); then
      echo -e "$space $counter_error files with errors were found. Those files will not be minified."
      echo -e "$space Check ${co_yellow}luatiny-error.log ${end}for more information. \n"
      echo "end" >> luatiny-error.log
    fi
    f_replace_files
  else
    # Cancel script
    echo -e "$space$co_gray Script canceled."
  fi
}

# Replace the files in their directories
function f_replace_files() {
  local new_files=($(find "$dir_input" -type f -name "*.lua_tiny"))
  local old_files=()

  for elem in "${list_minified_files[@]}"; do
    old_files+=("${elem%%_tiny}")
  done
  echo -e "$space$co_bold Would you like to use the minified files and replace the old files? $end"
  echo -ne "$space$co_gray Answer (y/n/d): "
  read -r res
  echo -e "$space"

  if [[ "$res" == "y" ]]; then
    # Replace the old files
    echo -e "$space$co_gray Replacing files..."
    for elem_1 in "${old_files[@]}"; do
      rm -rf "$elem_1"
    done
    for elem_2 in "${new_files[@]}"; do
      mv "$elem_2" "${elem_2%%_tiny}"
    done
    echo -e "$space$co_gray Operation completed!"
  elif [[ "$res" == "d" ]]; then
    # Delete the minified files
    echo -e "$space$co_gray Deleting the minified files..."
    for elem in "${new_files[@]}"; do
      rm -rf "$elem"
    done
    echo -e "$space$co_gray Operation completed!"
  else
    # Cancel script
    echo -e "$space$co_gray Script canceled."
  fi
}

# Main script
function f_main() {
  f_check_dependencies

  echo -e "$space"
  echo -e "$space$co_bold **** Luatiny **** $end"
  echo -e "$space"
  echo -e "$space$co_bold What do you want to do? $end"
  echo -e "$space$space$co_gray 1) Minify *.lua files"
  echo -e "$space$space$co_gray 2) Replace old files"
  echo -e "$space$space$co_gray 3) Exit the script"
  echo -e "$space"
  echo -ne "$space$co_gray Answer: "
  read -r option
  echo -e "$space"

  if [[ "$option" == 1 ]]; then
    f_find_files "*.lua"
    f_minify_lua_files
  elif [[ "$option" == 2 ]]; then
    f_find_files "*.lua_tiny"
    f_replace_files
  elif [[ "$option" == 3 ]]; then
    echo -e "$space Exiting the script..."
  else
    echo -e "$space Invalid option."
  fi
  echo -e "$space"
  exit
}

# Init
if [ $# -gt 1 ]; then
  echo "The script only accepts one parameter. (see --help)"
  exit
fi

IN_OPTIONS=${1:-"."}

case "$IN_OPTIONS" in
  --help|-h)
    f_show_help
    ;;
  --version|-v)
    echo "v0.1.8"
    ;;
  *)
    dir_input=${IN_OPTIONS}
    f_main
    ;;
esac
