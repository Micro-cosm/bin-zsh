#!/bin/zsh

if [[ "${TARGET_ALIAS}" ]]; then
    target_alias="${(L)TARGET_ALIAS}"
else
   target_alias="${(L)FD_TARGET_ALIAS}"
    export TARGET_ALIAS="${target_alias}"
fi
if [[ "${PORT}" ]]; then
    target_port="${PORT}"
    echo
else
    target_port="${FD_TARGET_PORT}"
    export PORT="${target_port}"
    export TARGET_PORT="${target_port}"
fi
if [[ "${TARGET_IMAGE_TAG}" ]]; then
    target_image_tag="${TARGET_IMAGE_TAG}"
else
    target_image_tag="${(L)FD_TARGET_IMAGE_TAG}"
    export TARGET_IMAGE_TAG="${target_image_tag}"
fi
if [[ "${LOG_LEVEL}" ]]; then
    # log_level="${(U)LOG_LEVEL}"
    log_level="INFO"
else
    log_level="${(U)FD_LOG_LEVEL}"
    export LOG_LEVEL="${log_level}"
fi
if [[ "${TARGET_PROJECT_ID}" ]]; then
    target_project_id="${(L)TARGET_PROJECT_ID}"
else
    target_project_id="${(L)FD_TARGET_PROJECT_ID}"
    export TARGET_PROJECT_ID="${target_project_id}"
fi
if [[ "${SERVICE_NAME}" ]]; then
    service_name="${(L)SERVICE_NAME}"
else
    service_name="${(L)FD_SERVICE_NAME}"
    export SERVICE_NAME="${service_name}"
fi
if [[ "${TARGET}" ]]; then
    target="${(U)TARGET}"
else
    target="${(U)FD_TARGET}"
    export TARGET="${target}"
fi
if [[ "${BUILD_CONTEXT}" ]]; then
    build_context="${(U)BUILD_CONTEXT}"
else
    build_context="${(U)FD_BUILD_CONTEXT}"
    export BUILD_CONTEXT="${build_context}"
fi

printf "%s\nLooking for a target alias "			"${y}"
printf ".%.0s"  {0..6}
if [[ "${target_alias}" ]]; then
	printf "%s √ %s%s"								"${g}"  "${reset}"  "${target_alias}"
else
	target_alias="dev"
	printf "%s X %s\tNONE FOUND... default:\t%s"	"${r}"	"${reset}"	"${target_alias}"
fi

printf "%s\nLooking for required arguments "		"${y}"
printf ".%.0s"  {0..2}
if [[ ! $# -gt 0 ]]; then
    printf "%s \t X %s\trequired...quitting%b"		"${r}" "${reset}"  "${two_down}"
    printf "%b%s%b"									"${two_down}"  "\t${usage_message}"  "${two_down}"
    exit 1
else
    printf "%s √ %sfound!"							"${g}"  "${reset}"
    while [[ $# -gt 0 ]]; do
        printf "%s\n  Consume next "				"${y}"
		printf ".%.0s"  {0..18}
        case "$1" in
            --local | -l | -local)
                printf "%s √ %s--local"				"${g}"  "${reset}"
                target='LOCAL'
                export TARGET="${target}"
            ;;
            --remote=* | -r=* | -remote )
                target_alias="${(L)1#*=}"
                target='REMOTE'
                export TARGET_ALIAS="${target_alias}"
                printf "%s √ %s--remote"				"${g}"  "${reset}"
                export TARGET="${target}"
           ;;
            --nobuild | -nb)
                local_build=false
                printf "%s √ %s--nobuild"				"${g}"  "${reset}"
            ;;
            --nodocker | -nd)
                docker_build=false
                printf "%s √ %s--nodocker"				"${g}"  "${reset}"
            ;;
            --nopull | -npll)
                pull=false
                printf "%s √ %s--nopull"				"${g}"  "${reset}"
            ;;
            --nopush | -npsh)
                push=false
                printf "%s √ %s--nopush"				"${g}"  "${reset}"
            ;;
            --service_name=* | -s=* )
       			service_name="${(L)1#*=}"
                export SERVICE_NAME="${service_name}"
                printf "%s √ %s--service_name=%s"		"${g}"  "${reset}"  "${service_name}"
            ;;
			--target_domain=* | -td=* )
				export TARGET_DOMAIN="${1#*=}"
				printf "%s √ %s--target_domain=%s"		"${g}"  "${reset}"  "${TARGET_DOMAIN}"
			;;
            \? | --help | -h)
                printf "%s √ %s--help\tquitting" 		"${g}"  "${reset}"
                printf "%b%s%s%s%b" 					"${three_down}"  "${b}"  "${usage_message}"  "${reset}"  "${two_down}"
                exit 0
            ;;
           *)
               printf "%s X %s '%s' unknown...continue(Y|n)?"	"${r}"  "${reset}"  "${1}"
               read -r
           ;;
        esac
        shift
    done
fi

printf "%s\nDONE%s"		"${g}"	"${reset}"
