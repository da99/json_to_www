
# === {{CMD}}  # Setup machine for development.
setup-dev () {
  lua_setup install luajit luarocks
  $0 luarocks install --server=http://luarocks.org/dev trepl-torchless
} # === end function
