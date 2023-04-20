# Omnibus: Create and extend your omnibenchmark from the terminal

## Install omnibus

Install omnibus in a docker image or locally


### Build docker image (Recommended)

```sh
git clone https://github.com/shdam/omnibus.git
cd omnibus
docker build -t omnibus .

# Run the docker image
docker run -it omnibus:latest /bin/bash
```

### Install omnibus locally

```sh
git clone https://github.com/shdam/omnibus.git
cd omnibus
make install
```

## Define benchmark structure

Create a new `config` file based on `config_template`.
Specify each parameter according to the instructions in the file.

It is recommended to create a new group or subgroup on GitLab to store your benchmark projects on. Otherwise, comment out `NAMESPACE_ID` and `GROUPNAME` to create it on your own profile.
If you are creating the benchmark in a subgroup, the `GROUPNAME` should include all parent groupnames. E.g., `"Mygroup/Mysubgroup"`. This can be conveniently copied from the url.

You will also need a Personal Access Token with api scope. The token can be made specificly for the subgroup.

An R function is provided that lets you create the config file from R:

```r
source("R/create_config.R")

create_config(
	benchmark = "Your_benchmark",
	config = "config_Your_benchmark",
	datanames = c("name1", "name2", "name3"),
	methodnames = c("name1", "name2"),
	metricnames = c("name1", "name2"),
	explainer = TRUE, # Adds explanation of each config parameter to the buttom of the file
	... # Add any config parameter setting (does not work with BENCHMARK, REPONAMES,
	# KEYWORDS, or TEMPLATES). Names must match the names from the template.
	)
# If you don't specific the config name, it will be called "config_<benchmark>".

```

`create_config` supports datasets, methods, and metrics and automatically assigns default templates and a useful naming structure. Edit as you see fit in the config file afterwards.

The `config` parameter is optional, but can be useful if you want to add the config files in a separate folder. When not specified, the config name will be `config_<benchmark>`. 


## Creating the benchmark

Create your brand new benchmark by running

```sh

omnibus -o -p -s -c CONFIGFILE

```

The `-o`, `-p`, and `-s` flags are used to create the `orchestrator`, `parameters`, and `summary` projects, respectively.

If you prefer not to store the API token in clear text, you can pass it to `omnibus` with `--token TOKEN`.


## Add new projects to your existing benchmark

Rerun the `omnibus` command, omitting the `-o`, `-p`, and `-s` flags, but specifying the new reponame, keyword, and template directly in the function call:

```sh

omnibus -c CONFIGFILE -r REPONAME -k KEYWORD -t TEMPLATE

```

This will overwrite the REPONAMES, KEYWORDS, TEMPLATES, and PTITLES given in the config file, so the same config file can be used unedited.

If you `source CONFIGFILE` first, you can reference variables defined in it when creating projects this way. To give an example, `KEYWORD1` could be `${BENCHMARK}_method`.

If you only want to build the orchestrator, parameters, and/or summary, set `-r skip` along with using the appropriate `-o`, `-p`, and `-s` flags.


*Alternatively*, create a new config file based on the one you made previously. Edit the list parameters (REPONAMES, KEYWORDS, TEMPLATES, and PTITLES) to only contain the new project configurations, leave the rest as they were.

```sh

omnibus -c NEWCONFIGFILE

```

## Run a project in docker

This will pull and run a docker container based on an image from a specific project.

First, you need to locate the image ID found under `Packages & Registries` > `Container Registry`. Copy the latest ID. Run `omnidock -h` for additional information.

Example usage:

```sh
omnidock -r REPONAME -g GROUPNAME -i IMAGEID -u "USER.NAME" -e "EMAIL" --token TOKEN
```

OBS: You may use `omnidock` outside docker by using the `-c` flag:
This will simply clone the repository to your current directory instead of downloading and launching a docker instance. The remote will be defined when doing so.

```sh
omnidock -c -r REPONAME -g GROUPNAME -u "USER.NAME" -e "EMAIL" --token TOKEN
```

