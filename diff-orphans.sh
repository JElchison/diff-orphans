#!/bin/bash

# diff-orphans.sh
#
# Bash script to efficiently identify orphaned files in large trees.  Useful for sanity-checking after copying large trees.  This script should be capable of running in OS X or in Linux.
#
# Version 1.0.5
#
# Copyright (C) 2016 Jonathan Elchison <JElchison@gmail.com>
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
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


# setup Bash environment
set -euf -o pipefail

#######################################
# Prints script usage to stderr
# Arguments:
#   None
# Returns:
#   None
#######################################
print_usage() {
    echo "Usage:  $0 <leftTree> <rightTree>" >&2
}


###############################################################################
# test dependencies
###############################################################################

echo "[+] Testing dependencies..." >&2
if [[ ! -x $(which readlink) ]] ||
   [[ ! -x $(which find) ]] ||
   [[ ! -x $(which sort) ]] ||
   [[ ! -x $(which sed) ]] ||
   [[ ! -x $(which diff) ]]; then
    echo "[-] Dependencies unmet.  Please verify that the following are installed, executable, and in the PATH:  readlink, find, sort, sed, diff" >&2
    exit 1
fi


###############################################################################
# validate arguments
###############################################################################

echo "[+] Validating arguments..." >&2

# require exactly 2 arguments
if [[ $# -ne 2 ]]; then
    print_usage
    exit 1
fi

# setup variables for arguments
DIR_LEFT=$(readlink -f "$1")
DIR_RIGHT=$(readlink -f "$2")

# ensure arguments are valid directories
if [[ ! -e $DIR_LEFT ]]; then
    echo "[-] '$DIR_LEFT' does not exist" >&2
    print_usage
    exit 1
fi
if [[ ! -e $DIR_RIGHT ]]; then
    echo "[-] '$DIR_RIGHT' does not exist" >&2
    print_usage
    exit 1
fi


###############################################################################
# perform diff of trees
###############################################################################

echo "[+] Performing diff of trees..." >&2
diff <(find "$DIR_LEFT" | sort | sed "s|^$DIR_LEFT[/]*||g") <(find "$DIR_RIGHT" | sort | sed "s|^$DIR_RIGHT[/]*||g") && echo "[*] No orphans found"


###############################################################################
# report status
###############################################################################

echo "[*] Success" >&2

