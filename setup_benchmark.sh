#!/bin/bash
#
# Template for setting up a full benchmark
# Author: Søren Helweg Dam

# Setup virtual environment
# source setup_env.sh

while getopts ":c:" opt; do
  case $opt in
    c) CONFIG="$OPTARG"
    ;;
    o) ORCHESTRATOR="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Load configuration settings
source $CONFIG

ORCHESTRATOR=${ORCHESTRATOR:-true}

# Build orchestrator
if [[ $ORCHESTRATOR = true ]]; then
	./create_repo.sh \
		-r "orchestrator" \
		-bm $BENCHMARK \
		-d $DIR \
		-ns $NAMESPACE_ID \
		-gu $GLUSERNAME \
		-ge $USEREMAIL \
		-v $VISIBILITY \
		-g $GROUPNAME \
		-token $token \
		-template_id "orchestrator" \
		-template_source $TEMSOURCE \
		-template_ref "dev" \
		-mkey "orchestrator" \
		-ptitle $PTITLE
fi

for (( i = 0; i <${#REPONAMES[@]}; i++ )); do
	#statements
	./create_repo.sh \
		-r ${#REPONAMES[$i]} \
		-bm $BENCHMARK \
		-ns $NAMESPACE_ID \
		-d $DIR \
		-gu $GLUSERNAME \
		-ge $USEREMAIL \
		-v $VISIBILITY \
		-g $GROUPNAME \
		-token $token \
		-template_id ${#TEMPLATES[$i]} \
		-template_source $TEMSOURCE \
		-template_ref $TEMREF \
		-mkey ${#KEYWORDS[$i]} \
		-ptitle $PTITLE
done
