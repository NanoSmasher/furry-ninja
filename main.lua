require "field"
--debugging matrix
require "debugmode"
debug_on = true

--variable to decide which screen to show.
screen = nil

function love.load()
	screen = "main menu"
	love.window.setMode(960,540)
	field.load()
end

function love.draw() 
	if debug_on then debugmode.draw()  end
	if screen == "game" then field.draw() end
	if screen == "main menu" then
		love.graphics.print("Hit space to start.", 400, 220)
		love.graphics.print("Move with arrow keys", 400, 240)
		love.graphics.print("z to jump", 400, 260)
		love.graphics.print("x to limit jump height/fast fall", 400, 280)
		end
end

function love.update(dt)
	if screen == "game" then field.update(dt) end
end

function love.keypressed(key)
	if debug_on then debugmode.keypressed(key) end
	if key == "f1" then debug_on = (not debug_on) end
	
	if key == " " and screen == "main menu" then screen = "game" end
	if screen == "game" then field.keypressed(key) end
end

function love.keyreleased(key)
	if key == "escape" then love.event.push("quit") end
	if screen == "game" then field.keyreleased(key) end
end