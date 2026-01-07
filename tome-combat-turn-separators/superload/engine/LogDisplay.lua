local _M = loadPrevious(...)

local base_call = _M.call

function _M:call(str, ...)

	-- Hide empty/whitespace-only messages
	local trimmed = str and str:gsub("%s+", "")
	if not trimmed or #trimmed == 0 then
		return
	end

	base_call(self, str, ...)

end


