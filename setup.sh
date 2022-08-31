#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/AttifyOS/LTE-Cell-Scanner/releases/download/vbef6ef4/LTE-Cell-Scanner.tar.gz -O $APM_TMP_DIR/LTE-Cell-Scanner.tar.gz
  tar xf $APM_TMP_DIR/LTE-Cell-Scanner.tar.gz -C $APM_PKG_INSTALL_DIR/
  rm $APM_TMP_DIR/LTE-Cell-Scanner.tar.gz
  chmod +x $APM_PKG_INSTALL_DIR/CellSearch
  chmod +x $APM_PKG_INSTALL_DIR/LTE-Tracker
  ln -s $APM_PKG_INSTALL_DIR/CellSearch $APM_PKG_BIN_DIR/CellSearch
  ln -s $APM_PKG_INSTALL_DIR/LTE-Tracker $APM_PKG_BIN_DIR/LTE-Tracker
  echo "This package adds the command:"
  echo " - CellSearch"
  echo " - LTE-Tracker"

}

uninstall() {
  rm $APM_PKG_INSTALL_DIR/CellSearch
  rm $APM_PKG_INSTALL_DIR/LTE-Tracker
  rm $APM_PKG_BIN_DIR/CellSearch
  rm $APM_PKG_BIN_DIR/LTE-Tracker
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1