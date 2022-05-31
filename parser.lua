local maxWidth, maxHeight = 2048, 2048
local conversionCharacters = {
	[" "] = CellStates.DEAD,
	H = CellStates.HEAD,
	t = CellStates.TAIL,
	["."] = CellStates.WIRE,
}

function love.filedropped(file)
	file:open("r")
	world = file:read("string")
	file:close()
	data = parseFile(world)
	if data == nil then
		love.window.showMessageBox("Width or height exceeds max length limit",
			"Your wireworld exceeds the max width and/or height limit (" ..
			tostring(maxWidth) .. ", " .. tostring(maxHeight) .. " respectively).\n"
			.. "Please reduce the size by removing redundant parts if any.", "warning")
		return
	end
	love.event.push("initCanvas", data)
end

--- @param file string File content needed to be parsed
--- @return table
function parseFile(file)
	local width, height = file:match("^(%d+) +(%d+) *")
	width, height = tonumber(width), tonumber(height)

	if width > maxWidth or height > maxHeight then
		return
	end

	local states = {}
	local lineCounter = 0
	for line in (file .. "\n"):gmatch("(.-)\r?\n") do
		if lineCounter ~= 0 then
			for i = 1, #line do
				table.insert(states, conversionCharacters[line:sub(i, i)] or CellStates.DEAD)
			end
		end
		lineCounter = lineCounter + 1
	end

	return {
		width = width,
		height = height,
		states = states,
	}
end
