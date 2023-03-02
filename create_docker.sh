## docker pull the generated image (the id is the first 7chars of the last git commit pushed to gitlab)  ##

commit7=$(git log | head -1| cut -d" " -f2  | cut -c1-7)

docker login registry.renkulab.io -u "$GLUSERNAME" -p "$token"

docker run -it -e GLUSERNAME="$GLUSERNAME" -e REPONAME="$REPONAME" -e token="$token" -e USEREMAIL="$USEREMAIL"\
       registry.renkulab.io/"$NAMESPACE"/"$REPONAME":"$commit7" /bin/bash

## now we're inside the omnibenchmark-capable container but we don't have the code there (!)
##   let's clone the repo again, to have both code (omb-templated) + soft stack +
##   renkulab compatibility (that is, if you commit and push changes here, you can start a
##   renkulab session on the resulting image afterwards)

git config --global --add user.name "${GLUSERNAME}"
git config --global --add user.email "${USEREMAIL}"

git clone https://oauth2:"$token"@renkulab.io/gitlab/"$NAMESPACE"/"$REPONAME".git

cd $REPONAME

git remote set-url origin https://oauth2:"$token"@renkulab.io/gitlab/"$NAMESPACE"/"$REPONAME".git

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
echo "https://renkulab.io/projects/${NAMESPACE}/${REPONAME}/overview/status"
