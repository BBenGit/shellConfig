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

__check_key_existence()
{
    if [ -z ${GPG_MAIN_KEY_ID+x} ] || ! gpg -K|egrep "sec .*/0x[0-9A-Z]{8}${GPG_MAIN_KEY_ID}" > /dev/null; then
        Log ${ERROR} "The main key must be complete in order to export it."
        false
    fi
}

export_gpg_full_keys_and_revocation() {

    local TEMP_DIR="GPG_PrivateKeys_$(date +%Y-%m-%d-%H-%M-%S)"
    local DEST_TAR="${TEMP_DIR}.tar"

    # Verifiying the existence of the main gpg key.
    if __check_key_existence "${GPG_MAIN_KEY_ID}"; then

        Log ${INFO} "In order to export your keys, please, get your decryption keys for GPG key : ${KEY_ID}."
        Log ${INFO} "Press \"Enter\" to continue…"
        read
        mkdir "${TEMP_DIR}"

        Log ${INFO} "Exporting private keys…"

        Log ${DEBUG} "Exporting the key manifest…"
        gpg -K > "${TEMP_DIR}"/Manifest.txt

        Log ${DEBUG} "Exporting the main key…"
        gpg  --output "${TEMP_DIR}"/FULL_SecretKey_"${GPG_MAIN_KEY_ID}".asc --export-secret-keys --armor "${GPG_MAIN_KEY_ID}"

        Log ${DEBUG} "Exporting subkeys…"
        for subkey_id in $GPG_SUBKEY_IDS; do
            export_gpg_subkey "${subkey_id}" "${TEMP_DIR}/SUB_SecretKey_${subkey_id}.asc";
        done

        Log ${DEBUG} "Generating a certification certificate…"
        gpg --output "${TEMP_DIR}"/REV_"${GPG_MAIN_KEY_ID}".gpg --gen-revoke --armor "${GPG_MAIN_KEY_ID}"

        tar cf "${DEST_TAR}" "${TEMP_DIR}"

        Log ${DEBUG} "Removing temporary files…"
        find "${TEMP_DIR}" -type f -exec shred -u {} \;
        rmdir "${TEMP_DIR}"

        gpg2 --output "${DEST_TAR}".gpg --encrypt --recipient "${GPG_MAIN_KEY_ID}" "${DEST_TAR}"

        Log ${INFO} "Also encrypt with a symmetric algorithm? [O/n]"
        read reponseQuestion
        case "${reponseQuestion}" in
            o|O) Log ${INFO} "Encrypting tarball…"
                 gpg2 --output Symmetric-"${DEST_TAR}".gpg --symmetric "${DEST_TAR}";;
            n|N|*) Log ${INFO} "Aborting the symmetric encryption procedure.";;
        esac

        Log ${DEBUG} "Secure removal of temporary files…"
        shred -u "${DEST_TAR}"
    fi
}

## @fn export_gpg_subkey
## @param   string  subkey_id
## @param   string  destination_file
export_gpg_subkey() {
    if [ $# -eq 2 ]; then
        local subkey_id="${1}"
        local destination_file="${2}"
        gpg --output "${destination_file}" --export-secret-subkeys --armor "${subkey_id}"!
    else
        Log ${ERROR} "Missing arguments: subkey_id destination_file"
    fi
}
