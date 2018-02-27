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

declare -x CONFIGURATION_FILES_DIRECTORY_LOCAL="${CONFIGURATION_FILES_DIRECTORY}/local"
declare -x CONFIGURATION_FILES_DIRECTORY_WEB="${CONFIGURATION_FILES_DIRECTORY}/web"
declare -x CONFIGURATION_FILES_TEMPLATES="${CONFIGURATION_FILES_DIRECTORY}/Modèles de documents"

declare -A CONFIGURATION_FILES_DIRECTORIES
CONFIGURATION_FILES_DIRECTORIES["rhythmbox"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/rhythmbox"
CONFIGURATION_FILES_DIRECTORIES["bleachbit"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/bleachbit"
CONFIGURATION_FILES_DIRECTORIES["nextcloud"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/nextcloud"
CONFIGURATION_FILES_DIRECTORIES["gpg"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/gpg"
CONFIGURATION_FILES_DIRECTORIES["git"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/git"

declare -A CONFIGURATION_FILES_DST_DIRECTORIES
CONFIGURATION_FILES_DST_DIRECTORIES["rhythmbox"]="${HOME}/.local/share/rhythmbox"
CONFIGURATION_FILES_DST_DIRECTORIES["bleachbit"]="${HOME}/.config/bleachbit"
CONFIGURATION_FILES_DST_DIRECTORIES["nextcloud"]="${HOME}/.local/share/data/Nextcloud"
CONFIGURATION_FILES_DST_DIRECTORIES["liferea"]="${HOME}/.config/liferea"
CONFIGURATION_FILES_DST_DIRECTORIES["bleachbit"]="${HOME}/.config/bleachbit"
CONFIGURATION_FILES_DST_DIRECTORIES["gpg"]="${HOME}/.gnupg"
CONFIGURATION_FILES_DST_DIRECTORIES["git"]="${HOME}"

## GPG
declare -A GPG_FILES
GPG_FILES["conf"]="${CONFIGURATION_FILES_DIRECTORIES["gpg"]}/gpg.conf"
GPG_FILES["agent"]="${CONFIGURATION_FILES_DIRECTORIES["gpg"]}/gpg-agent.conf"
GPG_FILES["dirmngr"]="${CONFIGURATION_FILES_DIRECTORIES["gpg"]}/dirmngr.conf"
GPG_FILES["cert"]="${CONFIGURATION_FILES_DIRECTORIES["gpg"]}/sks-keyservers.netCA.crt"

declare -A GPG_FILES_DST
GPG_FILES_DST["conf"]="${CONFIGURATION_FILES_DST_DIRECTORIES["gpg"]}/gpg.conf"
GPG_FILES_DST["agent"]="${CONFIGURATION_FILES_DST_DIRECTORIES["gpg"]}/gpg-agent.conf"
GPG_FILES_DST["dirmngr"]="${CONFIGURATION_FILES_DST_DIRECTORIES["gpg"]}/dirmngr.conf"
GPG_FILES_DST["cert"]="${CONFIGURATION_FILES_DST_DIRECTORIES["gpg"]}/sks-keyservers.netCA.crt"

## GIT
declare -A GIT_FILES
GIT_FILES["gitconfig"]="${CONFIGURATION_FILES_DIRECTORIES["git"]}/gitconfig"
GIT_FILES["gitignore"]="${CONFIGURATION_FILES_DIRECTORIES["git"]}/gitignore_global"
GIT_FILES["git-commit-template"]="${CONFIGURATION_FILES_DIRECTORIES["git"]}/git-commit-template.txt"


declare -A GIT_FILES_DST
GIT_FILES_DST["gitconfig"]="${CONFIGURATION_FILES_DST_DIRECTORIES["git"]}/.gitconfig"
GIT_FILES_DST["gitignore"]="${CONFIGURATION_FILES_DST_DIRECTORIES["git"]}/.gitignore_global"
GIT_FILES_DST["git-commit-template"]="${CONFIGURATION_FILES_DST_DIRECTORIES["git"]}/.git-commit-template.txt"

## NEXTCLOUD
declare -A NEXTCLOUD_FILES
NEXTCLOUD_FILES["config"]="${CONFIGURATION_FILES_DIRECTORIES["nextcloud"]}/nextcloud.cfg"
NEXTCLOUD_FILES["ignore"]="${CONFIGURATION_FILES_DIRECTORIES["nextcloud"]}/nextcloud_exclude.lst"

declare -A NEXTCLOUD_FILES_DST
NEXTCLOUD_FILES_DST["config"]="${CONFIGURATION_FILES_DST_DIRECTORIES["nextcloud"]}/nextcloud.cfg"
NEXTCLOUD_FILES_DST["ignore"]="${CONFIGURATION_FILES_DST_DIRECTORIES["nextcloud"]}/sync-exclude.lst"

## RHYTHMBOX
declare -A RHYTHMBOX_FILES
RHYTHMBOX_FILES["config"]="${CONFIGURATION_FILES_DIRECTORIES["rhythmbox"]}/rhythmdb.xml"
RHYTHMBOX_FILES["playlist"]="${CONFIGURATION_FILES_DIRECTORIES["rhythmbox"]}/playlists.xml"

declare -A RHYTHMBOX_FILES_DST
RHYTHMBOX_FILES_DST["config"]="${CONFIGURATION_FILES_DST_DIRECTORIES["rhythmbox"]}/rhythmdb.xml"
RHYTHMBOX_FILES_DST["playlist"]="${CONFIGURATION_FILES_DST_DIRECTORIES["rhythmbox"]}/playlists.xml"

## WEB
declare -A WEB_FILES
WEB_FILES["liferea"]="${CONFIGURATION_FILES_DIRECTORY_WEB}/feedlist.opml"

declare -A WEB_FILES_DST
WEB_FILES_DST["liferea"]="${CONFIGURATION_FILES_DST_DIRECTORIES["liferea"]}/feedlist.opml"

## TOOLS
declare -A TOOLS_FILES
TOOLS_FILES["bleachbit"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/bleachbit/bleachbit.ini"
TOOLS_FILES["vim"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/vimrc"
TOOLS_FILES["hidden"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/hidden"
TOOLS_FILES["hidden"]="${CONFIGURATION_FILES_DIRECTORY_LOCAL}/hidden"

declare -A TOOLS_FILES_DST
TOOLS_FILES_DST["bleachbit"]="${CONFIGURATION_FILES_DST_DIRECTORIES["liferea"]}/bleachbit.ini"
TOOLS_FILES_DST["vim"]="${HOME}/.vimrc"
TOOLS_FILES_DST["hidden"]="${HOME}/.hidden"

## @fn importConf
## @brief Import global configuration
importConf()
{
    setupShellConfig
    setupHiddenFiles
    setupVimConf
    setupGPGConf
    setupGitConf
    setupNextcloudConf
    setupLifereaConf
    setupBleachBitConf
    setupRhythmboxConf
    setupFileTemplates
    if [[ "${DESKTOP_SESSION}" == "gnome" ]]; then
		setupDesktop
        loadGnome
    fi
    refresh
}

setupShellConfig(){
    Log ${INFO} "Configuration pour shellConfig"
    ln -sf "${CONFIGURATION_FILES_DIRECTORY_LOCAL}/shellconfig.vars" "${SHELLCONFIG_CONF}"
}

setupDesktop(){
    Log ${INFO} "Lien de fichiers d'applications"
    if [[ ! -h "${HOME}/.local/share/applications" ]]; then
        rm -rf "${HOME}/.local/share/applications"
        ln -sf "${CONFIGURATION_FILES_DIRECTORY_LOCAL}/applications/" "${HOME}/.local/share/applications"
    fi

    Log ${INFO} "Lien de fichiers de démarrage automatique d'applications"
    if [[ ! -h "${HOME}/.config/autostart" ]]; then
        rm -rf "${HOME}/.config/autostart"
        ln -sf "${CONFIGURATION_FILES_DIRECTORY_LOCAL}/autostart/" "${HOME}/.config/autostart"
    fi
}

setupGPGConf(){
    Log ${INFO} "Lien de la configuration de GnuPG"
    ln -sf "${GPG_FILES["conf"]}" "${GPG_FILES_DST["conf"]}"
    ln -sf "${GPG_FILES["agent"]}" "${GPG_FILES_DST["agent"]}"
    ln -sf "${GPG_FILES["dirmngr"]}" "${GPG_FILES_DST["dirmngr"]}"
    ln -sf "${GPG_FILES["cert"]}" "${GPG_FILES_DST["cert"]}"
}

setupGitConf(){
    Log ${INFO} "Lien de la configuration de Git"
    ln -sf "${GIT_FILES["gitconfig"]}" "${GIT_FILES_DST["gitconfig"]}"
    ln -sf "${GIT_FILES["gitignore"]}" "${GIT_FILES_DST["gitignore"]}"
    ln -sf "${GIT_FILES["git-commit-template"]}" "${GIT_FILES_DST["git-commit-template"]}"
}

setupNextcloudConf(){
    if [ -d "${CONFIGURATION_FILES_DST_DIRECTORIES["nextcloud"]}" ]; then
        Log ${INFO} "Lien de la configuration de Nextcloud"
        ln -sf "${NEXTCLOUD_FILES["ignore"]}" "${NEXTCLOUD_FILES_DST["ignore"]}"
        ln -sf "${NEXTCLOUD_FILES["config"]}" "${NEXTCLOUD_FILES_DST["config"]}"
    fi
}

setupRhythmboxConf(){
    if [ -d "${CONFIGURATION_FILES_DST_DIRECTORIES["rhythmbox"]}" ]; then
        Log ${INFO} "Configuration des listes et des radios de Rhythmbox"
        ln -sf "${RHYTHMBOX_FILES["playlist"]}" "${RHYTHMBOX_FILES_DST["playlist"]}"
        cp -f "${RHYTHMBOX_FILES["config"]}" "${RHYTHMBOX_FILES_DST["config"]}"
    fi
}

setupLifereaConf(){
    if [ -d "${CONFIGURATION_FILES_DST_DIRECTORIES["rhythmbox"]}" ]; then
        Log ${INFO} "Lien de la liste de flux pour Liferea"
        ln -sf "${WEB_FILES["liferea"]}" "${WEB_FILES_DST["liferea"]}"  
    fi
}

setupBleachBitConf(){
    if [ -d "${CONFIGURATION_FILES_DST_DIRECTORIES["bleachbit"]}" ]; then
        Log ${INFO} "Configuration pour Bleachbit"
        ln -sf "${TOOLS_FILES["bleachbit"]}" "${TOOLS_FILES_DST["bleachbit"]}"
    fi
}

setupVimConf(){
    Log ${INFO} "Lien de la configuration de VIM"
    ln -sf "${TOOLS_FILES["vim"]}" "${TOOLS_FILES_DST["vim"]}"
}

setupHiddenFiles(){
    Log ${INFO} "Lien de la configuration des fichiers à cacher"
    ln -sf "${TOOLS_FILES["hidden"]}" "${TOOLS_FILES_DST["hidden"]}"
}

setupFileTemplates(){
    Log ${INFO} "Lien vers les modèles de fichiers"
    rm -fr Modèles
    ln -sf "${CONFIGURATION_FILES_TEMPLATES}" "${HOME}/Modèles"
}
