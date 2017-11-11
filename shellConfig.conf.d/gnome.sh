#!/bin/bash
##
##  Copyright (C) 2016, 2017  Guillaume Bernard
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

declare -x GNOME_SETTINGS_DIR="${CONFIGURATION_FILES_DIRECTORY}/local/gnome"
declare -x GNOME_SHELL_EXTENSIONS="${GNOME_SETTINGS_DIR}/shell/extensions"
declare -x DCONF_SETTINGS="${GNOME_SETTINGS_DIR}/dconf.settings"
declare -x GTK_BOOKMARKS="${GNOME_SETTINGS_DIR}/bookmarks"
declare -x GNOME_OTHER_SETTINGS="${GNOME_SETTINGS_DIR}/settings.ini"
declare -x XDG_USER_DIRS="${GNOME_SETTINGS_DIR}/user-dirs.dirs"
declare -x XDG_USER_DIRS_LOCALE="${GNOME_SETTINGS_DIR}/user-dirs.locale"

expGnome(){
    Log ${INFO} "Exporting GNOME parameters..."
    
    Log ${DEBUG} "1. dconf database."
    rm -f "${DCONF_SETTINGS}"
    dconf dump / > "${DCONF_SETTINGS}"
    
    Log ${DEBUG} "2. Nautilus bookmarks."
    local installed_gtk_bookmarks="${HOME}/.config/gtk-3.0/bookmarks"
    [[ ! "$(realpath ${installed_gtk_bookmarks})" == "${GTK_BOOKMARKS}" ]] && cp -Lf "${installed_gtk_bookmarks}" "${GTK_BOOKMARKS}"
    
    Log ${DEBUG} "3. Other GNOME parameters."
    local installed_gnome_settings="${HOME}/.config/gtk-3.0/settings.ini"
    [[ ! "$(realpath ${installed_gnome_settings})" == "${GNOME_OTHER_SETTINGS}" ]] && cp -Lf "${installed_gnome_settings}" "${GNOME_OTHER_SETTINGS}"
    
    Log ${DEBUG} "4. User default directories."
    local installed_xdg_user_dirs="${HOME}/.config/user-dirs.dirs"
    local installed_xdg_user_dirs_locale="${HOME}/.config/user-dirs.locale"
    [[ ! "$(realpath "${installed_xdg_user_dirs}")" == "${XDG_USER_DIRS}" ]] && cp -Lf "${installed_xdg_user_dirs}" "${XDG_USER_DIRS}"
    [[ ! "$(realpath "${installed_xdg_user_dirs_locale}")" == "${XDG_USER_DIRS_LOCALE}" ]] && cp -Lf "${installed_xdg_user_dirs_locale}" "${XDG_USER_DIRS_LOCALE}"
}

loadGnome(){
    Log ${INFO} "Loading GNOME parameters..."
    
    Log ${DEBUG} "1. dconf database."
    dconf load / < "${DCONF_SETTINGS}"
    
    Log ${DEBUG} "2. Nautilus bookmarks."
    ln -sf "${GTK_BOOKMARKS}" "${HOME}/.config/gtk-3.0/bookmarks"
    
    Log ${DEBUG} "3. Other GNOME parameters."
    ln -sf "${GNOME_OTHER_SETTINGS}" "${HOME}/.config/gtk-3.0/settings.ini"
    
    Log ${DEBUG} "4. User default directories."
    ln -sf "${XDG_USER_DIRS}" "${HOME}/.config/user-dirs.dirs"
    ln -sf "${XDG_USER_DIRS_LOCALE}" "${HOME}/.config/user-dirs.locale"

    Log ${DEBUG} "5. GNOME Shell extensions."
    ln -sf "${GNOME_SHELL_EXTENSIONS}" "${HOME}/.local/share/gnome-shell/extensions"
}


