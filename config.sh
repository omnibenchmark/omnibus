#!/bin/bash
# Configuration of benchmark to set up


BENCHMARK="Benchmark_name"
REPONAMES=("dataset_1" "dataset_2")
TEMPLATES=("omni-data-py" "omni-data-py")
GLUSERNAME="random.person"
USEREMAIL="random.person@mls.uzh.ch"
KEYWORDS=("${BENCHMARK}_dataset" "${BENCHMARK}_dataset")
PTITLE=$REPONAMES
TEMSOURCE="https://github.com/ansonrel/contributed-project-templates"
TEMREF="main"
token="glpat-token"


# OBS:
# REPONAMES, TEMPLATES, and KEYWORDS must have the same length
#
# Explainations:
# BENCHMARK: Sets the name of the benchmark you are setting up
# REPONAMES: The project names for each benchmark component (do not include the orcestrator)
# TEMPLATES: (options: "omni-data-py" "omni-method-py" "omni-metric-py" "omni-param-py" "omni-processed-py")
# GLUSERNAME: 
# USEREMAIL: 
# KEYWORDS: 
# PTITLE: 
# TEMSOURCE: 
# TEMREF: 
# token: A token with `api` scope at renkulab.io's gitlab