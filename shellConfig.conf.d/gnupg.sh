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

alias gpg="gpg2"
alias prv="gpg -K"
alias pub="gpg --list-public-keys"

export_gpg_full_keys_and_revocation() {
    local TEMP_DIR="GPG_PrivateKeys_$(date +%Y-%m-%d-%H-%M-%S)"
    local DEST_TAR="${TEMP_DIR}.tar"

    # Vérification de l'existence de la clef privée principale
    if [ -z ${GPG_MAIN_KEY_ID+x} ] || ! gpg -K|egrep "sec .*/0x[0-9A-Z]{8}${GPG_MAIN_KEY_ID}" > /dev/null; then
        Log ${ERROR} "La clef principale doit être complète pour pouvoir être exportée correctement."
        return
    fi

    Log ${INFO} "Afin d'exporter les clefs, veuillez vous munir des clefs de déchiffrement de la clé : ${KEY_ID}."
    Log ${INFO} "Appuyez sur « Entrée » pour continuer."
    read

    Log ${INFO} "Export des clefs privées..."

    # Preparation de l'environnement
    mkdir "${TEMP_DIR}"

    Log ${DEBUG} "Export du manifeste de la clef."
    gpg -K > "${TEMP_DIR}"/Manifest.txt

    Log ${DEBUG} "Export de la clef privée principale."
    gpg  --output "${TEMP_DIR}"/FULL_SecretKey_"${GPG_MAIN_KEY_ID}".asc --export-secret-keys --armor "${GPG_MAIN_KEY_ID}"
    Log ${DEBUG} "Export des sous-clefs de la clef principale."
    for subkey_id in $GPG_SUBKEY_IDS; do
        export_gpg_subkey "${subkey_id}" "${TEMP_DIR}/SUB_SecretKey_${subkey_id}.asc";
    done

    Log ${DEBUG} "Génération d'un certificat de révocation."
    gpg --output "${TEMP_DIR}"/REV_"${GPG_MAIN_KEY_ID}".gpg --gen-revoke --armor "${GPG_MAIN_KEY_ID}"

    # Archivage des clefs
    tar cf "${DEST_TAR}" "${TEMP_DIR}"

    Log ${DEBUG} "Suppression des fichiers temporaires..."
    find "${TEMP_DIR}" -type f -exec shred -u {} \;
    rmdir "${TEMP_DIR}"

    # Chiffrement de l'archive pour la clef chiffrée
    gpg2 --output "${DEST_TAR}".gpg --encrypt --recipient "${GPG_MAIN_KEY_ID}" "${DEST_TAR}"

    Log ${INFO} "Chiffrer également les clefs avec une méthode symétrique ? [O/n]"
    read reponseQuestion
    case "${reponseQuestion}" in
        o|O) Log ${INFO} "Chiffrement de l'archive..."
             gpg2 --output Symmetric-"${DEST_TAR}".gpg --symmetric "${DEST_TAR}";;
        n|N|*) Log ${INFO} "Abandon de la procédure de chiffrement symétrique.";;
    esac

    Log ${DEBUG} "Suppression de l'archive temporaires..."
    shred -u "${DEST_TAR}"
}

## @fn export_gpg_subkey
## @param string subkey_id
## @param string destination_file
export_gpg_subkey() {
    if [ $# -eq 2 ]; then
        local subkey_id="${1}"
        local destination_file="${2}"
        gpg --output "${destination_file}" --export-secret-subkeys --armor "${subkey_id}"!
    else
        Log ${ERROR} "Arguments manquants : subkey_id destination_file"
    fi
}
