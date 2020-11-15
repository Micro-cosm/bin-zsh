

# Aptly.io Dev Bin

A shared library of executables intended to standardize build and deployment across all AIO projects. 

----

## New Project Setup

Clone the git repository:

$ `cd $HOME; git clone git@bitbucket.org:salespartnerships/bin.git`
    
Prepend $HOME/bin to your zsh path, e.g.:

$    `echo 'export PATH=./bin:$PATH' >> ~/.zshrc`
    
Run setup against your project root:

$   `py-setup.sh`

----

## Local/Docker

Python push:

$   `<env> py-push.sh --local (-np|--nopush) (-nb|--nobuild)`

-- OR --

Other Project Types e.g. Angular push:

$   `<env> ng-push.sh --local (-np|--nopush) (-nb|--nobuild)`

-- OR --

External Image-based projects:

$ `<env vars> docker-compose up -d --build`

-- OR --

$ `<env> pu.sh --local (-np|--nopush) (-nb|--nobuild)`



### Misc

$ `docker-clean.sh`

        Prunes the following Docker artifacts:
        - Stopped containers
        - Unused images 
        - Unused networks
        - Unused volumes
 
----

## Remote/Cloud

$ `<env> py-pu.sh  [(--local|-l) | (--remote|-r) (--nobuild|-nb)`


----
----

## Common

#### Environmental variables

The following environmental variables are those that are required for the build/deployment
of any given project.  It is this commonality that makes it important to note here.  For convenience,
you might consider exporting each from your '.*rc' file of choice so that an appropriate default is always
set.  Any of these may be overridden by prepending any of the aforementioned deployment entry points,
like this:

    TARGET_PREFIX=[target] TAG=[image label] DL=[debug level] PORT=[port] *pu.sh <args>... 

Any or all may be left out of an execution if defaults are programmatically committed to your environment,
but when included is the single best way to ensure the values you wish to set will take precedence and are
always available throughout the deployment chain. 

- **TARGET_PREFIX**        (DEFAULT: "dev")

    "TARGET_PREFIX" provides an alias to the targeted environment.  Although this is typically your name, it can be any
    meaningful alias and is used in conjunction with the service name to provide ready identification
    of the deployed instance, regardless of the target environment.
    
- **TAG**    (DEFAULT: "latest")

    "TAG" provides label to an image that can be used downstream to identify specific image version primarily for
     archival/historical purposes, but can be applied to a variety of deployment scenarios(e.g. champion
     /challenger, canary releases, and version rollback.
     
- **DL**     (DEFAULT: "INFO")

    "DL" provides the debug level that is to be used across the deployment.
    
- **PORT**   (DEFAULT: "8080")

    "PORT" provides the running instance with a port number to be used to map to the running container on the host.

#### Target Environment Arguments (DEFAULT: "--local")

* **--local**         

    "--local"   Use for deployment via docker to localhost;
    
* **--remote**

    "--remote"  Use for deployment to GCP.
    
    
idea
----

## Todos

    1. Todo: add automated test cases that build and deploy all project types following a commit to this repo

----

## Templates

### Python

* templates/python.NEW/requirements.txt
* templates/python.NEW/tests
* templates/python.NEW/.pylintrc

#### Docker

* templates/README.md.NEW          - generic readme with build and deploy documentation that mirrors this page
* templates/.gitignore.NEW         - default config that filters unnecessary files from delivery into git repository
* templates/Dockerfile.NEW         - generic instruction that builds a default Docker image 
* templates/docker-compose.yml.NEW - generic config that uses the Dockerfile image to run project locally
* templates/.dockerignore.NEW      - default config that filters unnecessary files from delivery into a Docker image/container
* templates/local*.env.NEW         - provides default env vars for use with local deployments
* templates/.env.yaml.NEW          - (for future reference) provides env vars used by remote deployments.


### IDE

#### IDEA

* templates/runConfigurations    - default ide-specific runConfigurations 
* idea-eject.sh                  - ejects the runConfigurations for JetBrain IDEs into project repo visibility

---

## MISC

### Javascript

* ng-pu.sh - (for future use) Angular local and remote build/deploy
* ts-pu.sh - (for future use) NodeJS local and remote build/deploy

### Misc

* pu.sh    - (for future use) A generic build/deploy script that handles arbitrary Docker images
