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

## English locale
alias eng='export LC_ALL=C'
## French locale
alias fra='export LC_ALL=fr_FR.UTF-8'

## "ls" command aliases
alias ls='ls -l --color=auto --block-size=1KB -h'
alias ll='ls -lh'
alias la='ls -ah'
alias lla='ls -alh'
alias llr='ls -lRh'
alias lr='ls -R'

alias fgrep='fgrep --color=auto'

## "cd" command aliases
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

alias cp='cp -p'

## Protect "mv", "rm", "chmod", "chown"
alias mv='mv -i'
alias rm='rm -i --preserve-root'
alias chmod="chmod --preserve-root"
alias chown="chown --preserve-root"

# Login with su by default
alias sul="su --login"

# Remove temp files
alias clean='find -name "*~" -exec rm {} \;'

# Reset ${HOME} rights to 700 (recursive)
alias fixMyRights="chmod -R go-rwx ${HOME}"


