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

numlockx_bin="$(which numlockx)"
if [[ -x "${numlockx_bin}" ]]; then
    "${numlockx_bin}" on
fi
 
if pgrep gpg-agent; then
	echo "Starting GPG agent."
	eval "$(gpg-agent --daemon 2> /dev/null)"
else
	echo "GPG agent is already running on this system."
fi
