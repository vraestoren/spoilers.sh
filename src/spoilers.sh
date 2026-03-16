#!/bin/bash

api="https://api-spoiler.panfilov.tech"
params=null
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36"

function _get() {
    curl --request GET \
        --url "$api/$1" \
        --user-agent "$user_agent" \
        --header "content-type: application/json" \
        --header "x-query-params: $params"
}

function _post() {
    curl --request POST \
        --url "$api/$1" \
        --user-agent "$user_agent" \
        --header "content-type: application/json" \
        --header "x-query-params: $params" \
        ${2:+--data "$2"}
}

# 1 - sign: (string): <sign>
# 2 - vk_user_id: (integer): <vk_user_id>
# 3 - vk_ts: (integer): <vk_ts>
# 4 - vk_ref: (string): <vk_ref>
# 5 - access_token_settings: (string): <access_token_settings - default: >
# 6 - are_notifications_enabled: (integer): <are_notifications_enabled - default: 0>
# 7 - is_app_user: (integer): <is_app_user - default: 0>
# 8 - is_favorite: (integer): <is_favorite - default: 0>
# 9 - language: (string): <language - default: ru>
# 10 - platform: (string): <platform - default: desktop_web>
function authenticate() {
    params="vk_access_token_settings=${5:-}&vk_app_id=51515102&vk_are_notifications_enabled=${6:-0}&vk_is_app_user=${7:-0}&vk_is_favorite=${8:-0}&vk_language=${9:-ru}&vk_platform=${10:-desktop_web}&vk_ref=$4&vk_ts=$3&vk_user_id=$2&sign=$1"
    echo "$params"
}

# 1 - limit: (integer): <limit - default: 10>
function get_spoilers() {
    _get "spoilers/get/all?limit=${1:-10}"
}

# 1 - query: (string): <query>
function search_movie() {
    _get "movies/search?language=ru-RU&query=$1"
}

# 1 - movie_id: (integer): <movie_id>
function get_movie_info() {
    _get "movies/get/$1"
}

# 1 - movie_id: (integer): <movie_id>
# 2 - limit: (integer): <limit - default: 10>
function get_movie_spoilers() {
    _get "spoilers/get/film/$1?limit=${2:-10}"
}

# 1 - spoiler_id: (integer): <spoiler_id>
function get_spoiler_info() {
    _get "spoilers/get/one/$1"
}

# 1 - vk_user_id: (integer): <vk_user_id>
# 2 - limit: (integer): <limit - default: 10>
function get_user_spoilers() {
    _get "spoilers/get/user/$1?limit=${2:-10}"
}

# 1 - movie_id: (integer): <movie_id>
# 2 - text: (string): <text>
function insert_spoiler() {
    _post "spoilers/insert" \
        "{\"film_id\":\"$1\",\"text\":\"$2\"}"
}

# 1 - spoiler_id: (integer): <spoiler_id>
# 2 - movie_id: (integer): <movie_id>
# 3 - text: (string): <text>
function update_spoiler() {
    _post "spoilers/update" \
        "{\"spoiler_id\":\"$1\",\"film_id\":\"$2\",\"text\":\"$3\"}"
}

# 1 - spoiler_id: (integer): <spoiler_id>
function delete_spoiler() {
    _post "spoilers/delete" \
        "{\"spoiler_id\":\"$1\"}"
}

# 1 - spoiler_id: (integer): <spoiler_id>
function like_spoiler() {
    _post "spoilers/like" \
        "{\"spoiler_id\":\"$1\"}"
}

# 1 - vk_user_id: (integer): <vk_user_id>
function report_user() {
    _post "users/report" \
        "{\"user_id\":\"$1\"}"
}
