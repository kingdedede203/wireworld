require("CellStates")
require("panAndZoom")
require("parser")
require("renderer")

local lg = love.graphics

function love.load()
	shader = lg.newShader("shaders/checkered.glsl")

	moveCursor = love.mouse.getSystemCursor("sizeall")

	local defaultData = parseFile(love.filesystem.read("string", "examples/full_adder.txt"))

	initCanvas(defaultData)
	--- @diagnostic disable-next-line: undefined-field
	love.handlers.initCanvas = initCanvas
end

function love.update(dt) end

function love.draw()
	-- checkered background
	lg.setShader(shader)
	lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())
	lg.setShader()

	-- canvas
	local xCanvas, yCanvas = worldToScreen(0, 0)
	-- print(scaleFactor)
	lg.draw(canvas, xCanvas, yCanvas, 0, scaleFactor, scaleFactor)
end
