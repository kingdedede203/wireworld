buttons = {}

local defaultColour = { 0.6, 0.6, 0.6, }
local hoverColour   = { 0.87, 0.87, 0.87, }
local activeColour  = { 0.4, 0.4, 0.4, }

--- @param type "left"|"right" # button type. can be either left or right
--- @param x number # x coordinate of the rectangular part of the button
--- @param y number # y coordinate of the rectangular part of the button
--- @param width number # width of the rectangular part
--- @param height number # height of the rectangular part
--- @param states table # the possible states the button could take. clicking the button would cycle through these states
--- @param callback fun()
--- @param drawFunction fun(x: number, y: number, width: number, height: number, state: any) # function called to draw button content. `x` and `y` coordinate, `width` and `height`, and `state` of the button are passed as arguments
function newButton(type, x, y, width, height, states, callback, drawFunction)
    local button = {
        type = type,
        x = x, y = y,
        width = width,
        height = height,
        colour = defaultColour,
        states = states,
        stateIdx = 1,
        callback = callback,
        drawFunction = drawFunction,
        lastHeld = false,
    }
    table.insert(buttons, button)

    return button
end

function updateButtons()
    for _, button in pairs(buttons) do
        local mouseHeld = love.mouse.isDown(1)
        local xMouse, yMouse = love.mouse.getPosition()
        local inBounds = isPointInCircle(xMouse, yMouse,
            button.x + (button.type == "right" and button.width or button.type == "left" and 0),
            button.y + button.height / 2, button.height / 2) or
            isPointInRectangle(xMouse, yMouse, button.x, button.y, button.width, button.height)
        if inBounds and not mouseHeld then
            button.colour = hoverColour
            if button.lastHeld then
                button.callback()
                button.stateIdx = button.stateIdx % #button.states + 1
            end
        elseif inBounds and mouseHeld then
            love.mouse.setCursor()
            button.colour = activeColour
        else
            button.colour = defaultColour
        end

        button.lastHeld = mouseHeld
    end
end

function drawButtons()
    for _, button in pairs(buttons) do
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(button.colour)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        love.graphics.circle("fill",
            button.x + (button.type == "right" and button.width or button.type == "left" and 0),
            button.y + button.height / 2, button.height / 2)
        button.drawFunction(button.x, button.y, button.width, button.height, button.states[button.stateIdx])
        love.graphics.setColor(r, g, b, a)
    end
end

-- utils
function isPointInCircle(px, py, cx, cy, r)
    return (px - cx) ^ 2 + (py - cy) ^ 2 <= r ^ 2
end

function isPointInRectangle(px, py, x, y, width, height)
    return px >= x and px <= x + width and py >= y and py <= y + height
end
