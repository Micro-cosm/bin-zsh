#!/bin/zsh

declare fd_init;
declare fd_deploy_rc_script;
declare b;
declare g;
declare r;
declare y;
declare grey;
declare reset;
declare two_down
declare two_in
declare three_in
declare four_in
declare five_in
declare six_in
declare default_cloud_pipeline_json;
declare deploy_return_code;
declare script_prefix;

declare image_tag;
declare log_level;
declare service_name;
declare target;
declare target_domain;
declare target_type;
# declare usage_message;


script_prefix='docker'
fd_init="${PWD}/.fd"
default_cloud_pipeline_json="${PWD}/cloudbuild.json"

two_down='\n\n';
three_down='\n\n\n';
two_in='\t\t';
three_in='\t\t\t';
four_in='\t\t\t\t';
five_in='\t\t\t\t\t';
six_in='\t\t\t\t\t\t';
autoload colors;
colors;

b="${fg[blue]}";
y="${fg[yellow]}";
r="${fg[red]}";
g="${fg[green]}";
grey="${fg[gray]}";
reset="${reset_color}";

export b
export y
export r
export g
export grey
export reset
export two_down
export two_in
export three_in
export four_in
export five_in
export six_in
export default_cloud_pipeline_json;
export script_prefix;

printf "%s\n"								"${grey}"
printf "=%.0s"								{0..108}
printf "\n==  FLEX DEPLOY:  Start\n"
printf '=%.0s'								{0..108}

printf "\n\t"
printf "=%.0s"								{0..100}
printf "\n\t==  ENVIRONMENT\n\t"			"${four_in}"
printf "=%.0s"								{0..100}
printf "\n"
printf "%bLoading project-wide defaults:"	"${two_in} "

. "${fd_init}"

if [[ "${TARGET_DOMAIN}" ]]; then
	target_domain="${(L)TARGET_DOMAIN}"
else
	target_domain="${(L)FD_TARGET_DOMAIN}"
	export TARGET_DOMAIN="${target_domain}"
fi

export fd_rc_script="${PWD}/.fd.${target_domain}"

printf "%s%b"								"${y}"  "\n${two_in}"
printf "=%.0s"								{0..92}
printf "%b==  ENVIRONMENT:  Initialize%b"	"\n${two_in}"  "\n${two_in}"
printf "=%.0s"								{0..92}

. "${fd_rc_script}"
