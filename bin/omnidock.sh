#!/bin/bash
#
# Create docker image of repo registry
# Author: Søren Helweg Dam
#
# Adapted from Izaskun Mallona

usage(){
    echo ""
    echo "Usage: See the 'config_template' file for more details"
    echo ""
    echo "Params"
    echo " -r    Reponame"
    echo " -g    Group name"
    echo " -i    Image ID"
    echo " -gu   gitlab username"
    echo " -ge   gitlab email"
    echo " -t    Personal Access Token"
    exho " -c    Clone only (does not use docker)"
    echo ""
}


while [ "$1" != "" ]; do
    case $1 in
        -r)           shift
                               REPONAME="$1"
                               ;;
        -g)       shift
                               GROUPNAME=$1
                               ;;
        -i)       shift
                               IMAGEID=$1
                               ;;
        -gu)       shift
                               GLUSERNAME=$1
                               ;;
        -ge)       shift
                               USEREMAIL=$1
                               ;;
        -t)       shift
                               token=$1
                               ;;
        -c) CLONE=true
                               ;;
        -h | --help )          usage
                               exit
                               ;;
        * )                    usage
                               exit 1
    esac
    shift
done


if [[ $CLONE = false ]]; then
    ## docker pull the generated image (the id is the first 7chars of the last git commit pushed to gitlab)  ##

    docker login registry.renkulab.io -u "$GLUSERNAME" -p "$token"

    docker run -it -e GLUSERNAME="$GLUSERNAME" -e GROUPNAME="$GROUPNAME" -e REPONAME="$REPONAME" -e token="$token" -e USEREMAIL="$USEREMAIL"\
           registry.renkulab.io/"$GROUPNAME"/"$REPONAME":"$IMAGEID" /bin/bash
fi

## now we're inside the omnibenchmark-capable container but we don't have the code there (!)
##   let's clone the repo again, to have both code (omb-templated) + soft stack +
##   renkulab compatibility (that is, if you commit and push changes here, you can start a
##   renkulab session on the resulting image afterwards)

git config --global --add user.name "${GLUSERNAME}"
git config --global --add user.email "${USEREMAIL}"

git clone https://oauth2:"$token"@renkulab.io/gitlab/"$GROUPNAME"/"$REPONAME".git

cd $REPONAME

git remote set-url origin https://oauth2:"$token"@renkulab.io/gitlab/"$GROUPNAME"/"$REPONAME".git

git lfs install --local


echo "You are now ready to make changes in the repo."
