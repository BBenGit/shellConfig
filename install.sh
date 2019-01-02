#!/bin/bash

# Copyright 2016, 2019 Guillaume Bernard <contact@guillaume-bernard.fr>
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
typeset -r OUT="/dev/stdout"

## @var LIBSHELL_INSTALLATION_DIR
## @brief The directory that will server libshell files
typeset -r LIBSHELL_INSTALLATION_DIR="${HOME}/.local/lib/libShell"

## @var SHELLCONFIG_INSTALLATION_DIR
## @brief The directory that will serve shellConfig files
typeset -r SHELLCONFIG_INSTALLATION_DIR="${HOME}/.local/lib/shellConfig"

## @var OHMYZSH_INSTALLATION_DIR
## @brief The OhMyZsh project
typeset -r OHMYZSH_INSTALLATION_DIR="${HOME}/.oh-my-zsh"

## @var LIBSHELL_GIT_URL
## @brief libShell remote repository
typeset -r LIBSHELL_GIT_URL="https://code.guillaume-bernard.fr/guilieb/libShell.git"

## @var SHELLCONFIG_GIT_URL
## @brief shellconfig remote repository
typeset -r SHELLCONFIG_GIT_URL="https://code.guillaume-bernard.fr/guilieb/shellConfig.git"

## @var POWERLINEFONTS_GIT_URL
## @brief Powerline Fonts remote repository
typeset -r POWERLINEFONTS_GIT_URL="https://github.com/powerline/fonts.git"

## @var OHMYZSH_GIT_URL
## @brief OhMyZsh remote repository
typeset -r OHMYZSH_GIT_URL="https://github.com/robbyrussell/oh-my-zsh.git"

## @var LOGFILE
## @brief File used to save git output
typeset -r LOGFILE="$(mktemp --suffix=shellConfigInstallLog)"

# Colors
typeset -r NORMAL="\e[39m"
typeset -r BLACK="\e[30m"
typeset -r RED="\e[31m"
typeset -r GREEN="\e[32m"
typeset -r YELLOW="\e[33m"
typeset -r BLUE="\e[34m"
typeset -r MAGENTA="\e[35m"
typeset -r CYAN="\e[36m"

log()
{
    local color="${1}"
    local msg="${2}"
    printf "%b%s%b\n" ${color} "${msg}" ${NORMAL}
}

installGitComponent()
{
    local component="${1}"
    local component_url="${component^^}_GIT_URL"
    local installation_dir="${component^^}_INSTALLATION_DIR"
    
    if [[ ! -d "${!installation_dir}" ]]; then
        log "${YELLOW}" "    → ${component} not found. Cloning…"
        git clone "${!component_url}" "${!installation_dir}" &>> "${LOGFILE}"
    else
        log "${YELLOW}" "    → ${component} already installed. Updating…"
        git --git-dir="${!installation_dir}/.git" \
            --work-tree="${!installation_dir}" \
            pull origin master &>> "${LOGFILE}"
    fi
}

installPowerlineFonts()
{
    if ! fc-list | grep "Powerline" &>> /dev/null; then
        log "${YELLOW}" "    → Powerline fonts not found. Cloning…"
        local fonts="$(mktemp -d)"
        git clone "${POWERLINEFONTS_GIT_URL}" "${fonts}" &>> "${LOGFILE}"
        "${fonts}"/install.sh &>> "${LOGFILE}"
    else
        log "${YELLOW}" "    → Powerline fonts already installed. Nothing to do."
    fi
}

enableShellConfig()
{
    log ${YELLOW} "    → saving: .profile, .bashrc, .zshrc. Adding .old to their names"
    [[ -f .bashrc ]] && mv -f .bashrc .bashrc.old
    [[ -f .zshrc ]] && mv -f .zshrc .zshrc.old
    [[ -f .profile ]] && mv -f .profile .profile.old

    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/bashrc" "${HOME}/.bashrc"
    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/profile" "${HOME}/.profile"
    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/zshrc" "${HOME}/.zshrc"
    ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/shellrc" "${HOME}/.shellrc"

    local SHELLCONFIG_CONF_DIR="${HOME}/.shellConfig"
    if [[ ! -L "${SHELLCONFIG_CONF_DIR}" && "$(readlink ${SHELLCONFIG_CONF_DIR})" != ${SHELLCONFIG_INSTALLATION_DIR}/shellConfig.conf.d ]]; then
        ln -sf "${SHELLCONFIG_INSTALLATION_DIR}/shellConfig.conf.d" "${SHELLCONFIG_CONF_DIR}"
    fi
}

