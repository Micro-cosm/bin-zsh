#!/bin/zsh

this_pid=$1;
this_spinner='-\|/';
i=0;
printf "%s"										"${reset}${y}";
while kill -0 "${this_pid}" 2>/dev/null; do
	i=$(( (i+1) %4 ));
	printf "\r %s "								"${this_spinner:$i:1}"
	sleep .2;
done
printf "%s\n"									"${reset}"
printf "%sDONE%s"								"${g}"	"${reset}"
