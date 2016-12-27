
function read_file(PAGE_PATH)
  local f = io.open(PAGE_PATH, 'r')
  local content = f:read("*a")
  f:close()
  return content
end

function main()
  local Pretty = require("pl.pretty");
  local CJSON_SAFE = require("cjson.safe");
  CJSON_SAFE.decode_max_depth(100);

  local PAGE_PATH=arg[1];
  local RAW=read_file(PAGE_PATH);

  local PROG, err = CJSON_SAFE.decode(RAW);
  Pretty.dump(PROG);
  if err then
    error("Invalid JSON");
  end

  local CURRENT = 1;
  local LAST = #PROG;
  local STATE = NEW_STATE();

  while CURRENT <= LAST do
    STATE, PROG, CURRENT = compile(STATE, PROG, CURRENT)
  end

  print("================");
  Pretty.dump(STATE);
end

function compile (state, prog, pos)
  local CURRENT = prog[pos];
  local NEXT    =  nil
  if pos + 1 <= #prog then
    NEXT = prog[pos + 1];
  end

  local CURRENT_TYPE = type(CURRENT);

  if CURRENT_TYPE == "number" then
    state.STACK[#state.STACK + 1] = CURRENT;

  elseif CURRENT_TYPE == "table" then
    error("Invalid program: function with no name.")

  elseif CURRENT_TYPE == "string" and type(NEXT) == "table" then
    local the_function = find_function(CURRENT, state)
    if type(the_function) ~= "function" then
      error("Function not found: " .. CURRENT)
    end
    print("found a function call: " .. CURRENT);
    pos = pos + 1

  elseif CURRENT_TYPE == "string" then
    print("found a string: " .. CURRENT);

  else
    error("Unknown type: " .. CURRENT_TYPE .. ": " ..tostring(CURRENT));
  end -- SWITCH CURRENT

  return state, prog, (pos + 1);
end

local FUNCS = {}
local DYNA_FUNCS = {}

FUNCS["title"] = function (state, prog, position)
  return state, prog, position;
end

FUNCS["div"] = function (state, prog, position)
  return state, prog, position;
end

FUNCS["style"] = function (state, prog, pos)
  state["STACK"][#state["STACK"] + 1] = "styles"
  return state, prog, position;
end

DYNA_FUNCS["Create HTML"] = {
  is = function (name, state, prog, pos)
    local TAG          = name:match("([%a%d_]+)%.[%#%a%d_]+")
    local TAG_FUNC     = find_function(TAG, state)
    local CLASS_AND_ID = name:match("[%a%d_]+%.([%#%.%a%d_]+)")
    return TAG ~= nil and type(TAG_FUNC) == "function" and type(CLASS_AND_ID) == "string";
  end,

  func = function ()
  end
}

function NEW_STATE ()
  return({ STACK = {}, FUNCS = FUNCS, DYNA_FUNCS = DYNA_FUNCS });
end

function find_function (name, state)
  local FUNC = state["FUNCS"][name];
  if FUNC ~= nil then
    return FUNC;
  end

  if FUNC == nil and type(state["PARENT"]) == "table" then
    return find_function(NAME, state["PARENT"]);
  end

  return nil;
end



main()

