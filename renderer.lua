require("themes")

local width, height, states

function initCanvas(payload)
	width, height, states = payload.width, payload.height, payload.states
	imageData = love.image.newImageData(width, height)
	imageData:mapPixel(render)
	canvas = love.graphics.newImage(imageData, { mipmaps = true })
	canvas:setFilter("nearest", "nearest")
	initPanAndZoom(love.graphics.getWidth(), love.graphics.getHeight(), width, height)
end

function render(x, y)
	local hex = Themes.salmon[states[x + y * width + 1]]
	return bit.rshift(hex, 16) / 255.0,
		bit.band(bit.rshift(hex, 8), 0xff) / 255.0,
		bit.band(hex, 0xff) / 255.0, 1.0
end

--- @todo more rendering stuff.
