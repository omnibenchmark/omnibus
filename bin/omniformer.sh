#!/bin/bash
#
# Template for setting up a full benchmark
# Author: Søren Helweg Dam


usage(){
    echo ""
    echo "Usage: bash ""$(basename "$0")"" -o -p -c config_file"
    echo ""
    echo "Params"
    echo " -c    config file"
    echo " -p    Create parameters project"
    echo " -o    Create Orchestrator"
    exho " -t	 Personal Access Token with API permissions () overwrites the config token, if one was given there"
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
        -op) ORCHESTRATOR=true
			 PARAMETERS=true
                              	;;
		-t)           			shift
                               	TOKEN="$1"
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

token=${TOKEN:-token}


# Error checks

if [ ${#REPONAMES} -eq ${#TEMPLATES} ] && [ ${#TEMPLATES} -eq ${#KEYWORDS} ] && [ ${#KEYWORDS} -eq ${#PTITLE} ]; then
	echo "Please make sure all lists have the same lengths."
	exit 1
fi


# Build Orchestrator

if [ $ORCHESTRATOR ]; then
	omnibuild \
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
	omnibuild \
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
	omnibuild \
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
