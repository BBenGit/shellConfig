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

alias gsb="git status -sb"
alias gst="git status"
alias ga="git add"

alias gp="git push"
alias gl="git pull"

alias gd="git diff"
alias gcd="git diff --cached"
alias gwd="git diff --word-diff"
alias gwcd="git diff --word-diff --cached"

alias gco="git checkout"

alias glg="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(red)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold black)%d%C(reset)' --all"
alias gslg="lg --show-signature"

alias gbr="git branch"
alias gbd="git branch -d"
alias gba="git branch -a"
alias gbD="git branch -D"

alias gptag="git push --tags"
alias gltag="git tag --list -n"
alias grtags="git tag $2 $1; git push --tags; git tag -d $1; git push origin :refs/tags/$1"

alias greset="git reset --hard"

alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gca='git commit -v -a'
alias 'gca!'='git commit -v -a --amend'
alias gcam='git commit -a -m'
