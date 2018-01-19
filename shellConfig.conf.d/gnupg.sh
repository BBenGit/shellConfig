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

alias gpg="gpg2"
alias prv="gpg -K"
alias pub="gpg --list-public-keys"

export_private_keys(){
    local TEMP_DIR="Clefs privées - $(date +%Y-%m-%d-%H-%M-%S)"
    local DEST_TAR="${TEMP_DIR}.tar"

    Log ${INFO} "Afin d'exporter les clefs, veuillez vous munir des clefs de déchiffrement de la clé : ${KEY_ID}."
    Log ${INFO} "Appuyez sur « Entrée » pour continuer."
    read

    # Preparation de l'environnement
    mkdir "${TEMP_DIR}"

    # Export des clefs
    gpg --export-secret-keys --armor "${GPG_MAIN_KEY_ID}" > "${TEMP_DIR}"/GB_FULL_SecretKey_"${GPG_MAIN_KEY_ID}".asc
    gpg --gen-revoke --armor "${GPG_MAIN_KEY_ID}"  > "${TEMP_DIR}"/GB_REV_"${GPG_MAIN_KEY_ID}".gpg

    # Archivage des clefs
    tar cvf "${DEST_TAR}" "${TEMP_DIR}"

    Log ${DEBUG} "Suppression des fichiers temporaires..."
    find "${TEMP_DIR}" -type f -exec shred -u {} \;
    rmdir "${TEMP_DIR}"

    # Chiffrement de l'archive pour la clef chiffrée
    gpg2 --output "${DEST_TAR}".gpg --encrypt --recipient "${GPG_MAIN_KEY_ID}" "${DEST_TAR}"

    # Demande de chiffrement pour l'utilisateur
    Log ${INFO} "Chiffrer également les clefs avec une méthode symétrique ? [O/n]"
    read reponseQuestion
    case "${reponseQuestion}" in
        o|O) Log ${INFO} "Chiffrement de l'archive...\n"
             gpg2 --output "${DEST_TAR}"symmetric.gpg --symmetric "${DEST_TAR}";;
        n|N|*) Log ${INFO} "Abandon de la procédure de chiffrement symétrique.";;
    esac

    Log ${DEBUG} "Suppression de l'archive temporaires..."
    shred -u "${DEST_TAR}"
}
