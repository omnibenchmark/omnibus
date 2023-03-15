#!/bin/bash
#
# Template for setting up a full benchmark
# Author: Søren Helweg Dam


usage(){
    echo ""
    echo "Usage: bash ""$(basename "$0")"" -o -p -s -c CONFIGFILE"
    echo ""
    echo "Params"
    echo " -c   		Config file"
    echo " -p   		Create parameters project"
    echo " -o   		Create Orchestrator"
    echo " -s			Create Summary"
    echo " --token		Personal Access Token with API permissions"
    echo " -r			Name of single repository to create"
    echo " -k			Name of keyword for single repository"
    echo " -t			Name of template to use for single repository"
    echo " --ignore_kgi	Ignore Renku Knowledge Graph Integration"
    echo ""
}

while [ "$1" != "" ]; do
    case $1 in
        -c)           			shift
                               	CONFIG="$1"
                               	;;
        -o) ORCHESTRATOR=true
                               	;;
        -p) PARAMETERS=true
                              	;;
        -s) SUMMARY=true
                              	;;
        -op) ORCHESTRATOR=true
			 PARAMETERS=true
                              	;;
        -ops) ORCHESTRATOR=true
			  PARAMETERS=true
			  SUMMARY=true
                              	;;
		--token)           			shift
                               	TOKEN="$1"
                               	;;
		-r)           			shift
                               	REPO="$1"
                               	;;
		-k)           			shift
                               	KEY="$1"
                               	;;
		-t)           			shift
                               	TEMP="$1"
                               	;;
        --ignore_kgi) KGI=false
                                ;;
        -h | --help )          	usage
                               	exit
                               	;;
        * )                    	usage
                               	exit 1
    esac
    shift
done

# Load configuration settings
source $CONFIG

# Set default KGI
KGI=${KGI:-true}

# Overwrite config vars for those given as input
token=${TOKEN:-$token}
REPONAMES=(${REPO:-${REPONAMES[@]}})
PTITLES=(${REPO:-${REPONAMES[@]}})
KEYWORDS=(${KEY:-${KEYWORDS[@]}})
TEMPLATES=(${TEMP:-${TEMPLATES[@]}})

# Error checks

## All lists have equal length
if [ "${#REPONAMES[@]}" -ne "${#TEMPLATES[@]}" ] || [ "${#TEMPLATES[@]}" -ne "${#KEYWORDS[@]}" ] || [ "${#KEYWORDS[@]}" -ne "${#PTITLES[@]}" ]; then
	echo "Please make sure all lists have the same lengths."
	echo "KEYWORDS: ${KEYWORDS[@]}"
	echo "REPONAMES: ${REPONAMES[@]}"
	echo "TEMPLATES: ${TEMPLATES[@]}"
	echo "PTITLES: ${PTITLES[@]}"
	exit 1
fi


# Build Orchestrator

if [ $ORCHESTRATOR ]; then
	omnicast \
		-r "orchestrator" \
		-bm "${BENCHMARK}" \
		-d "${DIR}" \
		-ns "${NAMESPACE_ID}" \
		-u "${GLUSERNAME}" \
		-e "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		--token "${token}" \
		-ti "orchestrator" \
		-ts "${TEMSOURCE}" \
		-tb "CLI_dev" \
		-k "orchestrator" \
		-pt "orchestrator" \
		--ignore_kgi "${KGI}"
fi

# Build Parameters

if [ $PARAMETERS ]; then
	omnicast \
		-r "parameters" \
		-bm "${BENCHMARK}" \
		-d "${DIR}" \
		-ns "${NAMESPACE_ID}" \
		-u "${GLUSERNAME}" \
		-e "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		--token "${token}" \
		-ti "omni-param-py" \
		-ts "${TEMSOURCE}" \
		-tb "CLI_main" \
		-k "parameters" \
		-pt "parameters" \
		--ignore_kgi "${KGI}"
fi

# Build Summary

if [ $SUMMARY ]; then
	omnicast \
		-r "${BENCHMARK}_summary" \
		-bm "${BENCHMARK}" \
		-d "${DIR}" \
		-ns "${NAMESPACE_ID}" \
		-u "${GLUSERNAME}" \
		-e "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		--token "${token}" \
		-ti "metric_summary" \
		-ts "${TEMSOURCE}" \
		-tb "CLI_dev" \
		-k "${BENCHMARK}_summary" \
		-pt "${BENCHMARK}_summary" \
		--ignore_kgi "${KGI}"
fi

# Build manually defined projects

for (( i = 0; i <${#REPONAMES[@]}; i++ )); do
	omnicast \
		-r "${REPONAMES[$i]}" \
		-bm "${BENCHMARK}" \
		-ns "${NAMESPACE_ID}" \
		-d "${DIR}" \
		-u "${GLUSERNAME}" \
		-e "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		--token "${token}" \
		-ti "${TEMPLATES[$i]}" \
		-ts "${TEMSOURCE}" \
		-tb "${TEMREF}" \
		-k "${KEYWORDS[$i]}" \
		-pt "${PTITLES[$i]}" \
		--ignore_kgi "${KGI}"
done
