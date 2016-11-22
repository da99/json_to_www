
# === {{APP_NAME}}  source.json  output/dir
json-to-www () {

  local SOURCE_JSON="$1"; shift
  local OUTPUT_DIR="$1"; shift

  $0 luajit "$THIS_DIR/src/json_to_www.lua" \
    "$SOURCE_JSON" \
    "$OUTPUT_DIR"

} # === end function
