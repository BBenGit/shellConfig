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

alias st="git status" 
alias add="git add" 
alias dff="git diff"
alias cdff="git diff --cached"
alias push="git push"
alias pull="git pull"
alias wdff="git diff --word-diff"
alias wcdff="git diff --word-diff --cached"
alias ckt="git checkout" 
alias lg="git lg"
alias slg="lg --show-signature"
alias br="git branch"
alias brd="git branch -d"
alias bra="git branch -a"
alias brD="git branch -D"
alias git_sign="git config commit.gpgsign true"
alias tagp="git push --tags"
alias tagl="git tag --list -n"

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
## @todo Need to manage absolute path
gitUpdate(){
    __getRepositories

    touch "${GIT_LOGFILE}"

    for line in "${GIT_REPOSITORIES[@]}"; do
        directoryName=$(cut -d'=' -f1 <<< "${line}")
        remoteURL=$(cut -d'=' -f2 <<< "${line}")

        # Directory Name if an asbsolute path
        if [[ "${directoryName}" =~ ^/ ]]; then
            if [[ ! -d "${directoryName}" ]]; then
                Log ${INFO} "Cloning project into ${directoryName}"
                gitClone "${directoryName}" "${remoteURL}"
            else
                Log ${INFO} "Fetching existing git directory : ${directoryName}"
                gitFetch "${directoryName}"
            fi
        else

            # Else, it will be stored in the GIT_PROJECTS_DIRECTORY
            if [[ ! -d "${GIT_PROJECTS_DIRECTORY}/${directoryName}" ]]; then
                Log ${INFO} "Cloning project into ${GIT_PROJECTS_DIRECTORY}/${directoryName}"
                gitClone "${GIT_PROJECTS_DIRECTORY}/${directoryName}" "${remoteURL}"
            else
                Log ${INFO} "Fetching existing git directory : ${GIT_PROJECTS_DIRECTORY}/${directoryName}"
                gitFetch "${GIT_PROJECTS_DIRECTORY}/${directoryName}"
            fi
        fi
    done
}
