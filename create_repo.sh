#!/bin/bash
#
# Create a single repo
# Author: Søren Helweg Dam
# Adapted from Izaskun Mallona

while getopts ":r:gu:ge:token:ptitle:mkey:template_id:template_source:template_ref:" opt; do
  case $opt in
    r) REPONAME="$OPTARG"
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



## creating a (public) repo via API ######################################################

curl --header "Authorization: Bearer ${token}" \
     --request POST \
     "https://renkulab.io/gitlab/api/v4/projects/?name=${REPONAME}&visibility=public"

## cloning the new (empty) repo in ~/omb  ################################################

mkdir -p ~/omb
cd $_


git clone https://oauth2:"$token"@renkulab.io/gitlab/"$GLUSERNAME"/"$REPONAME".git

cd "$REPONAME"

git config user.name ${GLUSERNAME}
git config user.email ${USEREMAIL}
git remote set-url origin https://renkulab.io/gitlab/"$GLUSERNAME"/"$REPONAME".git

## renkufy the repo using an omnibenchmark (dataset) template ###########################
##   will ask interactively to fill other params (press enter and/or fill them)

renku init  --template-source $TEMSOURCE \
      --template-ref $TEMREF \
      --template-id $TEMID \
      --parameter "metric_keyword"=$KEYWORD \
      --parameter "project_title"=$TITLE

## the command above already committed changes
git log

## so push to remote to trigger a docker image generation via CI/CD
##   be aware of your `mastercopy` branch, is it named `master` or `main`?
git push --set-upstream origin main

echo "CI/CD job https://renkulab.io/gitlab/${GLUSERNAME}/${REPONAME}/-/jobs , please wait till completed"

## docker pull the generated image (the id is the first 7chars of the last git commit pushed to gitlab)  ##

commit7=$(git log | head -1| cut -d" " -f2  | cut -c1-7)

docker login registry.renkulab.io -u "$GLUSERNAME" -p "$token"

docker run -it -e GLUSERNAME="$GLUSERNAME" -e REPONAME="$REPONAME" -e token="$token" -e USEREMAIL="$USEREMAIL"\
       registry.renkulab.io/"$GLUSERNAME"/"$REPONAME":"$commit7" /bin/bash

## now we're inside the omnibenchmark-capable container but we don't have the code there (!)
##   let's clone the repo again, to have both code (omb-templated) + soft stack +
##   renkulab compatibility (that is, if you commit and push changes here, you can start a
##   renkulab session on the resulting image afterwards)

git config --global user.name ${GLUSERNAME}
git config --global user.email ${USEREMAIL}

git clone https://oauth2:"$token"@renkulab.io/gitlab/"$GLUSERNAME"/"$REPONAME".git

cd $REPONAME

git remote set-url origin https://renkulab.io/gitlab/"$GLUSERNAME"/"$REPONAME".git

git lfs install --local

head src/run_workflow.py
chmod +x src/run_workflow.py

## modify the omb module here

## execute, but will raise an error - we haven't updated the script yet!
# python src/run_workflow.py

echo 'if needed, manually renku save/git add, commit, and push to the remote to save changes'
echo '   and trigger the CI/CD to have a fresh image'

git status
git add .
git commit -m "That was a test"
git push # --all origin

## Turn on the KG integration
echo "https://renkulab.io/projects/${GLUSERNAME}/${REPONAME}/overview/status"
