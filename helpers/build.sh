#!/bin/zsh

printf "%s\n= BUILD"  "${b}";

. "${HELPERS}/build_env.sh"

printf "%s\n==  BUILD:  Build Application %b%s"		"${b}"	"${four_in}"	"${BUILDERS}/${build_context}_build.sh";
printf "%s%b" "${reset}" "${two_in}"
if [[ "${local_build}" == true ]]; then
	if [[ "${build_context}" != 'DOCKER' ]]; then

		. "${BUILDERS}/${build_context}_build.sh"

	fi
else
	printf "%s\n" "${y}"
	echo "!!  BUILD:  Local build skipped"
	printf "%s" "${reset}"
fi
printf "%s\n==  BUILD:  Build Image %b%s%s"			"${b}"	"${four_in}"	"${BUILDERS}/DOCKER_build.sh"	"${reset}"

if [[ "${docker_build}" == true ]]; then

	. "${BUILDERS}/DOCKER_build.sh"

	printf "%s\n==  BUILD:  Push Image %b%s"			"${b}"	"${five_in}"	"${BUILDERS}/DOCKER_build.sh"
	printf "%s\nPush registry:%s"						"${y}"	"${reset}"
	printf " %.0s"	{0..20}
	printf "%s"											"us.gcr.io/${target_project_id}/${service_name}/${target_alias}:${target_image_tag}"
	if [[ "${push}" == true ]]; then
		printf "%s\nPUSHING IMAGE, using:"				"${y}"
		printf "%b   $%s  docker-compose push %s  "	"\n"	"${bgb}${w}"	"${service_name}"


		docker-compose push "${service_name}"  >>/dev/null  2>&1  &;

		this_pid=$!;
		this_spinner='-\|/';
		i=0;
		printf "%s"									"${reset}${y}";
		while kill -0 "${this_pid}" 2>/dev/null; do
			i=$(( (i+1) %4 ));
			printf "\r %s "							"${this_spinner:$i:1}"
			sleep .2;
		done
		printf "%s\n"								"${reset}";
		printf "%sDONE%s"							"${g}"	"${reset}";
	else
		printf "%s%b"								"${y}"	"\n${three_in}"
		printf "!%.0s"	{24..108}
		printf "%b! BUILD: Skipped%b"				"\n${three_in}" "\n${three_in}"
		printf "!%.0s"	{24..108}
		printf "%s"									"${reset}"
	fi
else
	printf "%s%b"									"${y}" "\n${three_in}"
	printf "!%.0s"	{16..92}
	printf "%b! BUILD: Docker build skipped%b"		"\n${three_in}" "\n${three_in}"
	printf "!%.0s"	{16..92}
	printf "%s"										"${reset}"
fi
