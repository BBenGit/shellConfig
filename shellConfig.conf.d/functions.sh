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

## @fn refresh
## @brief Reload the shell configuration
refresh()
{
    Log ${INFO} "Reloading configuration"
    if [ -n "$ZSH_NAME" ]; then
        source "${HOME}/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        source "${HOME}/.bashrc"
    fi
}

## @fn importConf
## @brief Import configuration files as symlinks.
## @details Thoses configurations files are documented in the wiki.
## It concernes GPG, hidden files, Git, Liferea, ownCloud, and application files
importConf()
{
    local dir="${CONFIGURATION_FILES_DIRECTORY}/local"
    local web="${CONFIGURATION_FILES_DIRECTORY}/web"
    local dir_gpg="${dir}/gpg"
    local dir_git="${dir}/git"
    local rhythmbox="${dir}/rhythmbox"
    local bleachbit="${dir}/bleachbit"
  	
    Log ${INFO} "Lien de la configuration des fichiers à cacher"
    ln -sf "${dir}/hidden" "${HOME}/.hidden"

    Log ${INFO} "Lien de la configuration de GnuPG"
    ln -sf "${dir_gpg}/gpg.conf" "${HOME}/.gnupg/gpg.conf"
    ln -sf "${dir_gpg}/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
    ln -sf "${dir_gpg}/dirmngr.conf" "${HOME}/.gnupg/dirmngr.conf"
       
    Log ${INFO} "Lien de la configuration de VIM"
    ln -sf "${dir}/vimrc" "${HOME}/.vimrc"
        
    Log ${INFO} "Lien de la configuration de Git"
    ln -sf "${dir_git}/gitconfig" "${HOME}/.gitconfig"
    ln -sf "${dir_git}/gitignore_global" "${HOME}/.gitignore_global"

    Log ${INFO} "Lien de la configuration de ownCloud"
    ln -sf "${dir}/owncloud_exclude.lst" "${HOME}/.local/share/data/ownCloud/sync-exclude.lst"

    Log ${INFO} "Lien de la liste de flux pour Liferea"
    ln -sf "${web}/feedlist.opml" "${HOME}/.config/liferea/feedlist.opml"

    Log ${INFO} "Configuration des listes et des radios de Rhythmbox"
    ln -sf "${rhythmbox}/playlists.xml" "${HOME}/.local/share/rhythmbox/playlists.xml"
    ln -sf "${rhythmbox}/rhythmdb.xml" "${HOME}/.local/share/rhythmbox/rhythmdb.xml"

    Log ${INFO} "Configuration pour Bleachbit"
    ln -sf "${bleachbit}/bleachbit.ini" "${HOME}/.config/bleachbit/bleachbit.ini"

    Log ${INFO} "Lien de fichiers d'applications"
    if [[ ! -h "${HOME}/.local/share/applications" ]]; then
        rm -rf "${HOME}/.local/share/applications"
        ln -sf "${dir}/applications/" "${HOME}/.local/share/applications"
    fi

    Log ${INFO} "Lien de fichiers de démarrage automatique d'applications"
    if [[ ! -h "${HOME}/.config/autostart" ]]; then
        rm -rf "${HOME}/.config/autostart"
        ln -sf "${dir}/autostart/" "${HOME}/.config/autostart"
    fi

    Log ${INFO} "Configuration pour shellConfig"
    ln -sf "${dir}/shellconfig.vars" "${SHELLCONFIG_CONF}"

    Log ${INFO} "Configuration pour Redshift"
    ln -sf "${dir}/redshift.conf" "${HOME}/.config/redshift.conf"
        
    loadGnome
    
    refresh
}

## @fn updateKit
## @brief Update the shellConfig and libShell kits
updateKit()
{
    Log ${INFO} "Mise à jour de la pile logicielle shellConfig et libShell"

    gitPull "$(realpath ${LIBSHELL_DIR})"
    gitPull "$(realpath ${SHELLCONFIG_CONF_DIR})"
}

