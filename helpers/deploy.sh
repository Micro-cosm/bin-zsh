#!/bin/zsh


printf "%s%b"									"${grey}"  "\n\t"
printf "=%.0s"									{16..116}
printf "\n\t= DEPLOY \n\t"
printf "=%.0s"									{16..116}
printf "%s%b"									"${grey}"  "\n${two_in}"
printf '=%.0s'									{16..108}
printf "%b= DEPLOY:  Confirm environment%b"	"\n${two_in}"  "\n${two_in}"
printf "=%.0s"									{16..108}
printf "%bDeploy configuration:"				"\n${three_in}"
printf "%bCurrent directory ......%s √ %s%s"	"\n${four_in}"  "${g}"  "${reset}"  "${PWD}"
printf "%bTARGET_PREFIX ..........%s √ %s%s"	"\n${four_in}"  "${g}"  "${reset}"  "${target_prefix}"
printf "%bSERVICE_NAME ...........%s √ %s%s"	"\n${four_in}"  "${g}"  "${reset}"  "${service_name}"
printf "%bTARGET .................%s √ %s%s"	"\n${four_in}"  "${g}"  "${reset}"  "${target}"

if [[ "${target}" == "REMOTE" ]]; then
	printf "%bRemote specifics:"			"\n${three_in}"
	printf "%bProject ID.............."		"\n${four_in}"
	if [[ ${cloud_project_id} != "" ]]; then
		printf "%s √ %s%s"								"${g}"  "${reset}"  "${cloud_project_id}"
		printf "%bBuild file..............%s √ %s"		"\n${four_in}"  "${g}"  "${reset}"
		printf "%bgcloud profile..........%s √ %s%s%b"	"\n${four_in}"  "${g}"  "${reset}"  "${cloud_project_id}"  "${two_down}"
	else
		printf "%s X %s\t required: %s... quitting"		"${r}"  "${reset}"  "${cloud_project_id}"
		printf "%b"										"${two_down}"
		exit 6
	fi
fi

if [[ "${target}" == "LOCAL" ]]; then

	printf "%s%b"									"${grey}"  "\n${two_in}"
	printf '=%.0s'									{16..108}
	printf "%b= DEPLOY:  Pull image%b"			"\n${two_in}"  "\n${two_in}"
	printf '=%.0s'									{16..108}
	printf "%bPull from registry:  %s/%s/%s:%s"		"\n${three_in}" "${cloud_project_id}" "${service_name}" "${target_prefix}" "${image_tag}"

	if [[ "${pull}" == true ]]; then
		printf "%s%bPULLING IMAGE...%b%s"			"${y}"  "${two_down}${three_in}"  "${two_down}"  "${reset}"

		docker-compose pull "${service_name}"

		printf "%s%bDONE.%s"						"${g}"  "\n${three_in}"  "${reset}"
	else
		printf "%s\n%b"								"${y}" "${three_in}"
		printf '!%.0s'								{24..108}
		printf "%b!!  DEPLOY:  Pull skipped%b"		"\n${three_in}"  "\n${three_in}"
		printf '!%.0s'								{24..108}
		printf "%s"									"${reset}"
	fi

	printf "%s%b"									"${grey}"  "\n${two_in}"
	printf '=%.0s'									{16..108}
	printf "%b= DEPLOY:  Stop container(s)%b"		"\n${two_in}"  "\n${two_in}"
	printf '=%.0s'									{16..108}

	printf "%s%bSTOPPING CONTAINERS...%b%s"			"${y}"  "${two_down}${three_in}"  "${two_down}"  "${reset}"
	if ! docker-compose stop "${service_name}" && printf "\nstop=%s" "$?" && docker-compose rm --force "${service_name}" && printf "\nremove=%s" "$?"; then

		printf "  \n %b Nothing to stop"			"${two_in}"

	fi
	printf "%s%bDONE.%s"							"${g}"  "\n${three_in}"  "${reset}"

	printf "%s%b"									"${grey}"  "\n${two_in}"
	printf '=%.0s'									{16..108}
	printf "%b= DEPLOY:  Start container(s)%b" 	"\n${two_in}"  "\n${two_in}"
	printf '=%.0s'									{16..108}

	printf "%s%bSTARTING CONTAINERS...%b%s"			"${y}"  "${two_down}${three_in}"  "${two_down}"  "${reset}"

	docker-compose --log-level "${log_level}" up --detach --force-recreate "${service_name}" # log levels: DEBUG, INFO, WARNING, ERROR, CRITICAL (default: INFO)

	printf "%s%bDONE.%s"											"${g}"  "\n${three_in}"  "${reset}"
