#!/bin/bash
set -euoo pipefail posix
cd "$(dirname "$0")"

# 
function openssl_md4() {
	openssl md4 -provider legacy "$@" 2>/dev/null
}

function content_hash() {
	local -r file="$1"
	openssl_md4 "$file" | awk '{ print substr($NF, 0, 20) }'
}

# 
MAIN_CSS_PARAM="v=$(content_hash ./docs/main.css)"
readonly MAIN_CSS_PARAM

# 
sed -Ei \
	-e 's/(["/]main\.css\?)[^"]*/\1'"$MAIN_CSS_PARAM"'/g' \
	./docs/index.html

# 
echo 'OK'
