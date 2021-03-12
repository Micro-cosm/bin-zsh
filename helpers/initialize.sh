#!/bin/zsh

script_prefix='docker'
fd_init="${PWD}/.fd.rc"
default_cloud_pipeline_json="${PWD}/cloudbuild.json"
two_down='\n\n';
three_down='\n\n\n';
two_in='\t\t';
three_in='\t\t\t';
four_in='\t\t\t\t';
five_in='\t\t\t\t\t';
six_in='\t\t\t\t\t\t';
seven_in='\t\t\t\t\t\t\t';

autoload colors;
colors;

b="${fg[blue]}";
g="${fg[green]}";
o="${fg[yellow]}";
r="${fg[red]}";
w="${fg[cyan]}";
y="${fg[yellow]}";
bgw="${bg[white]}";
bgb="${bg[black]}";
grey="${fg[gray]}";
reset="${reset_color}";

export b;
export g;
export o;
export r;
export y;
export w;
export bgw;
export bgb;
export grey;
export reset;
export two_down;
export two_in;
export three_in;
export four_in;
export five_in;
export six_in;
export seven_in;
export default_cloud_pipeline_json;
export script_prefix;

# echo -e "\e]8;;http://example.com\a This is a link \e]8;;\a"  														### Trying to get a clickable link capable of cut/paste commands

printf "%s"								"${b}"
printf "\nFLEX DEPLOY %bbin-zsh\n"		"${six_in}"
printf '=%.0s'							{0..80}
printf "\n= ENVIRONMENT %b%s"			"${six_in}"	"${fd_init}";
if [[ -r "${fd_init}" ]]; then

	. "${fd_init}"

else
	printf "\n\t";
	printf "%s%b%s NOT FOUND or lacks read permission, quitting...%b"	"${r}"	"${two_down}"	"${fd_init}"	"${two_down}"
	printf "\n%s" 	"${reset}";
	exit 1;
fi
if [[ "${TARGET_DOMAIN}" ]]; then
	target_domain="${(L)TARGET_DOMAIN}"
else
	target_domain="${(L)FD_TARGET_DOMAIN}"
	export TARGET_DOMAIN="${target_domain}"
fi
export fd_rc_script="${PWD}/.fd.${target_domain}"
printf "%s\n==  ENVIRONMENT: Init %b%s"  "${b}"		"${five_in}"	"${fd_rc_script}"
if [[ -r "${fd_rc_script}" ]]; then

	. "${fd_rc_script}"

else
	printf "%b"  "${two_down}";
	printf "%s%s NOT FOUND or lacks read permissions.  Quitting...%b"  "${r}"  "${fd_rc_script}";
	printf "%b%s"  "${two_down}"  "${reset}";
	exit 1;
fi
