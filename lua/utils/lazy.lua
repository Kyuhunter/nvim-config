local M = {}

local misc = require('mini.misc')

function M.later(f) misc.safely('later', f) end
function M.on_event(ev, f) misc.safely('event:' .. ev, f) end

return M

