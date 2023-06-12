#! /bin/bash
# MIT License Copyright (c) 2023 Hecdin Farias

# Module setup ================================================================
set -o errexit
set -o nounset
set -o pipefail

# Global variables
COLOR="\e[33m? \e[0m"
SPACE="  "
FILE="luatiny"
NAME="LuaTiny"
# PATH: If you're using Termux, please use this path as is. Only modify it if
# you are not using Termux.
PATH="/data/data/com.termux/files/usr/bin"


# Module config ===============================================================

# Installer
function f_installScript() {
  if [[ -f $PATH/$FILE ]]; then
    # Delete old files
    echo -e "${COLOR} Eliminando los archivos de la previa instalación..."
    echo -e "${SPACE}"
    rm -r $PATH/${FILE}
    wait
  fi
  # Copy files
  echo -e "${COLOR} Instalación: Copiando los archivos en: ${PATH}"
  ln -s $(pwd)/${FILE}.sh $PATH/${FILE}
  wait
  echo -e "${COLOR} Operación terminada."
}


# Desinstaller
function f_uninstallScript() {
  if [[ -f $PATH/$FILE ]]; then
    # Delete files
    echo -e "${COLOR} Desinstalación: Eliminando los archivos..."
    rm -r $PATH/${FILE}
    wait
  else
    echo -e "${COLOR} ${FILE}.sh no instalado."
  fi
  echo -e "${COLOR} Operación terminada."
}


# Main script
function f_main() {
  clear

  echo -e "${SPACE}"
  echo -e "${COLOR} **** Wizard: \e[4m${NAME}\e[0m ****"
  echo -e "${COLOR}"
  echo -e "${COLOR} ¿Qué deseas hacer?"
  echo -e "${COLOR}${SPACE} 1) Instalar script"
  echo -e "${COLOR}${SPACE} 2) Desinstalar script"
  echo -e "${COLOR}${SPACE} 3) Salir"
  echo -e "${COLOR}"
  echo -ne "${COLOR} respuesta: "
  read -r OPTION
  echo -e "${SPACE}"

  if [[ $OPTION == 1 ]]; then
    f_installScript
  elif [[ $OPTION == 2 ]]; then
    f_uninstallScript
  elif [[ $OPTION == "3" ]]; then
    echo -e "${COLOR} Saliendo del script..."
  else
    echo -e "${COLOR} Opción invalida."
  fi
  echo -e "${SPACE}"
  exit
}

# Check $PATH
if [[ -d $PATH ]]; then
  f_main
else
  echo -e "¡Parece que ha habido un problema!"
  echo -e "No estás ejecutando este script en Termux."
  echo -e "Por lo tanto, edita este archivo y cambiar la ruta del directorio."
  exit
fi
