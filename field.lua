if (field) then return end -- make sure it doesn't call itself

field = {}

function field.load()
	
	--global variables
	gravity = 2000
	launch = 600
	terminal_velocity = -981
	winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
	
	player = {
		image = love.graphics.newImage("hamster.png"),
		
		x = 0,
		y = 0,
		x_gspeed = 800,
		x_aspeed = 800,
		y_velocity = 0,
		
		float = 0.5,
		float_max = 0.5,
		is_float = true
		}
end

function field.draw() 

	-- create a blue winW x winH rectangle sitting on the middle bottom of the screen (the top of the rectangle is touching the edge, rest is hidden)
	--love.graphics.setColor(0, 0, 255)
	--love.graphics.rectangle("fill", 0, winH*3/4, winW, winH/4) -- the first two vars are the axis postisions (from top left), the other two are width
	love.graphics.translate(winW / 2,winH*3/4) -- chance x,y coordinates by that amount.
	love.graphics.setColor(255, 255, 255) --reset color
	
	-- draw player, offset its orgin and do a vertical flip.
	love.graphics.draw(player.image, player.x, -player.y,0,1,1,winW/2+20,-20)
	
end


function field.update(dt)

	--jumping mechanics
	if player.y_velocity ~= 0 then -- remember, ~= is not equal to.
		
		--float mechanics
		if player.is_float and player.float > 0 then
			player.float = player.float - dt
			player.y_velocity = player.y_velocity + launch * (dt/player.float_max) --increase the velocity by nothing to launch (twice the distance)
		end
	
		player.y = player.y + player.y_velocity*dt
		player.y_velocity = player.y_velocity - gravity * dt
	elseif player.y_velocity <= terminal_velocity then
		player.y_velocity = terminal_velocity
	end
	if player.y <= 0 then
		player.y_velocity = 0
		player.y = 0
		player.float = player.float_max
		player.is_float = true
	end
	
	--scrolling mechanics
	if player.x < 0 then player.x = 0 end
	if player.x > winW-148 then player.x = winW-148 end
	if love.keyboard.isDown("left") and player.y_velocity == 0 then player.x = player.x - player.x_gspeed*dt end
	if love.keyboard.isDown("left") and player.y_velocity ~= 0 then player.x = player.x - player.x_aspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity == 0 then player.x = player.x + player.x_gspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity ~= 0 then player.x = player.x + player.x_aspeed*dt end
end

function field.keypressed(key)
	if key == " " then
		if player.y >= 0 and player.y <= 15 then
			player.y_velocity = launch
		end
	end
end

function field.keyreleased(key)
	
	if key == " " then player.is_float = false end
end