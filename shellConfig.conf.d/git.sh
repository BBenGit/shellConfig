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

## @var GIT_REPOSITORIES
## @brief The array that contains repositories information
declare -a GIT_REPOSITORIES=()

## @fn __getRepositories()
## @brief Parse a file to store git repositories
## @todo What if the key or value contains the char '='
## With regex : "(.*)"="(.*)"$
__getRepositories(){

    GIT_REPOSITORIES=()
    IFS=$'\n'
    while read -r line;
    do
        directoryName=$(cut -d'=' -f1 <<< "${line}")
        remoteURL=$(cut -d'=' -f2 <<< "${line}")
        GIT_REPOSITORIES+=("${directoryName}=${remoteURL}")
    done <<< "$(egrep ".*=.*" < "${GIT_REPOSITORY_FILE}")"
}

## @fn gitUpdate()
## @brief Fetch or clone git repositories
## @param string --pull if we want to pulling instead of fetching repository
gitUpdate(){

    local pullOn="${1}"

    __getRepositories

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
