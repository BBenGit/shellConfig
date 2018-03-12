#!/bin/bash

# Copyright 2016-2018 Guillaume Bernard <contact@guillaume-bernard.fr>
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

# Possible to use « Oh My ZSH »
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    ZSH_THEME="agnoster"
    CASE_SENSITIVE="false"
    HYPHEN_INSENSITIVE="true"
    plugins=(git git-extras gpg-agent command-not-found)
    declare -x ZSH=${HOME}/.oh-my-zsh
    source "${ZSH}"/oh-my-zsh.sh
fi
