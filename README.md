# Create your omnibenchmark from the terminal


Here, we provide you the functionality for creating and adjusting your benchmark.

## Install omniformer

```sh
cd /path/to/dir
make install
```

## Set up a virtual environment (optional)

```sh
omnivir
```
This will create three folders in your `~/` directory called `virtenvs`, `soft`, and `omb`.
`~/virtenvs` will store the virtual environment.
`~/soft` will store `Python-3.9.2`.
`~/omb` is meant to store your benchmarks.

## Define benchmark structure

Create a new `config` file based on `config_template`.
Specificy each parameter according to the instructions in the file.

It is recommended to create a new group or subgroup on GitLab to store your benchmark projects on. Otherwise, comment out `NAMESPACE_ID` and `GROUPNAME` to create it on your own profile.

## Creating the benchmark

Create your brand new benchmark by running

```sh

omniformer -o -p -c CONFIGFILE

```

The `-o` and `-p` flags are used to create the `orchestrator` and `parameter` projects.


## Add new projects to your existing benchmark

Create a new config file based on the one you made previously. Edit the list parameters to only contain the new project configurations, leave the rest as it were. This time exclude the `-o` and `-p` flags:

```sh

omniformer -c CONFIGFILE

```


## Run a project in docker

This will pull and run a docker container based on an image from a specific project.

First, you need to locate the image ID found under `Packages & Registries` > `Container Registry`. Copy the latest ID. Run `omnidock -h` for extra information.




