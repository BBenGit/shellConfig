#!/bin/bash

# Copyright 2016, 2018 Guillaume Bernard <contact@guillaume-bernard.fr>
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
declare -r OUT="/dev/stdout"

## @var LIBSHELL_INSTALLATION_DIR
## @brief The directory that will server libshell files
declare -r LIBSHELL_INSTALLATION_DIR="${HOME}/.local/bin/libShell"

## @var SHELLCONFIG_INSTALLATION_DIR
## @brief The directory that will serve shellConfig files
declare -r SHELLCONFIG_INSTALLATION_DIR="${HOME}/.local/share/shellConfig"

## @var LIBSHELL_GIT_URL
## @brief libShell remote repository
declare -r LIBSHELL_GIT_URL="https://framagit.org/guilieb/libShell.git"

## @var SHELLCONFIG_GIT_URL
## @brief shellconfig remote repository
declare -r SHELLCONFIG_GIT_URL="https://framagit.org/guilieb/shellConfig.git"

## @var POWERLINEFONTS_GIT_URL
## @brief Powerline Fonts remote repository
declare -r POWERLINEFONTS_GIT_URL="https://github.com/powerline/fonts.git"

## @var OHMYZSH_GIT_URL
## @brief OhMyZsh remote repository
declare -r OHMYZSH_GIT_URL="https://github.com/robbyrussell/oh-my-zsh.git"

## @var LOGFILE
## @brief File used to save git output
declare -r LOGFILE="$(mktemp --suffix=shellConfigInstallLog)"

# Colors
declare -r NORMAL="\e[39m"
declare -r RED="\e[31m"
declare -r BLUE="\e[34m"

log()
{
    local color="${1}"
    local msg="${2}"
    echo -e "${color} ${msg} ${NORMAL}" > "${OUT}"
}

# Installation of libShell, or update an existing installation
installLibShell()
{
    if [[ ! -d "${LIBSHELL_INSTALLATION_DIR}" ]]; then
        git clone "${LIBSHELL_GIT_URL}" "${LIBSHELL_INSTALLATION_DIR}" > "${LOGFILE}"
    else
        cd ${LIBSHELL_INSTALLATION_DIR} && git pull origin master && cd ${OLDPWD}
    fi
}

installShellConfig()
{
    if [[ ! -d "${SHELLCONFIG_INSTALLATION_DIR}" ]]; then
        git clone "${SHELLCONFIG_GIT_URL}" "${SHELLCONFIG_INSTALLATION_DIR}" > "${LOGFILE}"
    else
        cd ${SHELLCONFIG_INSTALLATION_DIR} && git pull origin master && cd ${OLDPWD}
    fi
}

enableShellConfig()
{
    log ${BLUE} "Saving: .profile, .bashrc, .zshrc. Adding .old to their names"
    [[ -f .bashrc ]] && mv -f .bashrc .bashrc.old
    [[ -f .zshrc ]] && mv -f .zshrc .zshrc.old
    [[ -f .profile ]] && mv -f .profile .profile.old

    log ${BLUE} "Creating new links, enabling ShellConfig…"
    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/bashrc" "${HOME}/.bashrc"
    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/profile" "${HOME}/.profile"
    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/zshrc" "${HOME}/.zshrc"
    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/shellrc" "${HOME}/.shellrc"

    local SHELLCONFIG_CONF_DIR="${HOME}/.shellConfig"
    if [[ ! -L "${SHELLCONFIG_CONF_DIR}" && "$(readlink ${SHELLCONFIG_CONF_DIR})" != ${SHELLCONFIG_INSTALLATION_DIR}/shellConfig.conf.d ]]; then
        ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/shellConfig.conf.d" "${SHELLCONFIG_CONF_DIR}"
    fi
}

installPowerlineFonts()
{
    local fonts="$(mktemp -d)"
    git clone "${POWERLINEFONTS_GIT_URL}" "${fonts}" > "${LOGFILE}"
    "${fonts}"/install.sh > /dev/null
}

installOhMyZsh()
{
    local OHMYZSH_INSTALLATION_DIR="${HOME}/.oh-my-zsh"
    if [[ ! -d "${OHMYZSH_INSTALLATION_DIR}" ]]; then
        log "${BLUE}" "Cloning oh-my-zsh"
        git clone "${OHMYZSH_GIT_URL}" "${OHMYZSH_INSTALLATION_DIR}" > "${LOGFILE}"
    fi
}

usage()
{
    echo "
        install.sh [-h] [--help]
                   [--libshell]
                   [--oh-my-zsh]
                   [--powerline-fonts]
                   [--shell-config]
                   [--use-shell-config]
                   [-all]

        --libshell: install LibShell in the user's current home directory

        --oh-my-zsh: install Oh-My-ZSH in the user's current home directory. In
                     order to run properly, you must install zsh.

        --powerline-fonts: install powerline fonts for the current user

        --shell-config: install ShellConfig on the system. Implies installing
                        libShell as well.

        --use-shell-config: enable ShellConfig default configuration (replaces
                            any custom .profile, .bashrc or .zshrc

        --all: install libShell, Powerline fonts, ShellConfig and OhMyZsh.
    "
    exit 0
}


### Main function
if [[ ! -x "$(which git)" ]]; then
    log "${RED}" "ERR : git must be installed"
    exit 1
fi

while true ; do
    case ${1} in
        --help | -h | -?)
            usage
            ;;
        --libshell)
            declare INSTALL_LIBSHELL=true
            ;;
        --oh-my-zsh)
            declare INSTALL_OH_MY_ZSH=true
            ;;
        --powerline-fonts)
            declare INSTALL_POWERLINE=true
            ;;
        --shell-config)
            declare INSTALL_SHELL_CONFIG=true
            declare INSTALL_LIBSHELL=true
            ;;
        --use-shell-config)
            declare USE_SHELL_CONFIG=true
            ;;
        --all)
            declare INSTALL_LIBSHELL=true
            declare INSTALL_OH_MY_ZSH=true
            declare INSTALL_POWERLINE=true
            declare INSTALL_SHELL_CONFIG=true
            declare USE_SHELL_CONFIG=true
            ;;
        --*)
            echo "Argument invalide -- ${1}"
            usage
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

if [[ ${INSTALL_SHELL_CONFIG} = true ]]; then
    log ${BLUE} "Installing ShellConfig…"
    installShellConfig
fi

if [[ ${USE_SHELL_CONFIG} = true ]]; then
    if [[ ${INSTALL_SHELL_CONFIG} = true ]]; then
        log ${BLUE} "Enabling ShellConfig for your system…"
        enableShellConfig
    else
        log ${RED} "You cannot use ShellConfig without installing it."
    fi
fi

exit 0

