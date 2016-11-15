
TEMP="$(mktemp -d)"
bin/json_to_www luajit src/json_to_www.lua $THIS_DIR/homepage.json "$TEMP"

should-file-match "$TEMP/markup.html"  "$THIS_DIR/expect/markup.html"
