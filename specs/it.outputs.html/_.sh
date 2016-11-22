
TEMP="$(mktemp -d)"


should-file-match \
  "$TEMP/markup.html"  \
  "$THIS_DIR/expect/markup.html" \
  " bin/json_to_www translate $THIS_DIR/homepage.json "$TEMP" "
