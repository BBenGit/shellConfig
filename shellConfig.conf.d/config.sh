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

## @brief Prevent from deleting file with output redirection
set -C

## @brief Mask on created files
umask 077 

## @brief Allow to use own colors
eval "$(dircolors -b)"

## @fn importShellConfigSetupFile
## @brief Import the shellConfig main setup file to its required location
importShellConfigSetupFile() {
    local target="${1}"
    if [ -f "${target}" ]; then
        ln -sf "${target}" "${SHELLCONFIG_CONF}"
    else
        Log ${ERROR} "Configuration file : ${target} not found."
    fi
}

## @fn importShellConfigExternalDirectory()
## @brief Import the directory containing external scripts
importShellConfigExternalDirectory() {
    local target="${1}"
    if [ -d "${target}" ]; then
        ln -sf "${target}" "${SHELLCONFIG_CUSTOM_SCRIPTS_DIR=}"
    else
        Log ${ERROR} "External scripts directory not found."
    fi
}

## @fn updateKit
## @brief Update the shellConfig and libShell kits
updateKit()
{
    Log ${INFO} "Updating shellConfig and libShell…"
    git --git-dir="$(realpath ${LIBSHELL_DIR})/.git" \
        --work-tree="$(realpath ${LIBSHELL_DIR})" pull origin master
    git --git-dir="$(realpath ${SHELLCONFIG_CONF_DIR})/../.git" \
        --work-tree="$(realpath ${SHELLCONFIG_CONF_DIR})/.." pull origin master
}

## @fn refresh
## @brief Reload the shell configuration
refresh()
{
    Log ${INFO} "Reloading configuration…"
    if [ -n "${ZSH_NAME}" ]; then
        source "${HOME}/.zshrc"
    elif [ -n "${BASH_VERSION}" ]; then
        source "${HOME}/.bashrc"
    fi
}
