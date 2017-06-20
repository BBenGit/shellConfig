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

alias gsb="git status -sb"
alias gst="git status"
alias gadd="git add"

alias gpush="git push"
alias gpull="git pull"

alias gdff="git diff"
alias gcdff="git diff --cached"
alias gwdff="git diff --word-diff"
alias gwcdff="git diff --word-diff --cached"

alias gckt="git checkout"

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

## @var GIT_REPOSITORIES
## @brief The array that contains repositories information
declare -a GIT_REPOSITORIES=()

declare -x GIT_LOGFILE="/tmp/git-update.log"

## @fn __getRepositories()
## @brief Parse a file to store git repositories
## @todo What if the key or value contains the char '='
## With regex : "(.*)"="(.*)"$
__getRepositories(){

    GIT_REPOSITORIES=()
    local repositoryFile="${CONFIGURATION_FILES_DIRECTORY}/local/git/projects"

    IFS=$'\n'
    while read -r line;
    do
        directoryName=$(cut -d'=' -f1 <<< "${line}")
        remoteURL=$(cut -d'=' -f2 <<< "${line}")
        GIT_REPOSITORIES+=("${directoryName}=${remoteURL}")
    done <<< "$(egrep ".*=.*" < "${repositoryFile}")"
}

## @fn gitUpdate()
## @brief Fetch or clone git repositories
## @param string --pull if we want to pulling instead of fetching repository
gitUpdate(){

    local pullOn="${1}"

    __getRepositories

    touch "${GIT_LOGFILE}"

    for line in "${GIT_REPOSITORIES[@]}"; do
        local directoryName=$(cut -d'=' -f1 <<< "${line}")
        local remoteURL=$(cut -d'=' -f2 <<< "${line}")
        local targetDirectory=""

        # Directory Name if an asbsolute path
        if [[ "${directoryName}" =~ ^/ ]]; then
            targetDirectory="${directoryName}"
        else
            targetDirectory="${GIT_PROJECTS_DIRECTORY}/${directoryName}"
        fi

        # Else, it will be stored in the GIT_PROJECTS_DIRECTORY
        if [[ ! -d "${targetDirectory}" ]]; then
            Log ${INFO} "Cloning project into ${targetDirectory}"
            gitClone "${targetDirectory}" "${remoteURL}"
        elif [[ "${pullOn}" == "--pull" ]]; then
            Log ${INFO} "Pulling existing git directory : ${targetDirectory}"
            gitPull "${targetDirectory}"
        else
            Log ${INFO} "Fetching existing git directory : ${targetDirectory}"
            gitFetch "${targetDirectory}"
        fi
    done
}
