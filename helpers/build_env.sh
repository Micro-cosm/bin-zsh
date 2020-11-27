#!/bin/zsh

if [[ "${TARGET_PREFIX}" ]]; then
    target_prefix="${(L)TARGET_PREFIX}"
else
   target_prefix="${(L)FD_TARGET_PREFIX}"
    export TARGET_PREFIX="${target_prefix}"
fi
if [[ "${PORT}" ]]; then
    target_port="${PORT}"
    echo
else
    target_port="${FD_TARGET_PORT}"
    export PORT="${target_port}"
    export TARGET_PORT="${target_port}"
fi
if [[ "${IMAGE_TAG}" ]]; then
    image_tag="${IMAGE_TAG}"
else
    image_tag="${(L)FD_IMAGE_TAG}"
    export IMAGE_TAG="${image_tag}"
fi
if [[ "${LOG_LEVEL}" ]]; then
    # log_level="${(U)LOG_LEVEL}"
    log_level="INFO"
else
    log_level="${(U)FD_LOG_LEVEL}"
    export LOG_LEVEL="${log_level}"
fi
if [[ "${CLOUD_PROJECT_ID}" ]]; then
    cloud_project_id="${(L)CLOUD_PROJECT_ID}"
else
    cloud_project_id="${(L)FD_CLOUD_PROJECT_ID}"
    export CLOUD_PROJECT_ID="${cloud_project_id}"
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
if [[ "${TARGET_TYPE}" ]]; then
    target_type="${(U)TARGET_TYPE}"
else
    target_type="${(U)FD_TARGET_TYPE}"
    export TARGET_TYPE="${target_type}"
fi


printf "%bLooking for a target prefix ............"		"\n${three_in}"
if [[ "${target_prefix}" ]]; then
	printf "%s √ %s%s"									"${g}"  "${reset}"  "${target_prefix}"
else
	target_prefix="dev"
	printf "%s X %s\tNONE FOUND... default:\t%s"		"${r}"	"${reset}"	"${target_prefix}"
fi


printf "%s%bLooking for required arguments ........."	"${reset}" "\n${three_in}"


if [[ ! $# -gt 0 ]]; then
    printf "%s \t X %s\trequired...quitting%b"			"${r}" "${reset}"  "${two_down}"
    printf "%b%s%b"										"${two_down}"  "\t${usage_message}"  "${two_down}"

    exit 1
else

    printf "%s √ %sfound!"								"${g}"  "${reset}"

    while [[ $# -gt 0 ]]; do

        printf "%bConsume next ..................."		"\n${four_in}"
        case "$1" in
            --local | -l | -local)
                printf "%s √ %s--local"			"${g}"  "${reset}"
                target='LOCAL'
                export TARGET="${target}"
            ;;
            --remote=* | -r=* | -remote )
                target_prefix="${(L)1#*=}"
                target='REMOTE'
                export TARGET_PREFIX="${target_prefix}"
                printf "%s √ %s--remote"	"${g}"  "${reset}"
                export TARGET="${target}"
           ;;
            --nobuild | -nb)
                local_build=false
                printf "%s √ %s--nobuild"	"${g}"  "${reset}"
            ;;
            --nodocker | -nd)
                docker_build=false
                printf "%s √ %s--nodocker"	"${g}"  "${reset}"
            ;;
            --nopull | -npll)
                pull=false
                printf "%s √ %s--nopull"	"${g}"  "${reset}"
            ;;
            --nopush | -npsh)
                push=false
                printf "%s √ %s--nopush"	"${g}"  "${reset}"
            ;;

            --service_name=* | -s=* )
                service_name="${1#*=}"
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
               printf "%s X %s\t'%s' unknown...continue(Y|n)?"	"${r}"  "${reset}"  "${1}"
               read -r
           ;;
        esac
        shift
    done
fi

printf "%s%bDONE.%s"	"${g}"  "\n${three_in}"  "${reset}"
