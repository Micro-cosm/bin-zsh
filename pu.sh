#!/bin/zsh

export docker_build=true; 										### REMOVE
export local_build=true;  										###		THESE
export pull=true;												###			TEMPORARILY
export push=true;												###				HARD-CODED VALUES

declare fd_init; 												### BUILD/DEPLOY VARIABLES
declare fd_deploy_rc_script;
declare target;
declare target_alias;
declare target_local_port;
declare target_remote_port;
declare target_domain;
declare target_image_tag;
declare target_log_level;
declare target_project_id;
declare target_realm;
declare build_context;
declare nickname;
declare service_name;
declare default_cloud_pipeline_json;
declare deploy_return_code;
declare script_prefix;
declare b; 														### FORMATTING VARIABLES
declare g;
declare o;
declare r;
declare y;
declare w;
declare bgw;
declare grey;
declare reset;
declare two_down;
declare two_in;
declare three_in;
declare four_in;
declare five_in;
declare six_in;
declare seven_in;

export HELPERS="$(dirname "${0}")/helpers"
export BUILDERS="$(dirname "${0}")/builders"

read -r -d "${usage_message}" << EOM
	Usage: pu.sh <[--local|-l] | [--remote|-r]> (--nobuild|-nb) (--nopull|-np)  (--help|-h)
EOM

. "${HELPERS}/initialize.sh"
. "${HELPERS}/build.sh"
. "${HELPERS}/deploy.sh"

if [[ ${deploy_return_code} -gt 0 ]]; then
	printf "%s\n"  		"${r}"
	printf "=%.0s"  	{0..108}
	printf "\nFLEX DEPLOY:  End%bReturn Code:  %s\n"  		"${five_in}${four_in}"  "${deploy_return_code}"
	printf "%s\n\n"  	"${reset}"
else
	printf "%s\n"  		"${g}"
	printf "=%.0s" 		{0..108}
	printf "\nFLEX DEPLOY:  End%bReturn Code:  %s\n"  		"${five_in}${four_in}"  "${deploy_return_code}"
	printf "%s"  		"${reset}"

	if [[ "${target}" == 'LOCAL' || "${target}" == 'local' ]]; then
		printf "%b**Your deployment was successful! You can visit your handiwork on:  %s**%b"		"${two_down}"	"http://localhost:${target_local_port}/${nickname}/"	"${two_down}"
	else
		if [[ "${target_alias}" == 'prod' ]]; then
			printf "%b**Your deployment was successful! You can visit your handiwork on:  %s**%b"	"${two_down}"	"https://foo.fb.${target_domain}/${nickname}/"	"${two_down}"
		else
			printf "%b**Your deployment was successful! You can visit your handiwork on:  %s**%b"	"${two_down}"	"https://too.fb.${target_domain}/${nickname}/"	"${two_down}"
		fi
	fi
fi

exit ${deploy_return_code}
