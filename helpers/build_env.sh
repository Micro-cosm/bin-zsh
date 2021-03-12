#!/bin/zsh

if [[ "${TARGET_LOCAL_PORT}" ]]; then
    target_local_port="${(L)TARGET_LOCAL_PORT}"
else
   target_local_port="${(L)FD_TARGET_LOCAL_PORT}"
    export TARGET_LOCAL_PORT="${target_local_port}"
fi
if [[ "${TARGET}" ]]; then
    target="${(L)TARGET}"
else
   target="${(L)FD_TARGET}"
   export TARGET="${target}"
fi
if [[ "${NICKNAME}" ]]; then
    nickname="${(L)NICKNAME}"
else
   nickname="${(L)FD_NICKNAME}"
    export NICKNAME="${nickname}"
fi
if [[ "${TARGET_REALM}" ]]; then
    target_realm="${(L)TARGET_REALM}"
else
   target_realm="${(L)FD_TARGET_REALM}"
    export TARGET_REALM="${target_realm}"
fi
if [[ "${TARGET_ALIAS}" ]]; then
    target_alias="${(L)TARGET_ALIAS}"
else
   target_alias="${(L)FD_TARGET_ALIAS}"
    export TARGET_ALIAS="${target_alias}"
fi
if [[ "${PORT}" ]]; then
    target_remote_port="${PORT}"
    echo
else
    target_remote_port="${FD_TARGET_REMOTE_PORT}"
    export PORT="${target_remote_port}"
    export TARGET_REMOTE_PORT="${target_remote_port}"
fi
if [[ "${TARGET_IMAGE_TAG}" ]]; then
    target_image_tag="${TARGET_IMAGE_TAG}"
else
    target_image_tag="${(L)FD_TARGET_IMAGE_TAG}"
    export TARGET_IMAGE_TAG="${target_image_tag}"
fi
if [[ "${TARGET_LOG_LEVEL}" ]]; then
    target_log_level="${(U)TARGET_LOG_LEVEL}"
    # target_log_level="INFO"
else
    target_log_level="${(U)FD_TARGET_LOG_LEVEL}"
    export TARGET_LOG_LEVEL="${target_log_level}"
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

printf "%s\nLooking for a target alias "				"${y}"
printf ".%.0s"  {0..6}
if [[ "${target_alias}" ]]; then
	printf "%s √ %s%s"									"${g}"  "${reset}"  "${target_alias}"
else
	target_alias="dev"
	printf "%s X %s\tNONE FOUND... default:\t%s"		"${r}"	"${reset}"	"${target_alias}"
fi

printf "%s\nLooking for required arguments "			"${y}"
printf ".%.0s"  {0..2}
if [[ ! $# -gt 0 ]]; then
    printf "%s \t X %s\trequired...quitting%b"			"${r}" "${reset}"  "${two_down}"
    printf "%b%s%b"										"${two_down}"  "\t${usage_message}"  "${two_down}"
    exit 1
else
    printf "%s √ %sfound!"								"${g}"  "${reset}"
    while [[ $# -gt 0 ]]; do
        printf "%s\n  Consume next "					"${y}"
		printf ".%.0s"  {0..18}
        case "$1" in
            --local | -l | -local)
                printf "%s √ %s--local"					"${g}"  "${reset}"
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
