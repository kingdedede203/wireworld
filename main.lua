local lg = love.graphics

require("CellStates")
require("panAndZoom")
require("parser")
require("renderer")
require("gui.buttons")

function love.load()
	shader = lg.newShader("shaders/checkered.glsl")

	moveCursor = love.mouse.getSystemCursor("sizeall")

	canvasData = parseFile(love.filesystem.read("string", "examples/wireworld_computer.txt"))

	initCanvas(canvasData)

	playpauseButton = newButton("left", (lg.getWidth() - 53) / 2, 16, 25, 30, { "pause", "play" },
		function() end,
		function(x, y, w, h, state)
			local xCentre, yCentre = x + (w - h / 2) / 2, y + h / 2
			lg.setColor(0.13, 0.13, 0.13)
			if state == "play" then
				lg.rectangle("fill", xCentre - 5, yCentre - 7, 5, 14)
				lg.rectangle("fill", xCentre + 4, yCentre - 7, 5, 14)
			else
				lg.polygon("fill", { xCentre - 4, yCentre - 8, xCentre - 4, yCentre + 8, xCentre + 9, yCentre })
			end
		end)
	stopButton = newButton("right", playpauseButton.x + playpauseButton.width + 3, 16, 25, 30, { "stop" },
		function() end, function(x, y, w, h)
		lg.setColor(0.13, 0.13, 0.13)
		lg.rectangle("fill", x + w + h / 2 - (w + h / 2) / 2 - 9, y + h / 2 - 7, 14, 14)
	end)
end

function love.update()
	updateButtons()
end

function love.draw()
	-- checkered background
	lg.setShader(shader)
	lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())
	lg.setShader()

	-- canvas
	local xCanvas, yCanvas = worldToScreen(0, 0)
	lg.draw(canvas, xCanvas, yCanvas, 0, scaleFactor, scaleFactor)

	-- buttons
	drawButtons()
end
