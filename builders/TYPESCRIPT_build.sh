#!/bin/zsh

manifest='package.json'
printf "%s\nBuild requested: "					"${y}"
printf " %.0s"	{0..18}
printf "%s%s"									"${reset}"	"${target_alias}${reset}"
printf "%s\n  Looking for a known manifest "	"${y}"
printf ".%.0s"	{0..2}
if [[ -e "${manifest}" ]]; then
	printf "%s √ %sfound %s" 					"${g}" "${reset}"  "${manifest}"
else
	printf "%s X %sNOT FOUND...quitting%b"		"${r}"  "${reset}${manifest}"  "${two_down}"
	exit 2
fi
if [[ "${target}" == 'LOCAL' ]]; then
	printf "%s\nLooking for 'dist'ination "		"${y}"
	printf ".%.0s"	{0..8}

	if [[ -d "./dist" ]]; then
		printf "%s √ %sfound './dist'"			"${g}" "${reset}"
	else
		printf "%s X NOT FOUND..."				"${r}"
		printf "%s creating %s'./dist/'"		"${y}"	"${reset}"
		mkdir dist
		chmod -R 777 dist
		printf "done"
	fi
fi

printf "%s\n\nSTARTING TYPESCRIPT LOCAL BUILD...%s"	"${y}"	"${reset}"
if ! npm run "build:${target_alias}"; then

		npm run "build:ngssc:local";

fi
printf "%sDONE%s"  "${g}"  "${reset}"
