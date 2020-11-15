#!/bin/zsh


	printf "\n\n\t %s=========================================================================================="		"${b}"
	printf "  \n\t ==  Prepare %s deployment"																			"${target_type}"
	printf "  \n\t ==========================================================================================%s"		"${reset}"
	printf "%bBuild requested for:\t%s%s%s"       "\n${three_in}"  "${g}"  "${target_prefix}"  "${reset}"
	printf "\n\n\t\t Looking for '%s'......"																			"${manifest}"

	if [[ -e "${manifest}" ]]; then
		printf "%s √ %s \t found!"																						"${g}" "${reset}"
	else
		printf "%s X %s\t NOT FOUND...but required!  Quitting..."														"${r}" "${reset}"
		exit 2
	fi

	printf "\n\n\t %s=========================================================================================="		"${b}"
	printf "  \n\t ==  Building image..."
	printf "  \n\t ==========================================================================================%s"		"${reset}"
	printf "\n\n"


	if ! docker-compose build	--no-cache										\
								--progress auto									\
								--pull											\
								--build-arg TARGET_PREFIX="${target_prefix}"	\
								--build-arg SERVICE_NAME="${service_name}"		\
								--build-arg TARGET_DOMAIN="${target_domain}"	\
								--build-arg IMAGE_TAG="${image_tag}"			\
								--build-arg LOG_LEVEL="${log_level}"			\
								"${service_name}"								\
	; then
		printf "\n\n\t %s!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"				"${b}"
		printf "  \n\t !!!!!!!!!!!!!!!!  Possible Dockerfile issues encountered  !!!!!!!!!!!!!!!!!!!!!!"
		printf "  \n\t !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%s"				"${reset}"
		printf "\n\n\t Run this from command line to see details:"
		printf "\n\n\t\t"
		printf "TARGET_DOMAIN=%s TARGET_PREFIX=%s IMAGE_TAG=%s LOG_LEVEL=%s SERVICE_NAME=%s  docker-compose build %s"	"${target_domain}" "${target_prefix}" "${image_tag}" "${log_level}" "${service_name}" "${service_name}"
		printf "\n\n\n...quitting\n\n%s" "${reset}"
		exit 4
	fi


	printf "\n\n\t\t %s============================================================================================"	"${b}"
	printf "  \n\t\t ==  Pushing new image to remote registry: %s/%s/%s:%s"												"${cloud_project_id}" "${service_name}"		"${target_prefix}" "${IMAGE_TAG}"
	printf "  \n\t\t ============================================================================================%s"	"${reset}"
	printf "\n\n"

	if [[ "${push}" == true ]]; then
		docker-compose push "${service_name}"
	else
		printf "%s \n\t\t\t !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"					"${y}"
		printf "   \n\t\t\t !!!!!!!!!!!!!  Push to image repository skipped by request  !!!!!!!!!!!!"
		printf "   \n\t\t\t !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%s"					"${reset}"
		printf "\n"
	fi
