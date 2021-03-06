#!/bin/zsh

manifest='package.json'
printf "%s\nBuild requested by: %s"  					"${y}"	"${reset}"
printf " %.0s"	{0..16}
printf "%s"												"${target_alias}"
printf "%s\nLooking for '%s' "							"${y}"	"${manifest}"
printf ".%.0s"	{0..6}
if [[ -e "${manifest}" ]]; then
	printf "%s √ %sfound!"								"${g}"  "${reset}"
else
	printf "%s X %sNOT FOUND, quitting"					"${r}"	"${reset}"
	exit 2
fi
if [[ "${target}" == 'LOCAL' ]]; then
	printf "%s\nLooking for 'dist'ination "				"${y}"
	printf ".%.0s"	{0..7}
	if [[ -d "./dist" ]]; then
		printf "%s √ %sfound './dist'!"					"${g}"	"${reset}"
	else
		printf "%s X %sNONE, creating './dist'..."		"${r}"	"${reset}"
		mkdir dist
		chmod -R 777 dist
		printf "done"
	fi
fi

printf "%s\nSTARTING ANGULAR BUILD, using: %s"		"${y}"	"${reset}"
printf " %.0s"	{0..5}
printf "%s%s\n"										"build:ngssc:${target_alias}"
printf " %.0s"	{0..24}
printf "%sfrom:%s"									"${y}"	"${reset}"
printf " %.0s"	{0..6}
printf "%s\n"										"${manifest}"

if ! npm run "build:ngssc:${target_alias}"	>>/dev/null; then

	printf "%sb!!!!! no build:ngssc:%s was found  !!!!!%b%s"	"${r}"	"${two_down}"	"${target_alias}"	"${two_down}"	"${reset}"

	if ! npm run build -- --configuration="${target_alias}"; then

		printf "%sb!!!!! no build -- --configuration=%s was found !!!!!%b%s"			"${r}"	"${two_down}"	"${target_alias}"	"${two_down}"
		printf "%s\n Using default configuration -- '%s' undefined in angular.json"		"${y}"	"${target_alias}"
		printf "  \n You might give this a read to avoid this bit of ugliness in future builds:"
		printf "\n\n https://angular.io/guide/workspace-config"
		printf "\n\n%s"			"${reset}"

		npm run "build:ngssc:local";

	fi
fi

du -hs dist | sort -hr
printf "%sDONE%s"				"${g}"  "${reset}"
