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

shopt -s expand_aliases

dirname="${0%/*}"   # Same as $(dirname $0)

if ! [[ -f ./node_modules/smfgen/smfgen ]]; then
    npm install smfgen
fi

[[ -d /opt/custom/smf ]] ||  mkdir -p /opt/custom/smf

alias smfgen="${dirname}/node_modules/smfgen/smfgen"
start_method=$(readlink -e "${dirname}/cns-health.sh")

json -e "start=\"${start_method} %m\"" << JSON | smfgen > /opt/custom/smf/cns-health.xml
{
    "ident": "triton/cns-health",
    "label": "CNS Health Check"
}
JSON
svccfg import /opt/custom/smf/cns-health.xml