else
	cloud_region_actual=$(gcloud config get-value compute/region)
	cloud_project_id_actual=$(gcloud config get-value project)

	printf "%s%b"									"${grey}"  "\n${two_in}"
	printf "=%.0s"									{16..108}
	printf "%b= DEPLOY:  Start container(s)%b"		"\n${two_in}"  "\n${two_in}"
	printf "=%.0s"									{16..108}
	printf "%s"										"${reset}"
	printf "%bCloud project(actual).....%s √ %s"	"\n${three_in}" "${g}" "${reset}${cloud_project_id_actual}"
	printf "%bCloud project(requested).."			"\n${three_in}"

	if [[ "${cloud_project_id}" == "${cloud_project_id_actual}" ]]; then

		printf "%s √ %s%s"							"${g}" "${reset}" "${cloud_project_id}"

	else

		printf "%s X >%s< Confirm your gcloud project config, quitting..."	"${r}"  "${reset}${cloud_project_id}"
		exit 8

	fi

	printf "%bCloud region (actual).....%s √ %s%s"		"\n${three_in}"  "${g}"  "${reset}"  "${cloud_region_actual}"
	printf "%bCloud target..............%s √ %s%s"		"\n${three_in}"  "${g}"  "${reset}"  "${target}"
	printf "%bCloud service name........%s √ %s%s"		"\n${three_in}"  "${g}"  "${reset}"  "${service_name}"
	printf "%b'cloudbuild.json'?........"				"\n${three_in}"

	cb_service=cloudbuild.${service_name}.${target_domain}.${target_prefix}.json
	cb_domain=cloudbuild.${target_domain}.${target_prefix}.json
	cb_target=cloudbuild.${target_prefix}.json
	cb_default=cloudbuild.json

	if [[ -e "${cb_service}" ]]; then
		deploy_pipeline="${cb_service}"
		printf "%s X %soverride found!"		"${r}"  "${reset}"
		printf "%b  %s √ %s%s"				"\n${six_in}"  "${g}"  "${reset}"  "${deploy_pipeline}"
		printf "%s%b"						"${y}"  "${two_down}"
		cat "${deploy_pipeline}"
		printf "%b%s"						"${two_down}"  "${reset}"
	elif [[ -e "${cb_domain}" ]]; then
		deploy_pipeline="${cb_domain}"
		printf "%s X %soverride found!"		"${r}"  "${reset}"
		printf "%b  %s √ %s%s"				"\n${six_in}"  "${g}"  "${reset}"  "${deploy_pipeline}"
		printf "%s%b"						"${y}"  "${two_down}"
		cat "${deploy_pipeline}"
		printf "%b%s"						"${two_down}" "${reset}"
	elif [[ -e "${cb_target}" ]]; then
		deploy_pipeline="${cb_target}"
		printf "%s X %soverride found!"		"${r}"  "${reset}"
		printf "%b  %s √ %s%s"				"\n${six_in}"  "${g}"  "${reset}"  "${deploy_pipeline}"
		printf "%s%b"						"${y}"  "${two_down}"
		cat "${deploy_pipeline}"
		printf "%s%b"						"${reset}"  "${two_down}"
	elif [[ -e "${cb_default}" ]]; then
		deploy_pipeline="${cb_default}"
		printf "%s √ %sfound!"				"${g}"  "${reset}"
		printf "%s%b"						"${y}"  "${two_down}"
		cat "${deploy_pipeline}"
		printf "%s%b"						"${reset}"  "${two_down}"
	else
		printf "%s X %sNONE...quitting%b"	"${r}"  "${reset}"  "${two_down}"
		exit 5
	fi
	gcloud config configurations activate "${cloud_project_id}"
	gcloud config list
	printf "%s%b Submitting build:%b"		"${reset}"  "${two_down}${two_in}"  "${two_down}"
	printf "gcloud builds submit "
	printf "--config=%s  "					"${deploy_pipeline}"
	printf "--substitutions "				"${deploy_pipeline}"
	printf "_TARGET_DOMAIN=%s,"				"${target_domain}"
	printf "_SERVICE_NAME=%s,"				"${service_name}"
	printf "_TARGET_PREFIX=%s,"				"${target_prefix}"
	printf "_IMAGE_TAG=%s%b"				"${image_tag}"  "${two_down}"

	gcloud builds submit --config="${deploy_pipeline}" --substitutions \
		_TARGET_DOMAIN="${target_domain}",_SERVICE_NAME="${service_name}",_TARGET_PREFIX="${target_prefix}",_IMAGE_TAG="${image_tag}"

	deploy_return_code=$?
fi
