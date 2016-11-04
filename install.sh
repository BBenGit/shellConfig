#!/bin/bash

# Copyright 2016 Guillaume Bernard <contact.guib@laposte.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

## @file install.sh
## @brief Configure the shell to be used

## @var SHELLCONFIG_INSTALLATION_DIR
## @brief The directory that will serve shellConfig files
declare -x SHELLCONFIG_INSTALLATION_DIR="${HOME}/.shellConfig"

## @var LIBSHELL_GIT_URL
## @brief libShell remote repository
declare -x LIBSHELL_GIT_URL="https://framagit.org/guilieb/libBash.git"

## @var POWERLINEFONTS_GIT_URL
## @brief Powerline Fonts remote repository 
declare -x POWERLINEFONTS_GIT_URL="https://github.com/powerline/fonts.git"

## @var OHMYZSH_GIT_URL
## @brief OhMyZsh remote repository
declare -x OHMYZSH_GIT_URL="https://github.com/robbyrussell/oh-my-zsh.git"

## @var GIT
## @brief The git binary
declare -x GIT="$(which git)"

## @var DIRNAME
## @brief Current directory name
declare -x DIRNAME="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"

## @var LOGFILE
## @brief File used to save git output
declare -x LOGFILE="$(mktemp --suffix=shellConfigInstallLog)"

if [[ ! -x "${GIT}" ]]; then
    echo -e "\e[31mERR : git must be installed\e[39m"
    return
fi

# libshell
libShell="${HOME}/.local/bin/libShell"
if [[ ! -d "${libShell}" ]]; then
    echo -e "\e[34mCloning libShell\e[39m"
    "${GIT}" clone "${LIBSHELL_GIT_URL}" "${libShell}" > "${LOGFILE}" 2>&1
fi

# Powerline
echo -e "\e[34mCloning powerline fonts\e[39m"
fonts="$(mktemp -d)"
"${GIT}" clone "${POWERLINEFONTS_GIT_URL}" "${fonts}" > "${LOGFILE}" 2>&1

# oh-my-zsh
ohmyzsh="${HOME}/.oh-my-zsh"
if [[ ! -d "${ohmyzsh}" ]]; then
    echo -e "\e[34mCloning oh-my-zsh\e[39m"
    "${GIT}" clone "${OHMYZSH_GIT_URL}" "${ohmyzsh}" > "${LOGFILE}" 2>&1
fi

echo -e "\e[34mCreating symlinks\e[39m"
ln -sf "${DIRNAME}/bashrc" "${HOME}/.bashrc"
ln -sf "${DIRNAME}/profile" "${HOME}/.profile"
ln -sf "${DIRNAME}/zshrc" "${HOME}/.zshrc"
[[ -h "${SHELLCONFIG_INSTALLATION_DIR}" ]] || ln -sf "${DIRNAME}/shellConfig.conf.d" "${SHELLCONFIG_INSTALLATION_DIR}"

echo -e "\e[34mInstalling fonts\e[39m"
"${fonts}"/install.sh > /dev/null

echo -e "\e[34mYou can now change your terminal font to Ubuntu Powerline and change your default shell interpreter\e[39m"


