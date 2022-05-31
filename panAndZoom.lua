xOffset, yOffset = 0, 0
scaleFactor = 1.0
mouseHeld = false

--- @param screenHeight number # screen width
--- @param screenWidth number # screen height
--- @param width number # width of the canvas
--- @param height number # height of the canvas
function initPanAndZoom(screenHeight, screenWidth, width, height)
	-- precise fit
	if width / height < screenHeight / screenWidth then
		scaleFactor = screenWidth / height
	else
		scaleFactor = screenHeight / width
	end

	-- don't round if window height is less than canvas height
	if screenWidth < height then
		goto setOffset
	end

	-- round down to add padding
	if scaleFactor >= 1 then
		scaleFactor = math.floor(scaleFactor)
	else
		scaleFactor = 1 / math.ceil(1 / scaleFactor)
	end

	::setOffset::
	xOffset = (width * scaleFactor - screenHeight) / (2 * scaleFactor)
	yOffset = (height * scaleFactor - screenWidth) / (2 * scaleFactor)
end

--- @param xWorld number # x world coordinate
--- @param yWorld number # y world coordinate
--- @return number, number # screen coordinates after conversion
function worldToScreen(xWorld, yWorld)
	return (xWorld - xOffset) * scaleFactor, (yWorld - yOffset) * scaleFactor
end

--- @param xScreen number # x screen coordinate
--- @param yScreen number # y screen coordinate
--- @return number, number # world coordinates after conversion
function screenToWorld(xScreen, yScreen)
	return xScreen / scaleFactor + xOffset, yScreen / scaleFactor + yOffset
end

-- panning
function love.mousepressed(_, _, button)
	if button == 1 then
		mouseHeld = true
		love.mouse.setCursor(moveCursor)
	end
end

function love.mousemoved(_, _, dx, dy)
	if mouseHeld then
		xOffset, yOffset = xOffset - dx / scaleFactor, yOffset - dy / scaleFactor
	end
end

function love.mousereleased(_, _, button)
	if button == 1 then
		mouseHeld = false
		love.mouse.setCursor()
	end
end

-- zooming
function love.wheelmoved(_, y)
	xBeforeZoom, yBeforeZoom = screenToWorld(love.mouse.getPosition())
	scaleFactor = scaleFactor * (y > 0 and 1.05 or y < 0 and 0.95 or 1.0) ^ math.abs(y)
	xAfterZoom, yAfterZoom = screenToWorld(love.mouse.getPosition())

	xOffset, yOffset = xOffset + xBeforeZoom - xAfterZoom, yOffset + yBeforeZoom - yAfterZoom
end
