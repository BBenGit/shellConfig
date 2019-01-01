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

## @var GCC_COLORS
## @brief Variable to set GCC output
declare -x GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Colors for man pages
declare -x LESS_TERMCAP_mb=$'\E[01;31m'
declare -x LESS_TERMCAP_md=$'\E[01;31m'
declare -x LESS_TERMCAP_me=$'\E[0m'
declare -x LESS_TERMCAP_se=$'\E[0m'
declare -x LESS_TERMCAP_so=$'\E[01;44;33m'
declare -x LESS_TERMCAP_ue=$'\E[0m'
declare -x LESS_TERMCAP_us=$'\E[01;32m'
