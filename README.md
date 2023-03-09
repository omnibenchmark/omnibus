# Omnibus: Create and extend your omnibenchmark from the terminal


## Install omnibus

```sh
git pull https://github.com/shdam/omnibus.git

cd omnibus

make install
```

## Set up a virtual environment (optional)


```sh
./bin/omnivir.sh
```
This will create three folders in your `~/` directory called `virtenvs`, `soft`, and `omb`.
`~/virtenvs` will store the virtual environment.
`~/soft` will store `Python-3.9.2`.
`~/omb` is meant to store your benchmarks.
The `omnibus` dependencies will be installed in the virtual environment.

## Define benchmark structure

Create a new `config` file based on `config_template`.
Specificy each parameter according to the instructions in the file.

It is recommended to create a new group or subgroup on GitLab to store your benchmark projects on. Otherwise, comment out `NAMESPACE_ID` and `GROUPNAME` to create it on your own profile.
If you are creating the benchmark in a subgroup, the `GROUPNAME` should include all parent groupnames. E.g., `"Mygroup/Mysubgroup"`.

An R function is provided that lets you create the config file from R:

```r

# Requirements: install.packages("readr")
source("R/create_config.R")

create_config(
	benchmark = "Your_benchmark",
	config = "config_benchmark_init",
	datanames = c("name1", "name2", "name3"),
	methodnames = c("name1", "name2"),
	metricnames = c("name1", "name2"),
	explainer = TRUE, # Adds explanation of each config parameter to the buttom of the file
	... # Add any config parameter setting (does not work with BENCHMARK, REPONAMES,
	# KEYWORDS, or TEMPLATES). Names must match the names from the template.
	)
# If you don't specific the config name, it will be called "config_<benchmark>".

```

## Creating the benchmark

Create your brand new benchmark by running

```sh

omnibus -o -p -c CONFIGFILE

```

The `-o` and `-p` flags are used to create the `orchestrator` and `parameter` projects.


## Add new projects to your existing benchmark

Create a new config file based on the one you made previously. Edit the list parameters (REPONAMES, KEYWORDS, TEMPLATES, and PTITLES) to only contain the new project configurations, leave the rest as they were. This time exclude the `-o` and `-p` flags:

```sh

omnibus -c CONFIGFILE

```

Alternatively, this can be done by specifying the new reponame, keyword, and template directly in the function call:

```sh

omnibus -c CONFIGFILE -r REPONAME -k KEYWORD -tp TEMPLATE

```

This will overwrite the REPONAMES, KEYWORDS, TEMPLATES, and PTITLES given in the config file, so the same config file can be used unedited.

It is possible to add multiple projects this way, using the following command:

```sh

omnibus -c CONFIGFILE -r "REPONAME1 REPONAME2" -k "KEYWORD1 KEYWORD2" -tp "TEMPLATE1 TEMPLATE2"

```
If you `source CONFIGFILE` first, you can reference variables defined in it when creating projects this way. To give an example, `KEYWORD1` could be `${BENCHMARK}_method`.


## Run a project in docker

This will pull and run a docker container based on an image from a specific project.

First, you need to locate the image ID found under `Packages & Registries` > `Container Registry`. Copy the latest ID. Run `omnidock -h` for extra information.

Example usage:

```sh
omnidock -r REPONAME -g GROUPNAME -i IMAGEID -u "USER.NAME" -e "EMAIL" -t TOKEN
```

OBS: You may use `omnidock` outside docker by using the `-c` flag:
This will simply clone the repository to your current directory instead of launching a docker instance.

```sh
omnidock -c -r REPONAME -g GROUPNAME -u "USER.NAME" -e "EMAIL" -t TOKEN
```

