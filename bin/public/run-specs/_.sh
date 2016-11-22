
# === {{CMD}}
run-specs () {
for x in "$(find "$THIS_DIR/specs" -maxdepth 2 -mindepth 2 -type f -name "_.sh")" ; do
  sh_specs run-file "$x"
done
} # === end function
