require "field"
--debugging matrix
require "debugmode"
debug_on = true

--variable to decide which screen to show.
screen = nil

function love.load()
	delt = 0
	screen = "main menu"
	love.window.setMode(960,540)
	love.window.setTitle("Furry Ninja")
	field.load()
end

function love.draw() 
	if screen == "game" then field.draw() end
	if screen == "main menu" then
		love.graphics.setColor(255, 255, 255) 
		love.graphics.print("Hit space to start.", 400, 220)
		love.graphics.print("Move with arrow keys", 400, 240)
		love.graphics.print("c to jump", 400, 260)
		love.graphics.print("x to limit jump height/fast fall", 400, 280)
		love.graphics.print("z for instant fast fall", 400, 300)
		end
	if debug_on then debugmode.draw()  end
end

function love.update(dt)
	delt = dt
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