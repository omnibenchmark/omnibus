#!/bin/bash
#
# Create a single repo
# Author: Søren Helweg Dam
# Adapted from Izaskun Mallona

while getopts ":bm:d:g:ns:r:v:gu:ge:token:ptitle:mkey:template_id:template_source:template_ref:" opt; do
  case $opt in
    r) REPONAME="$OPTARG"
    ;;
    d) DIR="$OPTARG"
    ;;
    bm) BENCHMARK="$OPTARG"
    ;;
    ns) NAMESPACE_ID="$OPTARG"
    ;;
    g) GROUPNAME="$OPTARG"
    ;;
    v) VISIBILITY="$OPTARG"
    ;;
    gu) GLUSERNAME="$OPTARG"
	;;
	ge) USEREMAIL="$OPTARG"
    ;;
    token) token="$OPTARG"
    ;;
    mkey) KEYWORD="$OPTARG"
    ;;
    ptitle) TITLE="$OPTARG"
    ;;
    template_id) TEMID="$OPTARG"
    ;;
    template_source) TEMSOURCE="$OPTARG"
    ;;
    template_ref) TEMREF="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

#Namespace=$(echo "${NAMESPACE}/${REPONAME}" | tr '[:upper:]' '[:lower:]')
#NAME_SPACE="${NAMESPACE} / ${REPONAME}"

# Edit working directory
WD=pwd
DIR=${DIR:-false}
if [[ $DIR != false ]]; then
    mkdir -p $DIR
    cd $DIR
fi

# Edit group
GROUPID=${GROUPID:-false}
GROUPNAME=${GROUPNAME:-false}



## creating a (public) repo via API ######################################################

if [[ $NAMESPACE_ID = false ]]; then
    NAMESPACE=$GLUSERNAME
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


git clone https://oauth2:"$token"@renkulab.io/gitlab/"$NAMESPACE"/"$REPONAME".git

cd "$REPONAME"

git config --global --add user.name "${GLUSERNAME}"
git config --global --add user.email "${USEREMAIL}"
git remote set-url origin https://oauth2:"$token"@renkulab.io/gitlab/"$NAMESPACE"/"$REPONAME".git
git switch -c main

## renkufy the repo using an omnibenchmark (dataset) template ###########################
##   will ask interactively to fill other params (press enter and/or fill them)

renku init  --template-source $TEMSOURCE \
      --template-ref $TEMREF \
      --template-id $TEMID \
      --parameter "metric_keyword"=$KEYWORD \
      --parameter "project_title"=$TITLE \
      --parameter "dataset_keyword"="${BENCHMARK}_${REPONAME}" \
      --parameter "sanitized_name"=${BENCHMARK} \
      --parameter "metadata_description"="Metadata Description" \
      --parameter "study_link"="" \
      --parameter "study_note"="" \
      --parameter "study_tissue"=""


## the command above already committed changes
git log

## so push to remote to trigger a docker image generation via CI/CD
##   be aware of your `mastercopy` branch, is it named `master` or `main`?
git push --set-upstream origin main

echo "Project created at: https://renkulab.io/gitlab/${NAMESPACE}/${REPONAME}."

cd $WD
