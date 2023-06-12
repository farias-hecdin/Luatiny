#! /bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Module setup ================================================================
set -o errexit
set -o nounset
set -o pipefail
shopt -s globstar nullglob

# Global variables
COLOR="\e[34m# \e[0m"
SPACE="  "
IN_DIR=$1
FILES_LIST=()
FILES_TOTAL=0


# Module config ===============================================================

# Find files in the directory
function f_findFiles() {
  local FORMAT=$1
  FILES_LIST=($(find ${IN_DIR} -type f -name "${FORMAT}"))
  FILES_TOTAL=${#FILES_LIST[@]}

  echo -e "${COLOR} Buscando archivos..."
  echo -e "${SPACE}"

  # Empty directory
  if [[ $FILES_TOTAL == 0 ]]; then
    echo -e "${COLOR} No se han encontrado archivos ${FORMAT}"
    echo -e "${COLOR} Por favor, asegúrate de que haya archivos en este directorio."
    echo -e "${SPACE}"
    exit
  # File limit (by default 99 files)
  elif [[ $FILES_TOTAL -gt 99 ]]; then
    echo -e "${COLOR} Excediste el limite de 99 archivos."
    echo -e "${SPACE}"
    exit
  # Show files
  else
    for ELM in ${FILES_LIST[@]}; do
      echo -e "${SPACE} $ELM"
    done
    echo -e "${SPACE}"
    echo -e "${COLOR} Hay ${FILES_TOTAL} archivos ${FORMAT}"
  fi
  echo -e "${COLOR}"
}


# Minify files with format .lua
function f_minifyLuaFiles() {
  local COUNTER=0

  echo -e "${COLOR} ¿Quieres minificar los archivos?"
  echo -ne "${COLOR} respuesta (y/n): "
  read -r RES
  echo -e "${SPACE}"

  # Start minify Lua files
  if [[ $RES == "y" ]]; then
    for ELM in ${FILES_LIST[@]}; do
      (( COUNTER += 1 ))
      printf "%b" "${SPACE} (${COUNTER}/${FILES_TOTAL}) --- $ELM "
      # Execute Luamin
      luamin -f "$ELM" > "${ELM}_"
      wait
      # File status
      if [[ $? == "0" ]]; then
        printf "%b" "\e[32m ✔ \e[0m \n"
      fi
    done
    echo -e "${SPACE}"
    f_replaceFiles
  # Cancel script
  elif [[ $RES == "n" ]]; then
    echo -e "${COLOR} Operación cancelada."
  fi
}


# Replace the files in their directories
function f_replaceFiles() {
  local FILE_OLD=$(find ${IN_DIR} -type f -name "*.lua")
  local FILE_NEW=$(find ${IN_DIR} -type f -name "*.lua_")
  # local TOTAL=${#FILE_OLD[@]}

  echo -e "${COLOR} ¿Quieres utilizar los archivos minificados y sustituir los antiguos archivos?"
  echo -ne "${COLOR} respuesta (y/n/d): "
  read -r RES
  echo -e "${SPACE}"

  # Replace the files
  if [[ "$RES" == "y" ]]; then
    echo -e "${COLOR} Reemplazando archivos..."
    for ELM_1 in ${FILE_OLD[@]}; do
      rm -rf "$ELM_1"
      wait
    done
    for ELM_2 in ${FILE_NEW[@]}; do
      mv "$ELM_2" "${ELM_2%%_}"
      wait
    done
    echo -e "${COLOR} Operación terminada."
  # Delete the minify files
  elif [[ "$RES" == "d" ]]; then
    echo -e "${COLOR} Borrando los archivos minificados..."
    for ELM in ${FILE_NEW[@]}; do
      rm -rf "$ELM"
      wait
    done
    echo -e "${COLOR} Operación terminada."
  # Cancel script
  elif [[ "$RES" == "n" ]]; then
    echo -e "${COLOR} Operación cancelada."
  fi
}

# Main script
function f_main() {
  clear

  echo -e "${SPACE}"
  echo -e "${COLOR} **** LuaTiny v0.1.5 ****"
  echo -e "${COLOR}"
  echo -e "${COLOR} ¿Qué deseas hacer?"
  echo -e "${COLOR}${SPACE} 1) Minificar los archivos *.Lua"
  echo -e "${COLOR}${SPACE} 2) Sustituir los antiguos archivos"
  echo -e "${COLOR}${SPACE} 3) Salir del script"
  echo -e "${COLOR}"
  echo -ne "${COLOR} respuesta: "
  read -r OPTION
  echo -e "${SPACE}"

  if [[ $OPTION == "1" ]]; then
    f_findFiles "*.lua"
    f_minifyLuaFiles
  elif [[ $OPTION == "2" ]]; then
    f_findFiles "*.lua_"
    f_replaceFiles
  elif [[ $OPTION == "3" ]]; then
    echo -e "${COLOR} Saliendo del script..."
  else
    echo -e "${COLOR} Opcion invalida."
  fi
  echo -e "${SPACE}"
  exit
}

f_main
