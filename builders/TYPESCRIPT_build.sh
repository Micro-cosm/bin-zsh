#!/bin/zsh

manifest='package.json'

printf "%bBuild requested for:%b%s%s%s"						"\n${three_in}"  "${three_in}"  "${g}"  "${target_prefix}"  "${reset}"
printf "%bLooking for a known manifest ..."					"\n${four_in}"
if [[ -e "${manifest}" ]]; then
	printf "%s √ %sfound %s" 								"${g}" "${reset}"  "${manifest}"
else
	printf "%s X %s\t%s NOT FOUND...quitting%b"				"${r}" "${reset}"  "${manifest}"  "${two_down}"
	exit 2
fi
if [[ "${target}" == 'LOCAL' ]]; then
	printf "%bLooking for 'dist'ination ......"				"\n${four_in}"

	if [[ -d "./dist" ]]; then
		printf "%s √ %sfound './dist'"						"${g}" "${reset}"
	else
		printf "%s X %s NOT FOUND...creating './dist/'"		"${r}" "${reset}"
		mkdir dist
		chmod -R 777 dist
		printf "done"
	fi
fi

printf "%s%bSTARTING TYPESCRIPT LOCAL BUILD...%b%s"			"${y}"  "${two_down}${three_in}"  "\n"  "${reset}"
if ! npm run "build:${target_prefix}"; then

		npm run "build:ngssc:local" 2>>./.fd.error.log;
fi
printf "%s%bDONE.%s"										"${g}"  "${three_in}"  "${reset}"
