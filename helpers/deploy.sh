#!/bin/zsh

printf "%s\n= DEPLOY %b%s"  						"${b}"	"${six_in}"		"${HELPERS}/deploy.sh"
printf "%s\n==  DEPLOY:  Confirm environment %b%s"	"${b}"	"${three_in}"	"${HELPERS}/deploy.sh"
printf "%s\nDeploy configuration:"					"${y}"
printf "\n  Current directory "
printf ".%.0s"	{0..11}
printf "%s √ %s%s"									"${g}"	"${reset}"  	"${PWD}"
printf "%s\n  TARGET_ALIAS "						"${y}"
printf ".%.0s"	{0..16}
printf "%s √ %s%s"									"${g}"	"${reset}"		"${target_alias}"
printf "%s\n  SERVICE_NAME "						"${y}"
printf ".%.0s"	{0..16}
printf "%s √ %s%s"									"${g}"	"${reset}"		"${service_name}"
printf "%s\n  TARGET "								"${y}"
printf ".%.0s"	{0..22}
printf "%s √ %s%s"									"${g}"	"${reset}"		"${target}"
if [[ "${target}" == "REMOTE" ]]; then
	printf "%s\nRemote specifics:"					"${y}"
	printf "\n  Project ID "
	printf ".%.0s"	{0..18}
	if [[ ${target_project_id} != "" ]]; then
		printf "%s √ %s%s"							"${g}"  "${reset}"  "${target_project_id}"
		printf "%s\n  gcloud profile"				"${y}"
		printf ".%.0s"	{0..15}
		printf "%s √ %s%s%b"						"${g}"  "${reset}"  "${target_project_id}"
		printf "%s\n  Build file "					"${y}"
		printf ".%.0s"	{0..18}
		printf "%s √ %s(valid/accessible)"			"${g}"  "${reset}"
	else
		printf "%s X %s required: %s... quitting"	"${r}"  "${reset}"  "${target_project_id}"
		printf "%b"									"${two_down}"
		exit 6
	fi
fi


if [[ "${target}" == "LOCAL" || "${target}" == "local" ]]; then
	printf "%s\n= DEPLOY:  Pull image %b%s"				"${b}"	"${five_in}"	"${HELPERS}/deploy.sh"
	printf "%s\nPull registry: %s"						"${y}"	"${reset}"
	printf " %.0s"	{0..19}
	printf "%s/%s/%s:%s"								"${target_project_id}"	"${service_name}"	"${target_alias}"	"${target_image_tag}"
	if [[ "${pull}" == true ]]; then
		printf "%s\nPULLING IMAGE, using:"				"${y}"
		printf "%b   $%s  docker-compose pull %s  "		"\n"	"${w}${bgb}"	"${service_name}"

		docker-compose pull "${service_name}" >>/dev/null 2>&1  &
		. "${HELPERS}/spinner.sh" $!

	else
		printf "%s\n%b"										"${y}"	"${three_in}"
		printf '!%.0s'	{24..108}
		printf "%b!!  DEPLOY:  Pull skipped%b"				"\n${three_in}"  "\n${three_in}"
		printf '!%.0s'	{24..108}
		printf "%s"											"${reset}"
	fi
	printf "%s\n==  DEPLOY:  Stop container(s)"				"${b}"
	printf "%s\nSTOPPING CONTAINERS, using:"				"${y}"
	printf "\n   $%s  docker-compose stop %s &&  "			"${w}${bgb}"	"${service_name}"
	printf "docker-compose rm --force %s"					"${service_name}"

	docker-compose stop "${service_name}"  >> /dev/null 2>&1  &&  docker-compose rm --force "${service_name}"  >> /dev/null 2>&1  &
	. "${HELPERS}/spinner.sh" $!

	printf "%s\n==  DEPLOY:  Start container(s) %b%s"		"${b}"	"${three_in}"	"${HELPERS}/deploy.sh"
	printf "%s\nSTARTING CONTAINERS, using:"				"${y}"
	printf "\n   $%s  docker-compose --log-level %s up "	"${w}${bgb}"	"${target_log_level}"
	printf "--detach --force-recreate %s  "					"${service_name}"

	docker-compose --log-level "${target_log_level}" up --detach --force-recreate "${service_name}"  >>/dev/null 2>&1  &
	. "${HELPERS}/spinner.sh" $!

