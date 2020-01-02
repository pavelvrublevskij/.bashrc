#!/bin/bash
# This bash script helps to configure your Ubuntu system with some of default apps.
# Here you can install & configure required packages and applications. Which one, choose point 2.
# Please follow a menu and do point whatever you want to.
#
# Author: Pavel Vrublevskij
# Description: Developer Workstation Helper
# Since: 2020-01-02
# ========================================

#----------------------------------------
# Config History
#----------------------------------------
VERSION="0.1" DATE="2020-01-02"

#----------------------------------------
# Functions
#----------------------------------------
function func_quit() {
  exit
}

function func_upgrade() {
  sudo apt-get update && sudo apt-get upgrade
}

function func_install_required_packages() {
  echo "This operation will install require packages (please use search engine for detailed information about package):
    * vim             * htop             * java 8 (open jdk)
    * maven           * vlc              * gradle 5.0
    * gnote           * putty"
  echo "Install selected packages (Y/n):"
  read select
  if [ $select = "Y" ]; then
    sudo apt-get install vim maven gnote htop vlc putty openjdk-8-jdk

    # get gradle and install it
    wget https://services.gradle.org/distributions/gradle-5.0-bin.zip -P /tmp
    sudo unzip -d /opt/gradle /tmp/gradle-*.zip
    sudo echo "export GRADLE_HOME=/opt/gradle/gradle-5.0" >> /etc/profile.d/gradle.sh
    sudo exho "export PATH=${GRADLE_HOME}/bin:${PATH}" >> /etc/profile.d/gradle.sh
    sudo chmod +x /etc/profile.d/gradle.sh
    source /etc/profile.d/gradle.sh
  fi

  #++++++++++++++++++++++++++++++++
  # Configuration section
  echo "Installation of packages complete! Configure those packages for best experence (Y/n)?"
  read select
  if [ $select = "Y" ]; then
    func_configure_packages
  fi
}

function func_configure_packages() {
  echo "Configuration of packages started.... It will change configurations for: Bash, Vim."
  echo "You want to continue (Y/n)?"
  read select
  if [ $select = "Y" ]; then
    # Make backup
    echo "Backuping... (backuped files available at ./workstation_helper_backup)"
    sudo mkdir -v workstation_helper_backup

    #Then change .bashrc file
    # If workstation_helper_backup file exists, then no changes in workstation_helper_backup folder (that mean -n)
    sudo mv -vn ~/.bashrc ./workstation_helper_backup
    echo "[1] Bash configuration changing..."
    sudo cp -v ./files/.bashrc ~/.bashrc

    #Then change .vimrc file
    echo "[2] Vim configuration changing..."
    #Lets configure vim redactor only if it exists
    if [ $(dpkg-query -W -f='${Status}' vim 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
      sudo apt-get install vim
    fi

    # If workstation_helper_backup file exists, then no changes in workstation_helper_backup folder (that mean -n)
    sudo mv -vn /etc/vim/.vimrc ./workstation_helper_backup
    sudo cp -v ./files/.vimrc /etc/vim/.vimrc
  fi
}

function func_rollback() {
  echo "This option will rollback all operations which was done before. Continue (Y/n)?"
  read select
  if [ $select = "Y" ]; then
    #TODO: Have to be done
    echo "Rollback not available!. Please do it manually. Backuped files exist at ./workstation_helper_backup"
    true
  fi
}

#----------------------------------------
# Main menu
#----------------------------------------
menuPoint=0
until [[ $main_point == 9 ]]; do
  clear
  echo "M Y    W O R K S T A T I O N     H E L P E R"
  echo "Version: $VERSION, Last update date: $DATE"
  echo "=============================================="
  echo "0. About (Help)"
  echo "1. !!!Important!!! Update & Upgrade OS to newer version."
  echo "2. Install additional packages and configure"
  echo "3. Configure VimRC, BashRC for productive stance"
  echo "6. Rollback"
  echo "7. Do all (1,2,3) points"
  echo "9. Exit"
  echo
  echo "Please choose menu: "
  read menuPoint

  case $menuPoint in
  0)
    head myWorkstationHelper.sh
    ;;
  1)
    func_upgrade
    ;;
  2)
    func_install_required_packages
    ;;
  3)
    func_configure_packages
    ;;
  6)
    func_rollback
    ;;
  7)
    func_upgrade
    func_install_required_packages
    func_configure_packages
    ;;
  9)
    func_quit
    ;;
  *)
    echo "Please select correct menu point!"
    ;;
  esac

  echo -n "Press ant key to return menu..."
  read
done
