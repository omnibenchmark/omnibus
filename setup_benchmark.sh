#!/bin/bash
#
# Template for setting up a full benchmark
# Author: Søren Helweg Dam

# Setup virtual environment
# source setup_env.sh

while [ "$1" != "" ]; do
    case $1 in
        -c)           shift
                               CONFIG="$1"
                               ;;
        -o)       shift
                               ORCHESTRATOR=$1
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

ORCHESTRATOR=${ORCHESTRATOR:-true}

# Build orchestrator
if [[ $ORCHESTRATOR = true ]]; then
	bash create_repo.sh \
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
		-template_ref "dev" \
		-mkey "orchestrator" \
		-ptitle "${PTITLE}"
fi

for (( i = 0; i <${#REPONAMES[@]}; i++ )); do
	#statements
	bash create_repo.sh \
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
