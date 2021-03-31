# bin-zsh

A set of zsh scripts that standardize build and deployment across a growing list of application frameworks and languages. 

----

## Currently Supported Environments

**Build targets:**
- Angular
- Docker
- Python
- Nodejs(Typescript)
- Go

**Deploy targets:**
- Local build target runner(in-memory w/ file watcher and hot reload) 
- Docker(Local/Remote)
- GCP

----

## Developer Install

Clone the git repository and link project root to your path.

$  `cd <code root> && git@github.com:wejafoo/bin-zsh.git`

$  `cd bin-zsh && ln -s  ~/bin  .`

$   `echo 'export PATH=~/bin:${PATH}' >> ~/.zshrc`
    
----
## Description

This utility serves as a simplistic way to build/test/deploy any of the [Supported Environments](#envs) with a single command that uses 
intelligent defaults based on the following factors(order of precedence):
  1.  manual re-deployment environment variables(local IDE/remote GCP web UI/local gcloud)
  1.  runtime environment deployment overrides(docker-compose.yml/GCP cloudbuild.json)
  1.  command line argument overrides(`--TARGET_ALIAS=prod`)
  1.  current environment variable overrides(`. ~/.zshrc`/`export TARGET_ALIAS=prod`)
  1.  flex deployment runtime configuration file(`<PROJECT ROOT>/.fd && <PROJECT ROOT>/.fd.<DEPLOYMENT DOMAIN>`)
  1.  intelligent defaults(script-based rules driven by the targeted language or targeted Docker image defaulting to local Docker deployment)


----

## Local/Docker

From one of the aforementioned build targets project root, run the following(assumes Docker is installed locally and working):

$   `<env> pu.sh --local`


----

## Remote/Cloud

From one of the aforementioned build targets project root, run the following(assumes 'gcloud' is installed locally and able to connect to the targeted cloud project):

$   `<env> pu.sh --remote=stage`

----

## Housekeeping

Periodically, run this to ensure local Docker container/image residue is not accumulating.  There are several circumstances that can be responsible for this that these scripts may
not otherwise be able to address.

$ `docker-clean.sh`

Running the above command with no arguments will prune the following Docker artifacts:
- Stopped containers
- Unused images
- Unused networks
- Unused volumes

----

## Todos

1. **Todo**: Add documentation here that explains the default config file(s) and how they should be modified

1. **Todo**: Add automated test cases that build and deploy all project types following a commit to this repo
