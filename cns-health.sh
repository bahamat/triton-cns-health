#!/bin/bash -x

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2016, Brian Bennett.

if [[ $(zonename) == global ]]; then
    printf "This can only be used in non-global zones\n"
    exit 1
fi

dirname="${0%/*}"   # Same as $(dirname $0)
basename="${0##*/}" # Same as $(basename $0)

source /lib/svc/share/smf_include.sh

function check_health () {
    result=0
    for check in ${dirname}/check.d/*.sh; do
        $check
        result=$(( result + $? ))
    done
    if (( result == 0 )); then
        enable_cns
    else
        disable_cns
    fi
}

function set_cns_status () {
    status=$(mdata-get triton.cns.status)
    [[ ${status:up} == $1 ]] || mdata-put triton.cns.status "$1"
}

function disable_cns () {
    set_cns_status down
}

function enable_cns () {
    set_cns_status up
}

function method_start () {
    while :; do
        check_health
        sleep 60
    done
}

trap disable_cns EXIT

action=${*:OPTIND:1}
self=${*:OPTIND:2}

case $action in
    start)
        # Disable right off the bat, just in case we didn't go down cleanly
        # e.g., in the event of a panic. This ensures that long health checks
        # don't delay removal of broken services at boot.
        disalbe_cns
        method_start
        ;;
    stop)
        method_stop
        ;;
    refresh)
        exit 0
        ;;
    *)
        printf 'Action was %s\n' "$action"
        exit "$SMF_EXIT_ERR_FATAL"
        ;;
esac

exit 0
