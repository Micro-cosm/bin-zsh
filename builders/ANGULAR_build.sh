#!/bin/zsh

manifest='package.json'

printf "%bBuild requested for:\t%s%s%s"							"\n${three_in}"  "${g}"  "${target_prefix}"  "${reset}"
printf "%bLooking for '%s'......"								"\n${four_in}"   "${manifest}"

if [[ -e "${manifest}" ]]; then
	printf "%s √ %s \t found!"									"${g}"  "${reset}"
else
	printf "%s X %s\t NOT FOUND...but required!  Quitting..."	"${r}" "${reset}"
	exit 2
fi

if [[ "${target}" == 'LOCAL' ]]; then
	printf "% Looking for a dist-ination......"					"\n${four_in}"

	if [[ -d "./dist" ]]; then
		printf "%s √ %s\t found! \t './dist'"					"${g}"  "${reset}"
	else
		printf "%s X %s\t NONE FOUND...creating './dist/'..."	"${r}" "${reset}"
		mkdir dist
		chmod -R 777 dist
		printf "done"
	fi
fi


printf "%s%bSTARTING ANGULAR LOCAL BUILD...%b%s"				"${y}"  "${two_down}${three_in}"  "${two_down}"  "${reset}"


if ! npm run "build:ngssc:${target_prefix}"; then
	if ! npm run build -- --configuration="${target_prefix}" 2>>./.fd.error.log; then
		printf "%s\n\t A default configuration was used, '%s' was not defined in angular.json"		"${y}"  "${target_prefix}"
		printf "  \n\t You might give this a read to avoid this bit of ugliness in future builds:"
		printf "\n\n\t\t https://angular.io/guide/workspace-config"
		printf "\n\n%s"	"${reset}"

		npm run "build:ngssc:local" 2>>./.fd.error.log;
	fi
fi


printf "%s%bDONE.%s"											"${g}"  "\n${three_in}"  "${reset}"

