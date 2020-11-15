#!/bin/zsh

manifest='docker-compose.yml';

printf "%bBuild requested for:\t%s%s%s"  			"\n${three_in}"  "${g}"  "${target_prefix}"  "${reset}"
printf "%bLooking for '%s'......"        			"\n${four_in}"  "${manifest}"


if [[ -e "${manifest}" ]]; then
	printf "%s √ %s \t found!"  					"${g}"  "${reset}"
else
	printf "%s X %s\t NOT FOUND!  Quitting.../n/n"  "${r}"  "${reset}"
	printf "/n/n"
	exit 2
fi

printf "%s%bSTARTING DOCKER BUILD...%b%s"			"${y}"  "${two_down}${three_in}"  "${two_down}"  "${reset}"

if ! docker-compose build	--no-cache											\
							--progress auto										\
							--pull												\
							--build-arg CLOUD_PROJECT_ID="${cloud_project_id}"	\
							--build-arg TARGET_PREFIX="${target_prefix}"		\
							--build-arg SERVICE_NAME="${service_name}"			\
							--build-arg TARGET_DOMAIN="${target_domain}"		\
							--build-arg IMAGE_TAG="${image_tag}"				\
							--build-arg LOG_LEVEL="${log_level}"				\
							"${service_name}"									\
; then
	printf "%s%b"										"${r}"  "${two_down}\t"
	printf "!%.0s"										{24..120}
	printf "\n\t!!  Dockerfile issues encountered\n\t"
	printf "!%.0s"										{24..120}
	printf "%bRun following command for details:"		"${two_down}\t"
	printf "%b"											"${two_down}"  "${three_in}"

	printf "TARGET_DOMAIN=%s TARGET_PREFIX=%s IMAGE_TAG=%s LOG_LEVEL=%s SERVICE_NAME=%s CLOUD_PROJECT_ID=%s docker-compose build %s"  "${target_domain}"  "${target_prefix}"  "${image_tag}"  "${log_level}"  "${service_name}"  "${cloud_project_id}"  "${service_name}"


	printf "\n\n\n...quitting\n\n%s"					"${reset}"
	exit 4
fi
printf "%s%bDONE.%s"									"${g}"  "\n${three_in}"  "${reset}"
