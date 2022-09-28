#!/bin/bash
#---
declare -A meta_=() && meta_=(
    [name]="skel.sh"
    [info]="bash4+ skelleton"
    [version]="0.1"
    [date]="2022-09-28"
    [author]="shelldorado"
    [usage]="COMMAND [OPTION]"
)                                                                               &&
#---

## CONFIG
declare -A conf_=() && conf_=(
    [ts]="$( date +%s )"
)                                                                               &&

## PATH
declare -A dir_=() && dir_=(
    [pwd]="${PWD}"
)                                                                               &&

## COMMAND
declare -A com_=() && com_=(
    [help]="            Show this help"
    [env]="             Show environment"
)                                                                               &&

com_help() {
    declare -a out__=() && out__=(
        "# ${meta_[name]}" "${meta_[info]}"                             $'\n'
        "## VERSION"       "  ${meta_[version]} (${meta_[date]})"       $'\n'
        "## USAGE"         "  ${0} ${meta_[usage]}"                     $'\n'
        "## COMMANDS" ''
    )                                                                           &&
    while IFS= read -r line ; do
        [[ "${com_[${line}]}" =~ ^([^[:space:]]*)[[:space:]]*(.*)$ ]]
        out__+=(
            "  ${line}${BASH_REMATCH[1]:+ ${BASH_REMATCH[1]}}"
            "          ${BASH_REMATCH[2]}"
            ''
        )
    done <<< "$( say ${!com_[@]} | sort )"                                      &&
    printf "%s\n\n  %s%s\n" "${out__[@]}"
}

com_env() {

    printf "%s\n" "## conf"
    for i in ${!conf_[@]} ; do
        printf "%s\t%s\n" "${i}" "${conf_[${i}]}"
    done |
    sort

    printf "%s\n" "## dir"
    for i in ${!dir_[@]} ; do
        printf "%s\t%s\n" "${i}" "${dir_[${i}]}"
    done |
    sort
}

## LIB
say() { printf -- "%s\n" "${@}" ; }                                             &&
err() { say "${0}: aborted: ${1}" "Try \`${0} help\` for usage." 1>&2 ; }       &&

## RUN
run() {

    # optarg
    set -- "${@:-help}"                                                         &&
    [[ "${1}" =~ ^([[:alpha:]]([-]?[[:alnum:]]+)*)$ ]]                          &&
    [[ "${com_[${1}]-invalid}" != invalid ]]                                    &&
    : || { err "mad usage: ${1}" ; return 1 ; }

    # command
    shift                                                                       &&
    com_${BASH_REMATCH[1]} "${@}"                                               &&
    : || return 1
}                                                                               &&
run "${@}"
 