usage()
{
    echo -e "
USAGE:
        $(basename ${0}) [-h] [--help]
                   [--libshell]
                   [--oh-my-zsh]
                   [--powerline-fonts]
                   [--shell-config]
                   [--all]
                   [--assumedefault]

        ${YELLOW}--libshell${NORMAL}: install LibShell in the user's current home directory

        ${YELLOW}--oh-my-zsh${NORMAL}: install Oh-My-ZSH in the user's current home directory. In
                     order to run properly, you must install zsh.

        ${YELLOW}--powerline-fonts${NORMAL}: install powerline fonts for the current user

        ${YELLOW}--shell-config${NORMAL}: install ShellConfig on the system. Implies installing
                        libShell as well. It enables ShellConfig default 
                        configuration (replaces any custom .profile, .bashrc 
                        or .zshrc)

        ${YELLOW}--all${NORMAL}: install libShell, Powerline fonts, ShellConfig and OhMyZsh.

        ${YELLOW}--assumedefault${NORMAL}: assume defaults values when there are questions.
    "
    exit 0
}


### Main function
log "${GREEN}" "shellConfig installation process. Components will be installed…"
log "${GREEN}" "Output is located in \"${LOGFILE}\""

if [[ $# -eq 0 ]] ; then
    log "${RED}" "ERR: no argument provided"
    usage
    exit 0 
fi

typeset ASSUME_DEFAULT=false

while true ; do
    case ${1} in
        --help | -h | -?)
            usage
            ;;
        --libshell)
            typeset INSTALL_LIBSHELL=true
            ;;
        --oh-my-zsh)
            typeset INSTALL_OH_MY_ZSH=true
            ;;
        --powerline-fonts)
            typeset INSTALL_POWERLINE=true
            ;;
        --shell-config)
            typeset INSTALL_SHELL_CONFIG=true
            typeset INSTALL_LIBSHELL=true
            ;;
        --all)
            typeset INSTALL_LIBSHELL=true
            typeset INSTALL_OH_MY_ZSH=true
            typeset INSTALL_POWERLINE=true
            typeset INSTALL_SHELL_CONFIG=true
            ;;
        --assumedefault)
            typeset ASSUME_DEFAULT=true
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

if [ ! -x "$(which git 2> /dev/null)" ]; then
    log "${BLUE}" "git is missing. Will try to install it…"

    command="su -l -c"
    if [[ ${ASSUME_DEFAULT} = false ]]; then
        # Use sudo, or not
        printf "%b%s%b" ${MAGENTA} "Use sudo? [y|N] " ${NORMAL}
        read use_sudo
        command="su -l -c"
        if [[ ${use_sudo} =~ (y|Y) ]]; then
            command="sudo"
        fi
    fi

    # Install git from package manager
    if [ -x "$(which yum 2> /dev/null)" ]; then
        eval "${command} \"yum install -y git | tee ${LOGFILE}\""
    elif [ -x "$(which dnf 2> /dev/null)" ]; then
        eval "${command} \"dnf install -y git | tee ${LOGFILE}\""
    elif [ -x "$(which apt 2> /dev/null)" ]; then
        eval "${command} \"apt update && apt install -y git | tee ${LOGFILE}\""
    else
        exit 1
    fi
fi

if [[ ${INSTALL_LIBSHELL} = true ]]; then
    log ${BLUE} "Instaling LibShell…"
    installGitComponent libShell
fi

if [[ ${INSTALL_OH_MY_ZSH} = true ]]; then
    log ${BLUE} "Installing Oh-My-Zsh…"
    installGitComponent OhMyZsh
fi

if [[ ${INSTALL_SHELL_CONFIG} = true ]]; then
    log ${BLUE} "Installing ShellConfig…"
    installGitComponent shellConfig
    enableShellConfig
fi

if [[ ${INSTALL_POWERLINE} = true ]]; then
    log ${BLUE} "Installing Powerline fonts…"
    installPowerlineFonts
fi

exit 0

