#!/bin/bash

mode=w
interactive=n
justecho=n
dopush=n
webhome=/var/www/vhosts/
mailhome=/var/qmail/mailnames/

function interactive_select() {
        count=1
        for item in $1; do
                printf "%3d: %s\n" $count $item 1>&2
                count=$(($count + 1))
        done
        echo ' ' 1>&2
        echo -n 'Your selection: ' 1>&2
        read selected
        echo $1 | awk '{print $'${selected}'}'
}

OPTIND=1
while getopts 'imweph' opt; do
        case "$opt" in
                'i')
                        interactive=y
                        ;;
                'm')
                        mode=m
                        ;;
                'w')
                        mode=w
                        ;;
                'e')
                        justecho=y
                        ;;
                'p')
                        dopush=y
                        ;;
                *)
                        echo ' Syntax: goto [-[w|m]ieph] match'
                        echo ' '
                        echo ' Flags:'
                        echo '  -w Goto web dir [default, overrides -m in case of -wm]'
                        echo '  -m Goto mail dir'
                        echo '  -i Run interactively'
                        echo '     Will show a list if more than one domain matches.'
                        echo "  -e Just echo result, don't cd to dir."
                        echo '  -p Use pushd instead of cd'
                        echo '  -h Show this help'
                        return
                        ;;
        esac
done

shift $((OPTIND-1))
if [ $# -lt 1 ]; then
        echo "No match string provided."
        return 1
fi
matchstr=$1

if [ "$mode" == 'm' ]; then
        searchdir=$mailhome
else
        searchdir=$webhome
fi

res="$(ls $searchdir | grep "$matchstr" )"
if [[ -z "$res" ]]; then
        echo "No results found."
        return 1
fi
rescount=$(echo $res | wc -w)
if [ "$rescount" -gt 1  ]; then
        # suppress message for interactive and justecho executions
        if [ $interactive == 'n' -a $justecho == 'n' ]; then
                echo "Found ${rescount} results."
                echo "Use -i flag for interactive selection."
        fi
fi

if [ $interactive == 'y' -a $rescount -gt 1 ]; then
        domain=$(interactive_select "$res")
else
        domain=$(echo $res | awk '{print $1}')
fi

if [ $justecho == 'y' ]; then
        echo ${searchdir}${domain}
elif [ $dopush == 'y' ]; then
        pushd ${searchdir}${domain} >> /dev/null
else
        cd ${searchdir}${domain}
fi
