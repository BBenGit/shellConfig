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

local index=$(getArrayOffset)
SERVERS_LEN=${#SERVERS[@]}
for (( index; index < SERVERS_LEN; index+=8 ))
do
    cmd=$(cut -d'=' -f2 <<< "${SERVERS[$index]}")
    port=$(cut -d'=' -f2 <<< "${SERVERS[$index+1]}")
    user=$(cut -d'=' -f2 <<< "${SERVERS[$index+2]}")
    host=$(cut -d'=' -f2 <<< "${SERVERS[$index+3]}")
    alias ${cmd}="ssh ${user}@${host} -p ${port}"
done

## @fn sshChangePassword
## @brief Change SSH key password
## @param private key files
sshChangePassword()
{
    local input="${1}"
	ssh-keygen -f "${input}" -p
}
