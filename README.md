# bin-zsh

A set of zsh scripts that standardize build and deployment across a growing list of application frameworks and languages. 

----

## Supported Environments

**Build targets:**
- Angular
- Docker
- Python
- Nodejs(Typescript)
- Go

**Deploy targets:**
- Local/Remote Docker 
- GCP

----

## Developer Install

Clone the git repository and link project root to your path.

$  `cd <code root> && git@github.com:wejafoo/bin-zsh.git`

$  `cd bin-zsh && ln -s  ~/bin  .`

$   `echo 'export PATH=~/bin:${PATH}' >> ~/.zshrc`
    

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
