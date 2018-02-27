#!/bin/bash

# Copyright 2016, 2017 Guillaume Bernard <contact@guillaume-bernard.fr>
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

## @var OUT
## @brief Output for logging
declare -x OUT="$(tty)"

## @var SHELLCONFIG_INSTALLATION_DIR
## @brief The directory that will serve shellConfig files
declare -x SHELLCONFIG_INSTALLATION_DIR="${HOME}/.shellConfig"

## @var LIBSHELL_GIT_URL
## @brief libShell remote repository
declare -x LIBSHELL_GIT_URL="https://framagit.org/guilieb/libShell.git"

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

# Colors
declare NORMAL="\e[39m"
declare RED="\e[31m"
declare BLUE="\e[34m"

log()
{
    local color="${1}"
    local msg="${2}"
    echo -e "${color} ${msg} ${NORMAL}" > "${OUT}"
}

installLibShell()
{
    libShell="${HOME}/.local/bin/libShell"
    if [[ ! -d "${libShell}" ]]; then
        log "${BLUE}" "Cloning libShell"
        "${GIT}" clone "${LIBSHELL_GIT_URL}" "${libShell}" > "${LOGFILE}"
    fi
}

installPowerlineFonts()
{
    log "${BLUE}" "Cloning powerline fonts"
    fonts="$(mktemp -d)"
    "${GIT}" clone "${POWERLINEFONTS_GIT_URL}" "${fonts}" > "${LOGFILE}"
    log "${BLUE}" "Installing fonts"
    "${fonts}"/install.sh > /dev/null
    log "${BLUE}" "You can now change your terminal font to Ubuntu Powerline and change your default shell interpreter"
}

installOhMyZsh()
{
    ohmyzsh="${HOME}/.oh-my-zsh"
    if [[ ! -d "${ohmyzsh}" ]]; then
        log "${BLUE}" "Cloning oh-my-zsh"
        "${GIT}" clone "${OHMYZSH_GIT_URL}" "${ohmyzsh}" > "${LOGFILE}" 2>&1
    fi
}

createUserSymlinks()
{
    log "${BLUE}" "Creating symlinks"
    ln -sf "${DIRNAME}/bashrc" "${HOME}/.bashrc"
    ln -sf "${DIRNAME}/profile" "${HOME}/.profile"
    ln -sf "${DIRNAME}/zshrc" "${HOME}/.zshrc"
    [[ -h "${SHELLCONFIG_INSTALLATION_DIR}" ]] || ln -sf "${DIRNAME}/shellConfig.conf.d" "${SHELLCONFIG_INSTALLATION_DIR}"
}

usage()
{
    echo "
        install.sh [-h] [--help]
                   [--libshell]
                   [--oh-my-zsh]
                   [--powerline-fonts]
                   [--shell-config]

        --libshell: install LibShell in the user's current home directory

        --oh-my-zsh: install Oh-My-ZSH in the user's current home directory. In
                     order to run properly, you must install zsh.

        --powerline-fonts: install powerline fonts for the current user

        --shell-config: enable ShellConfig on the system
    "
    exit 0

}


### Main function
if [[ ! -x "${GIT}" ]]; then
    log "${RED}" "ERR : git must be installed"
    return
fi

while true ; do
    case ${1} in
        --help | -h | -?)
            usage
            ;;
        --libshell)
            declare -r INSTALL_LIBSHELL=true
            ;;
        --oh-my-zsh)
            declare -r INSTALL_OH_MY_ZSH=true
            ;;
        --powerline-fonts)
            declare -r INSTALL_POWERLINE=true
            ;;
        --shell-config)
            declare -r USE_SHELL_CONFIG=true
            ;;
        --*)
            echo "Argument invalide -- ${1}"
            shortusage
            exit 1
            ;;
        *)
            break
            ;;
    esac
    shift
done

if [[ ${INSTALL_LIBSHELL} = true ]]; then
    log ${BLUE} "Instaling LibShell…"
    installLibShell
fi

if [[ ${INSTALL_OH_MY_ZSH} = true ]]; then
    log ${BLUE} "Installing Oh-My-Zsh…"
    installOhMyZsh
fi

if [[ ${INSTALL_POWERLINE} = true ]]; then
    log ${BLUE} "Installing Powerline fonts…"
    installPowerlineFonts
fi

if [[ ${USE_SHELL_CONFIG} = true ]]; then
    log ${BLUE} "Installing ShellConfig…"
    createUserSymlinks
fi

log "${BLUE}" "Process is complete!"

