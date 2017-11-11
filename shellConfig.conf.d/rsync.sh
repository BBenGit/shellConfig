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

## @file shell.rsync
## @brief Rsync functions

## @fn fromServer
## @brief synchronize a remote backup directory to the associate local one
## @attention Use content of CURRENT_SRV variable
fromServer () {
    case "${SHELL}" in
	    *zsh) index=1;;
	    *bash) index=0;;
    esac
    syncServer "$(cut -d'=' -f2 <<< ${CURRENT_SRV[${index}+4]})" "$(cut -d'=' -f2 <<< ${CURRENT_SRV[${index}+5]})"
}

## @fn toServer
## @brief synchronize a local backup directory to the associate remote one
## @attention Use content of CURRENT_SRV variable
toServer () {
    case "${SHELL}" in
	    *zsh) index=1;;
	    *bash) index=0;;
    esac
    syncServer "$(cut -d'=' -f2 <<< ${CURRENT_SRV[${index}+6]})" "$(cut -d'=' -f2 <<< ${CURRENT_SRV[${index}+7]})"
}

## @fn syncServer
## @brief synchronize two directory, one remote, one local through ssh connexion.
## @param string source directory
## @param string destination directory
## @attention Use content of CURRENT_SRV variable
syncServer () {
    local src="${1}"
    local dest="${2}"
    case "${SHELL}" in
	    *zsh) index=1;;
	    *bash) index=0;;
    esac
    if [[ "${src}" && "${dest}" ]]; then
        port=$(cut -d'=' -f2 <<< "${CURRENT_SRV[${index}+1]}")
        user=$(cut -d'=' -f2 <<< "${CURRENT_SRV[${index}+2]}")
        host=$(cut -d'=' -f2 <<< "${CURRENT_SRV[${index}+3]}")
        rsync -avz -e "ssh -p ${port}" "${user}"@"${host}":"${src}" "${dest}"
    else
        Log ${ERROR} "One parameter is missing. src : ${src}; dest : ${dest}"
    fi
}


