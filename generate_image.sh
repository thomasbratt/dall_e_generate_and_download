#!/bin/bash

# -----------------------------------------------------------------------------
# Generate an image from the OpenAI service given a prompt and image size.
#
# Requires the OpenAI API key to be stored in a text file named 'api.key'
# -----------------------------------------------------------------------------

OPENAI_API_KEY="$(<api.key)"

check_arguments(){
    if [[ ${1} -ne 2 ]]; then
        printf 'Example usage: %s "prompt text" 256x256\n' "${2}" >&2
        return 1
    fi
}

generate(){
    local prompt="${1}"
    local size="${2}"
    curl https://api.openai.com/v1/images/generations   \
      -H 'Content-Type: application/json'               \
      -H "Authorization: Bearer ${OPENAI_API_KEY}"      \
      -d '{
        "prompt": "'"${prompt}"'",
        "n": 1,
        "size": "'"${size}"'"
      }' \
    | tr '[:space:]' ' '
}

download(){
    local remote_file_name="${1}"
    local local_file_name="${2}"
    curl "${remote_file_name}" --output "${local_file_name}"
}

prompt_to_local_file_name(){
    local prompt="${1}"
    local temp
    temp="$(tr '[:space:]' '_' <<< "${prompt}")"
    printf '%s.png' "${temp}"
}

extract_remote_file_name(){
    local response="${1}"
    grep -Eo 'https[^"]+' <<< "${response}" 
}

generate_and_download(){
    local prompt="${1}"
    local size="${2}"
    local response
    local remote_file_name
    local local_file_name

    response="$(generate "${prompt}" ${size})"                                      || return $?
    remote_file_name="$(extract_remote_file_name "${response}")"                    || return $?
    local_file_name="$(prompt_to_local_file_name "${prompt}")"                      || return $?
    download "${remote_file_name}" "${local_file_name}"                             || return $?
}

main(){
    check_arguments         "$#" "$0" || return $? 
    generate_and_download   "$1" "$2" || return $?
}

main "$@"

