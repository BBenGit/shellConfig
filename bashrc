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

[[ -f "${HOME}/.shellrc" ]] && source "${HOME}/.shellrc"

# Better auto-complete mode
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

## @var PS1
## @brief Bash PS1
if [ $(id -u) -ne 0 ]; then
    typeset -x PS1="\[\e[00;33m\][\A]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;32m\]\u@\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;31m\]\\$\[\e[0m\]\[\e[00;37m\] : \[\e[0m\]\[\e[00;34m\]\W\[\e[0m\] \[\e[0m\]"
else
    typeset -x PS1="\[\e[00;33m\][\A]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;31;4m\]\u@\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;31m\]\\$\[\e[0m\]\[\e[00;37m\] : \[\e[0m\]\[\e[00;34m\]\W\[\e[0m\] \[\e[0m\]"
fi

# Case insensitive
bind 'set completion-ignore-case on'

