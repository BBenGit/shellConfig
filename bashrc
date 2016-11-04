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

declare -x LIBSHELL_DIR="${HOME}/.local/bin/libShell"
declare -x SHELLCONFIG_CONF="${HOME}/.shellConfig.conf"
declare -x SHELLCONFIG_CONF_DIR="${HOME}/.shellConfig"

# Load libShell framework
if [[ -e "${LIBSHELL_DIR}/libShell.sh" ]]; then
    source "${LIBSHELL_DIR}/libShell.sh"
else
    echo "\e[31mERR : libShell must be installed under $(dirname ${LIBSHELL_DIR}) directory !\e[39m"
    return
fi

# The config files
[[ -f "${SHELLCONFIG_CONF}" ]] && source "${SHELLCONFIG_CONF}"
if [[ -d "${SHELLCONFIG_CONF_DIR}" ]]; then
    for file in "${SHELLCONFIG_CONF_DIR}"/*; do
        source "${file}"
    done
fi
# Better auto-complete mode
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

## @var PS1
## @brief Bash PS1
declare -x PS1="\[\e[00;33m\][\A]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;32m\]\u@\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;31m\]\\$\[\e[0m\]\[\e[00;37m\] : \[\e[0m\]\[\e[00;34m\]\W\[\e[0m\] \[\e[0m\]"
