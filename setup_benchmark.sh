#!/bin/bash


# Setup virtual environment
source setup_env.sh


REPONAMES=["dataset_1", "dataset_2", ]
GLUSERNAME="random.person"
USEREMAIL="random.person@mls.uzh.ch"
## A token with `api` scope at renkulab.io's gitlab
##    (Grants complete read/write access to the API, including all groups and projects,
##     the container registry, and the package registry.)
token="glpat-PDrx1bjCWvblablablablablabla"                 ## replace me with a real token


