--!strict
--[[
Simple wrapper function that formats errors.
]]

return function(err: string)
	error(`[Comet] - ` .. err)
end
