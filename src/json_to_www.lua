
local SOURCE_JSON_PATH = arg[1];
local OUTPUT_DIR  = arg[2];
local JSON = require("dkjson");

function read_file(FILE)
  local io_file = io.open(FILE, "rb");
  local contents = io_file:read("*all");
  io_file:close();
  return contents;
end

function app_is_valid(O)
  return true;
end

local obj, pos, err = JSON.decode( read_file(SOURCE_JSON_PATH) );
assert(not err);
assert(app_is_valid(obj));

local app_i=1;
while app_i <= #obj do
  local next_i = app_i + 1;
  local next_obj = obj[next_i];
  assert(type(next_obj) == "table", "Not a table (array)");
  app_i = next_i + 1
end

print(obj[1]);


local HTML_FILE_PATH = OUTPUT_DIR .. "/markup.html";
local HTML_FILE = assert(io.open(HTML_FILE_PATH, "w"));
HTML_FILE:write("<html>Hello World</html>");
HTML_FILE:close();

print("SOURCE_JSON_PATH: " .. SOURCE_JSON_PATH);
print(read_file(SOURCE_JSON_PATH));

print("HTML_FILE_PATH: " .. HTML_FILE_PATH);
print(read_file(HTML_FILE_PATH))


