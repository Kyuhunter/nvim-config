local M = {}

local misc = require('mini.misc')

function M.later(f) misc.safely('later', f) end
function M.on_event(ev, f) misc.safely('event:' .. ev, f) end
function M.on_filetype(ft, f) misc.safely('filetype:' .. ft, f) end

return M

