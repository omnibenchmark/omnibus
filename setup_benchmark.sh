#!/bin/bash
#
# Template for setting up a full benchmark
# Author: Søren Helweg Dam
#
# Setup virtual environment
# source setup_env.sh


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
		-token "${token}" \
		-template_id "orchestrator" \
		-template_source "${TEMSOURCE}" \
		-template_ref "CLI_dev" \
		-mkey "orchestrator" \
		-ptitle "${PTITLE}"
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
		-token "${token}" \
		-template_id "omni-param-py" \
		-template_source "${TEMSOURCE}" \
		-template_ref "CLI_main" \
		-mkey "parameters" \
		-ptitle "${PTITLE}"
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
		-token "${token}" \
		-template_id "${TEMPLATES[$i]}" \
		-template_source "${TEMSOURCE}" \
		-template_ref "${TEMREF}" \
		-mkey "${KEYWORDS[$i]}" \
		-ptitle "${PTITLE}"
done
