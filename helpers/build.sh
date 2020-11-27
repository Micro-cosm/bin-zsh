#!/bin/zsh

printf "%s\t"			"${grey}"
printf "=%.0s"			{16..116}
printf "%b= BUILD%b"  	"\n\t"  "\n\t"
printf "=%.0s"			{16..116}

. "${HELPERS}/build_env.sh"

printf "%s%b" "${grey}" "\n${two_in}"
printf "=%.0s" {0..92}
printf "%b==  BUILD:  Build Application%b" "\n${two_in}" "\n${two_in}"
printf '=%.0s' {0..92}
printf "%s%b" "${reset}" "${two_in}"
if [[ "${local_build}" == true ]]; then
	if [[ "${target_type}" != 'DOCKER' ]]; then

		. "${BUILDERS}/${target_type}_build.sh"

	fi
else
	printf "%s%b" "${y}" "\n${three_in}"
	printf '!%.0s' {16..92}
	printf "%b!!  BUILD:  Local build skipped%b" "\n${three_in}" "\n${three_in}"
	printf '!%.0s' {16..92}
	printf "%s" "${reset}"
fi

printf "%s%b" "${grey}" "\n${two_in}"
printf "=%.0s" {0..92}
printf "%b==  BUILD:  Build Image%b" "\n${two_in}" "\n${two_in}"
printf '=%.0s' {0..92}
printf "%s%b" "${reset}" "${two_in}"
if [[ "${docker_build}" == true ]]; then

	. "${BUILDERS}/DOCKER_build.sh"

	printf "%s%b"							"${grey}" "\n${two_in}"
	printf "=%.0s"							{16..108}
	printf "%b==  BUILD:  Push image%b"		"\n${two_in}"  "\n${two_in}"
	printf "=%.0s"							{16..108}
	printf "%bPush to registry: %s"			"\n${three_in}"  "${cloud_project_id}/${service_name}/${target_prefix}:${IMAGE_TAG}"

	if [[ "${push}" == true ]]; then
		printf "%b%sPUSHING IMAGE...%s%b"	"${two_down}${three_in}"  "${y}"  "${reset}"  "${two_down}"

		docker-compose push "${service_name}"

		printf "%s%bDONE.%s"				"${g}" "\n${three_in}" "${reset}"
	else
		printf "%s%b"						"${y}"	"\n${three_in}"
		printf "!%.0s"						{24..108}
		printf "%b! BUILD: Skipped%b"		"\n${three_in}" "\n${three_in}"
		printf "!%.0s"						{24..108}
		printf "%s"							"${reset}"
	fi
else
	printf "%s%b"								"${y}" "\n${three_in}"
	printf '!%.0s'								{16..92}
	printf "%b! BUILD: Docker build skipped%b"	"\n${three_in}" "\n${three_in}"
	printf '!%.0s'								{16..92}
	printf "%s"									"${reset}"
fi
