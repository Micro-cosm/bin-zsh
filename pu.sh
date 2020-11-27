#!/bin/zsh

export docker_build=true; 		### REMOVE
export local_build=true;  		###		THESE
export pull=true;				###			TEMPORARILY
export push=true;				###				HARD-CODED VALUES

export HELPERS="$(dirname "${0}")/helpers"
export BUILDERS="$(dirname "${0}")/builders"

read -r -d "${usage_message}" << EOM
	Usage: pu.sh <[--local|-l] | [--remote|-r]> (--nobuild|-nb) (--nopull|-np)  (--help|-h)
EOM



. "${HELPERS}/initialize.sh"

. "${HELPERS}/build.sh"

. "${HELPERS}/deploy.sh"



if [[ ${deploy_return_code} -gt 0 ]]; then
	printf "%s\n"  	"${r}"
else
	printf "%s\n"  	"${g}"
fi

printf '=%.0s'											{0..108}
printf "\n= FLEX DEPLOY:  End%bReturn Code:  %s\n"	"${five_in}${four_in}"  "${deploy_return_code}"
printf '=%.0s'											{0..108}
printf "%s\n"											"${reset}"

exit ${deploy_return_code}
