#!/bin/zsh

manifest='docker-compose.yml';

printf "%s\nBuild requested by:%s"  			"${y}"	"${reset}"
printf " %.0s"	{0..18}
printf "%s"										"${target_alias}"
printf "%s\nLooking for '%s' "					"${y}"	"${manifest}"
printf " %.0s"	{0..1}
if [[ -e "${manifest}" ]]; then
	printf "%s √ %sfound!"  					"${g}"  "${reset}"
else
	printf "%s X %sNOT FOUND, quitting...%b"	"${r}"  "${reset}"  	"${three_down}"
	exit 2
fi
printf "%s\nBUILDING IMAGE, using:"				"${y}"
printf "%b   $%s  TARGET_DOMAIN=%s  "			"\n"	"${bgb}${w}"	"${target_domain}"
printf "TARGET_ALIAS=%s  "						"${target_alias}"
printf "TARGET_IMAGE_TAG=%s  "					"${target_image_tag}"
printf "LOG_LEVEL=%s  "  						"${log_level}"
printf "SERVICE_NAME=%s  "						"${service_name}"
printf "TARGET_PROJECT_ID=%s  "					"${target_project_id}"
printf "docker-compose build %s  "				"${service_name}"


docker-compose build	--no-cache  --progress auto	 --pull						\
						--build-arg TARGET_PROJECT_ID="${target_project_id}"	\
						--build-arg TARGET_ALIAS="${target_alias}"				\
						--build-arg SERVICE_NAME="${service_name}"				\
						--build-arg TARGET_IMAGE_TAG="${target_image_tag}"		\
						"${service_name}"  >>/dev/null  2>&1  &

this_pid=$!;
this_spinner='-\|/';
i=0;
printf "%s"										"${reset}${y}";
while kill -0 "${this_pid}" 2>/dev/null; do
	i=$(( (i+1) %4 ));
	printf "\r %s "								"${this_spinner:$i:1}"
	sleep .2;
done
printf "%s\n"									"${reset}"
printf "%sDONE%s"								"${g}"	"${reset}"
