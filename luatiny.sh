#! /bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Module setup ================================================================
set -o errexit
set -o nounset
set -o pipefail
shopt -s globstar nullglob

# Global variables
C="\e[34m# \e[0m"
W="  "
IN_DIR=$1
FILES_LIST=0
FILES_TOTAL=0
FILES_FORMAT=0


# Module config ===============================================================

# Find files in the directory
function f_find_files() {
  local FORMAT=$1
  local LIST=$(find ${IN_DIR} -type f -name "$FORMAT")
  local TOTAL=$(find ${IN_DIR} -type f -name "$FORMAT" | wc -l)

  FILES_LIST=($LIST)
  FILES_TOTAL=$TOTAL

  echo -e "$C Buscando archivos..."
  echo -e "$W"
  # Empty directory
  if [[ $FILES_TOTAL == 0 ]]; then
    echo -e "$C No se han encontrado archivos $FORMAT"
    echo -e "$C Por favor, asegúrate de que haya archivos en este directorio."
    echo -e "$W"
    exit
  # You can edit this (by default it's 99 files)
  elif [[ $FILES_TOTAL -gt 99 ]]; then
    echo -e "$C Excediste el limite de 99 archivos."
    echo -e "$W"
    exit
  else
    for ELM in ${FILES_LIST[@]}; do
      echo -e "$W $ELM"
    done
    echo -e "$W"
    echo -e "$C Hay $FILES_TOTAL archivos $FORMAT"
  fi
  echo -e "$C"
}


# Minify files with format .lua
function f_minify_lua() {
  local COUNTER=0

  echo -e "$C ¿Quieres minificar los archivos?"
  echo -ne "$C respuesta (y/n): "
  read -r RES
  echo -e "$W"

  # Start minify Lua files
  if [[ $RES == "y" ]]; then
    for ELM in ${FILES_LIST[@]}; do
      (( COUNTER = COUNTER+1 ))

      printf "%b" "$W (${COUNTER}/${FILES_TOTAL}) --- $ELM "
      # execute Luamin
      luamin -f "$ELM" > "${ELM}_"
      wait
      if [[ $? == "0" ]]; then
        printf "%b" "\e[32m ✔ \e[0m \n"
      fi
    done
    echo -e "$W"
    f_replace_files
  # Cancel script
  elif [[ $RES == "n" ]]; then
    echo -e "$C Operación cancelada."
  fi
}


# Replace the files in their directories
function f_replace_files() {
  local FILE_OLD=$(find ${IN_DIR} -type f -name "*.lua")
  local FILE_NEW=$(find ${IN_DIR} -type f -name "*.lua_")
  local TOTAL=$(find ${IN_DIR} -type f -name "*.lua" | wc -l)

  echo -e "$C ¿Quieres utilizar los archivos minificados y sustituir los antiguos archivos?"
  echo -ne "$C respuesta (y/n/d): "
  read -r RES
  echo -e "$W"
  # Replace the files
  if [[ "$RES" == "y" ]]; then
    echo -e "$C Reemplazando archivos..."
    sleep 1s
    for ELM_A in ${FILE_OLD[@]}; do
      rm -rf "$ELM_A"
    done
    for ELM_B in ${FILE_NEW[@]}; do
      mv "$ELM_B" "${ELM_B%%_}"
    done
    echo -e "$C Operación terminada."
  # Delete the minify files
  elif [[ "$RES" == "d" ]]; then
    echo -e "$C Borrando los archivos minificados..."
    sleep 1s
    for ELM in ${FILE_NEW[@]}; do
      rm -rf "$ELM"
    done
    echo -e "$C Operación terminada."
  # Cancel script
  elif [[ "$RES" == "n" ]]; then
    echo -e "$C Operación cancelada."
  fi
}


# Start script
function f_main() {
  echo -e "$W"
  echo -e "$C **** LuaTiny v0.1.4 ****"
  echo -e "$C"
  echo -e "$C ¿Qué deseas hacer?"
  echo -e "$C$W 1) Minificar los archivos *.Lua"
  echo -e "$C$W 2) Sustituir los antiguos archivos"
  echo -e "$C$W 3) Salir del script"
  echo -e "$C"
  echo -ne "$C respuesta: "
  read -r OPTIONS
  echo -e "$W"

  if [[ $OPTIONS == "1" ]]; then
    f_find_files "*.lua"
    f_minify_lua
  elif [[ $OPTIONS == "2" ]]; then
    f_find_files "*.lua_"
    f_replace_files
  else
    echo -e "$C Operacion cancelada."
  fi
  echo -e "$W"
  exit
}

f_main
