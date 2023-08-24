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
files_error=()
list_lua_files=()
list_minified_files=()
total_files=0


# Display help
function f_show_help() {
  cat << EOF

  USAGE
    luatiny [directory]

  VARIABLES
    directory : You can only enter a directory
              : If no directory is specified, the current path will be selected

  FLAGS
    -h --help    : Display help
    -v --version : Display version

EOF
}


# Find files in the directory
function f_find_files() {
  local format_file=$1
  list_lua_files=($(find "$dir_input" -type f -name "$format_file"))
  total_files=${#list_lua_files[@]}

  echo -e "$space$co_gray Searching for files..."
  echo -e "$space"

  if [[ $total_files == 0 ]]; then
    # Empty directory
    echo -e "$space$co_yellow No $format_file files were found."
    echo -e "$space$co_yellow Please make sure there are files in this directory."
    echo -e "$space"
    exit
  elif [[ $total_files -gt 199 ]]; then
    # File limit (by default 199 files)
    echo -e "$space$co_red You exceeded the 199 file limit."
    echo -e "$space"
    exit
  else
    # Show files
    for elm in ${list_lua_files[@]}; do
      echo -e "$space${co_blue}*$end $elm"
    done
    echo -e "$space"
    echo -e "$space$co_gray There are $total_files $format_file"
  fi
  echo -e "$space"
}


# Minify files with format .lua
function f_minify_lua_files() {
  local counter=0
  local error=0

  echo -e "$space$co_bold Do you want to minify the files? $end"
  echo -ne "$space$co_gray Answer (y/n): "
  read -r res
  echo -e "$space"

  if [[ $res == "y" ]]; then
    # Start minify Lua files
    local message=""

    for elm in ${list_lua_files[@]}; do
      ((counter += 1))
      message="$space$bg_blue LOAD $end$co_blue Processed files ${counter}/$total_files $end"
      echo -ne "$message"\\r
      # Execute Luamin
      luamin -f "$elm" >"${elm}_tiny" ||
        {
          # Error handle
          local now=$(date +'%d/%m/%Y %X')
          ((error += 1))
          echo -e "$space$bg_red error $end$co_red luamin failed for file:$end $elm"
          echo "[ERROR][$now] $elm" >>luatiny-error.log
          rm -rf "${elm}_tiny"
        }
        wait
        sleep 0.2s
      done
      echo -e "$message"
      echo -e "$space \n"
      list_minified_files+=$(find "$dir_input" -type f -name "*.lua_tiny")

      if [[ $error > 0 ]]; then
        echo -e "$space $error files with errors were found. Those files will not be minified."
        echo -e "$space Check ${co_yellow}luatiny-error.log${end} for more information. \n"
        echo "end" >>luatiny-error.log
      fi
      f_replace_files
    elif [[ $res == "n" ]]; then
      # Cancel script
      echo -e "$space$co_gray Script canceled."
  fi
}


# Replace the files in their directories
function f_replace_files() {
  local new_files=$(find "$dir_input" -type f -name "*.lua_tiny")
  local old_files=()

  for elm in ${list_minified_files[@]}; do
    old_files+=("${elm%%_tiny}")
  done
  echo -e "$space$co_bold Would you like to use the minified files and replace the old files? $end"
  echo -ne "$space$co_gray Answer (y/n/d): "
  read -r res
  echo -e "$space"

  if [[ $res == "y" ]]; then
    # Replace the old files
    echo -e "$space$co_gray Replacing files..."
    for elm_1 in ${old_files[@]}; do
      rm -rf "$elm_1"
      wait
    done
    for elm_2 in ${new_files[@]}; do
      mv "$elm_2" "${elm_2%%_tiny}"
      wait
    done
    echo -e "$space$co_gray Operation completed!"
  elif [[ $res == "d" ]]; then
    # Delete the minified files
    echo -e "$space$co_gray Deleting the minified files..."
    for elm in ${new_files[@]}; do
      rm -rf "$elm"
      wait
    done
    echo -e "$space$co_gray Operation completed!"
  elif [[ $res == "n" ]]; then
    # Cancel script
    echo -e "$space$co_gray Script canceled."
  fi
}


# Main script
function f_main() {
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

  if [[ $option == 1 ]]; then
    f_find_files "*.lua"
    f_minify_lua_files
  elif [[ $option == 2 ]]; then
    f_find_files "*.lua_tiny"
    f_replace_files
  elif [[ $option == 3 ]]; then
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

case ${IN_OPTIONS} in
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