else
	cloud_region_actual=$(gcloud config get-value compute/region	2>/dev/null);
	target_project_id_actual=$(gcloud config get-value project		2>/dev/null);
	printf "\n%s==  DEPLOY:  Start container(s) %b%s"		"${b}"	"${three_in}"	"${HELPERS}/deploy.sh"
	printf "%s\nCloud project(actual) "					"${y}"
	printf ".%.0s"	{0..9}
	printf "%s √ %s"									"${g}"	"${reset}${target_project_id_actual}"
	printf "%s\nCloud project(requested) "				"${y}"
	printf ".%.0s"	{0..6}
	if [[ "${target_project_id}" == "${target_project_id_actual}" ]]; then
		printf "%s √ %s%s"													"${g}"	"${reset}"	"${target_project_id}"
	else
		printf "%s X >%s< Confirm your gcloud project config, quitting..."	"${r}"	"${reset}${target_project_id}"
		exit 8
	fi
	printf "%s\nCloud region (actual) "					"${y}"
	printf ".%.0s"	{0..9}
	printf "%s √ %s%s"									"${g}"  "${reset}"	"${cloud_region_actual}"
	printf "%s\nCloud target "							"${y}"
	printf ".%.0s"	{0..18}
	printf "%s √ %s%s"									"${g}"  "${reset}"	"${target}"
	printf "%s\nCloud service name "					"${y}"
	printf ".%.0s"	{0..12}
	printf "%s √ %s%s"									"${g}"  "${reset}"	"${service_name}"
	printf "%s\n'cloudbuild.json'? "					"${y}"
	printf ".%.0s"	{0..12}

	cb_service="cloudbuild.${service_name}.${target_domain}.${target_alias}.json"
	cb_domain="cloudbuild.${target_domain}.${target_alias}.json"
	cb_target="cloudbuild.${target_alias}.json"
	cb_default="cloudbuild.json"

	if [[ -e "${cb_service}" ]]; then
		deploy_pipeline="${cb_service}"
		printf "%s X %soverride found!\n%s"			"${r}"  "${y}"
		printf " %.0s"	{0..18}
		printf ".%.0s"	{0..12}
		printf "%s √ %s%s"							"${g}"  "${reset}"  "${deploy_pipeline}"
	elif [[ -e "${cb_domain}" ]]; then
		deploy_pipeline="${cb_domain}"
		printf "%s X %soverride found!\n%s"			"${r}"  "${y}"
		printf " %.0s"	{0..18}
		printf ".%.0s"	{0..12}
		printf "%s √ %s%s"							"${g}"  "${reset}"  "${deploy_pipeline}"
	elif [[ -e "${cb_target}" ]]; then
		deploy_pipeline="${cb_target}"
		printf "%s X %soverride found!\n%s"			"${r}"  "${y}"
		printf " %.0s"	{0..18}
		printf ".%.0s"	{0..12}
		printf "%s √ %s%s"							"${g}"  "${reset}"  "${deploy_pipeline}"
	elif [[ -e "${cb_default}" ]]; then
		deploy_pipeline="${cb_default}"
		printf "%s √ %sfound! (no overrides)"		"${g}"  "${reset}"
		printf "%s"
	else
		printf "%s X %sNONE...quitting%b"			"${r}"	"${reset}"	"${two_down}"
		exit 5
	fi
	printf "%s\nUsing: %s%s (shown below)\n"		"${y}"	"${reset}"	"${deploy_pipeline}"
	cat "${deploy_pipeline}";
	gcloud config configurations activate "${target_project_id}"	>>/dev/null;
	gcloud config list  											>>/dev/null;
	printf "%s\nSubmitting, using:"					"${y}"
	printf "%b   $%s  gcloud builds submit "		"\n"	"${w}${bgb}"
	printf "--config=%s  --substitutions "			"${deploy_pipeline}"
	printf "_SERVICE_NAME=%s,_TARGET_ALIAS=%s,"		"${service_name}"		"${target_alias}"
	printf "_TARGET_IMAGE_TAG=%s  %s"				"${target_image_tag}"	"${reset}"


	gcloud builds submit  --config="${deploy_pipeline}"  --substitutions	\
		 _NICKNAME="${nickname}",_SERVICE_NAME="${service_name}",_TARGET_ALIAS="${target_alias}",_TARGET_IMAGE_TAG="${target_image_tag}"	\
	>/dev/null  2>&1  &;
	. "${HELPERS}/spinner.sh" $!
fi
