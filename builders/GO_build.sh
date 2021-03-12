#!/bin/zsh

	printf "%s\n= Prepare %s deployment"		"${b}"  "${build_context}"
	printf "%s\nBuild requested by:%s"  		"${y}"	"${reset}"
	printf " %.0s"	{0..14}
	printf "%s"									"${target_alias}"
	printf "%s\nLooking for '%s'"				"${y}"	"${manifest}"
	if [[ -e "${manifest}" ]]; then
		printf "%s √ %sfound!"					"${g}"	"${reset}"
	else
		printf "%s X %s\t NOT FOUND...but required!  Quitting..."	"${r}" "${reset}"
		exit 2
	fi
	printf "%s\n= Building image...\n\n"		"${y}"


	. docker-compose build	--no-cache --progress auto	--pull "${service_name}"
# 	if ! docker-compose build	--no-cache --progress auto	--pull					\
# 								--build-arg TARGET_ALIAS="${target_alias}"			\
# 								--build-arg SERVICE_NAME="${service_name}"			\
# 								--build-arg TARGET_IMAGE_TAG="${target_image_tag}"	\
# 								--build-arg TARGET_DOMAIN="${target_domain}"		\
# 								--build-arg TARGET_LOG_LEVEL="${target_log_level}"	\
# 								"${service_name}"									\
# 	; then
# 		printf "\n\n\t %s!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"				"${b}"
# 		printf "  \n\t !!!!!!!!!!!!!!!!  Possible Dockerfile issues encountered  !!!!!!!!!!!!!!!!!!!!!!"
# 		printf "  \n\t !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%s"				"${reset}"
# 		printf "\n\n\t Run this from command line to see details:"
# 		printf "\n\n\t\t"
# 		printf "TARGET_DOMAIN=%s TARGET_ALIAS=%s TARGET_IMAGE_TAG=%s TARGET_LOG_LEVEL=%s SERVICE_NAME=%s  docker-compose build %s"	"${target_domain}" "${target_alias}" "${target_image_tag}" "${target_log_level}" "${service_name}" "${service_name}"
# 		printf "\n\n\n...quitting\n\n%s" "${reset}"
# 		exit 4
# 	fi

	printf "%s\n= Pushing new image to remote registry: %s/%s/%s:%s\n\n"	"${b}"	"${target_project_id}"	"${service_name}"	"${target_alias}"	"${target_image_tag}"

	if [[ "${push}" == true ]]; then
		. docker-compose push "${service_name}"
	else
		printf "%s \n\t\t\t !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"					"${y}"
		printf "   \n\t\t\t !!!!!!!!!!!!!  Push to image repository skipped by request  !!!!!!!!!!!!"
		printf "   \n\t\t\t !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%s"					"${reset}"
		printf "\n"
	fi
