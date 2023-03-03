#!/bin/bash
#
# Template for setting up a full benchmark
# Author: Søren Helweg Dam
# Date: 03-MAR-2023

usage(){
    echo ""
    echo "Usage: bash ""$(basename "$0")"" -o -p -c config_file"
    echo ""
    echo "Params"
    echo " -c    config file"
    echo " -p    Create parameters project"
    echo " -o    Create Orchestrator"
    echo ""
}

while [ "$1" != "" ]; do
    case $1 in
        -c)           shift
                               CONFIG="$1"
                               ;;
        -o) ORCHESTRATOR=true
                               ;;
        -p) PARAMETERS=true
                               ;;
        -h | --help )          usage
                               exit
                               ;;
        * )                    usage
                               exit 1
    esac
    shift
done

# Load configuration settings
source $CONFIG

# Error checks

if [ ${#REPONAMES} -eq ${#TEMPLATES} ] && [ ${#TEMPLATES} -eq ${#KEYWORDS} ] && [ ${#KEYWORDS} -eq ${#PTITLE} ]; then
	echo "Please make sure all lists have the same lengths."
	exit 1
fi


# Build Orchestrator

if [ $ORCHESTRATOR ]; then
	./create_repo.sh \
		-r "orchestrator" \
		-bm "${BENCHMARK}" \
		-d "${DIR}" \
		-ns "${NAMESPACE_ID}" \
		-gu "${GLUSERNAME}" \
		-ge "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		-t "${token}" \
		-ti "orchestrator" \
		-ts "${TEMSOURCE}" \
		-tb "CLI_dev" \
		-k "orchestrator" \
		-pt "orchestrator"
fi

# Build Parameters

if [ $PARAMETERS ]; then
	./create_repo.sh \
		-r "parameters" \
		-bm "${BENCHMARK}" \
		-d "${DIR}" \
		-ns "${NAMESPACE_ID}" \
		-gu "${GLUSERNAME}" \
		-ge "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		-t "${token}" \
		-ti "omni-param-py" \
		-ts "${TEMSOURCE}" \
		-tb "CLI_main" \
		-k "parameters" \
		-pt "parameters"
fi

# Build manually defined projects

for (( i = 0; i <${#REPONAMES[@]}; i++ )); do
	#statements
	./create_repo.sh \
		-r "${REPONAMES[$i]}" \
		-bm "${BENCHMARK}" \
		-ns "${NAMESPACE_ID}" \
		-d "${DIR}" \
		-gu "${GLUSERNAME}" \
		-ge "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		-t "${token}" \
		-ti "${TEMPLATES[$i]}" \
		-ts "${TEMSOURCE}" \
		-tb "${TEMREF}" \
		-k "${KEYWORDS[$i]}" \
		-pt "${PTITLES[$i]}"
done
