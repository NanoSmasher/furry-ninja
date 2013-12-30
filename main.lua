require "field"
--debugging matrix
debug_on = true
debugmode_noinit = true
if debug_on then require "debugmode" debugmode_init = false end

--variable to decide which screen to show.
screen = nil

function love.load()
	screen = "main menu"
end

function love.draw() 
	if debug_on then debugmode.draw()  end
	if screen == "game" then field.draw() end
	if screen == "main menu" then love.graphics.print("Hit spacebar to start." .. " Move with arrow keys and spacebar", 200, 300) end
end

function love.update(dt)
	if screen == "game" then field.update(dt) end
end

function love.keypressed(key)
	if debug_on then debugmode.keypressed(key) end
	if (key == "f1") and (not debug_on) then
		debug_on = true
		if debugmode_noinit then
			require "debugmode"
			debugmode_init = false
		end
	elseif key == "f1" and debug_on then debug_on=false
	end
	
	if key == " " and screen == "main menu" then
		screen = "game"
		field.load()
	end
	if screen == "game" then field.keypressed(key) end
end

function love.keyreleased(key)
	if key == "escape" then love.event.push("quit") end
	if screen == "game" then field.keyreleased(key) end
end