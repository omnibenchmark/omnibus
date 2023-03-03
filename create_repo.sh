#!/bin/bash
#
# Create a single repo
# Author: Søren Helweg Dam
# Adapted from Izaskun Mallona

while [ "$1" != "" ]; do
    case $1 in
        -r)           shift
                               REPONAME="$1"
                               ;;
        -bm)       shift
                               BENCHMARK=$1
                               ;;
        -d)       shift
                               DIR=$1
                               ;;
        -ns)       shift
                               NAMESPACE_ID=$1
                               ;;
        -gu)       shift
                               GLUSERNAME=$1
                               ;;
        -ge)       shift
                               USEREMAIL=$1
                               ;;
        -v)       shift
                               VISIBILITY=$1
                               ;;
        -g)       shift
                               GROUPNAME=$1
                               ;;
        -token)       shift
                               token=$1
                               ;;
        -template_id)       shift
                               TEMID=$1
                               ;;
        -template_source)       shift
                               TEMSOURCE=$1
                               ;;
        -template_ref)       shift
                               TEMREF=$1
                               ;;
        -mkey)       shift
                               KEYWORD=$1
                               ;;
        -ptitle)       shift
                               TITLE=$1
                               ;;
        -h | --help )          #usage
                               exit
                               ;;
        * )                    #usage
                               exit 1
    esac
    shift
done


#Namespace=$(echo "${NAMESPACE}/${REPONAME}" | tr '[:upper:]' '[:lower:]')
#NAME_SPACE="${NAMESPACE} / ${REPONAME}"
echo "Setting up project with the following settings:"
echo "${BENCHMARK}"
echo "${NAMESPACE_ID}"
echo "${DIR}"
echo "${GROUPNAME}"
echo "${REPONAME}"
echo "${TEMID}"
echo "${VISIBILITY}"
echo "${GLUSERNAME}"
echo "${USEREMAIL}"
echo "${KEYWORD}"
echo "${TITLE}"
echo "${TEMSOURCE}"
echo "${TEMREF}"



# Edit working directory
WD=$(pwd)
DIR=${DIR:-false}
if [[ $DIR != false ]]; then
    mkdir -p $DIR
    cd $DIR
fi

# Edit group
NAMESPACE_ID=${NAMESPACE_ID:-false}
GROUPNAME=${GROUPNAME:-false}



## creating a (public) repo via API ######################################################

if [[ $NAMESPACE_ID = false ]]; then
    NAMESPACE="$GLUSERNAME"
    curl --header "Authorization: Bearer ${token}" \
         --request POST \
         "https://renkulab.io/gitlab/api/v4/projects/?name=${REPONAME}&visibility=${VISIBILITY}"

else
    NAMESPACE=$GROUPNAME
    curl --header "Authorization: Bearer ${token}" \
         --request POST \
         "https://renkulab.io/gitlab/api/v4/projects/?name=${REPONAME}&namespace_id=${NAMESPACE_ID}&visibility=${VISIBILITY}"
fi


## cloning the new (empty) repo in ~/omb  ################################################

#mkdir -p ~/omb
#cd $_


git clone https://oauth2:"$token"@renkulab.io/gitlab/"${NAMESPACE}"/"${REPONAME}".git

cd "$REPONAME"

git config --local --add user.name "${GLUSERNAME}"
git config --local --add user.email "${USEREMAIL}"
git remote set-url origin https://oauth2:"$token"@renkulab.io/gitlab/"$NAMESPACE"/"$REPONAME".git
git switch -c main

## renkufy the repo using an omnibenchmark (dataset) template ###########################
##   will ask interactively to fill other params (press enter and/or fill them)

renku init  --template-source "${TEMSOURCE}" \
      --template-ref "${TEMREF}" \
      --template-id "${TEMID}" \
      --parameter "metric_keyword"="$KEYWORD}" \
      --parameter "project_title"="${TITLE}" \
      --parameter "dataset_keyword"="${KEYWORD}" \
      --parameter "method_keyword"="${KEYWORD}" \
      --parameter "sanitized_project_name"="${REPONAME}" \
      --parameter "metadata_description"="Metadata Description" \
      --parameter "study_link"="" \
      --parameter "study_note"="" \
      --parameter "study_tissue"=""


## the command above already committed changes
# git log

## so push to remote to trigger a docker image generation via CI/CD
##   be aware of your `mastercopy` branch, is it named `master` or `main`?
git push --set-upstream origin main

echo "Project created at: https://renkulab.io/gitlab/${NAMESPACE}/${REPONAME}."

cd $WD
