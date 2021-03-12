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
	printf "%s X %sNOT FOUND, quitting...%b"	"${r}"  "${reset}"  "${three_down}"
	exit 2
fi
printf "%s\nBUILDING IMAGE, using:"				"${y}"
printf "%b   $%s  TARGET_DOMAIN=%s  "			"\n"	"${bgb}${w}"	"${target_domain}"
printf "TARGET_ALIAS=%s  "						"${target_alias}"
printf "TARGET_IMAGE_TAG=%s  "					"${target_image_tag}"
printf "TARGET_LOG_LEVEL=%s  "  				"${target_log_level}"
printf "SERVICE_NAME=%s  "						"${service_name}"
printf "TARGET_PROJECT_ID=%s  "					"${target_project_id}"
printf "NICKNAME=%s  "							"${nickname}"
printf "docker-compose build %s  "				"${service_name}"

docker-compose build  --no-cache  --progress auto	 --pull	 "${service_name}"  >>/dev/null  2>&1  &
. "${HELPERS}/spinner.sh" $!
