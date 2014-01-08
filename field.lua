if (field) then return end -- make sure it doesn't call itself

field = {}

function field.load()
	gravity = -2000
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
		can_float = true
		}
end

function field.draw() 

	love.graphics.setColor(255, 255, 255) --reset colour
	love.graphics.draw(player.image, player.x+winW/2-player.image:getWidth()/2, player.y+winH-player.image:getHeight()/2, 0, 1, 1, player.imgW,player.image:getHeight()/2)
end

function field.update(dt)

	--jumping mechanics
	if player.y_velocity ~= 0 then
	
		--float mechanics
		if player.can_float and player.float > 0 then
			player.float = player.float - dt
			player.y_velocity = player.y_velocity + launch * (dt/player.float_max) --increase the velocity by nothing to launch (twice the distance)
			if player.float <= 0 then player.can_float = false end
		end
	
		player.y = player.y - player.y_velocity*dt
		player.y_velocity = player.y_velocity + gravity * dt
	elseif player.y_velocity <= terminal_velocity then
		player.y_velocity = terminal_velocity
	end
	if player.y >= 0 then
		player.y_velocity = 0
		player.y = 0
		player.float = player.float_max
		player.can_float = true
	end
	
	--scrolling mechanics
	if player.x < player.image:getWidth()/2-winW/2 then player.x = player.image:getWidth()/2-winW/2 end
	if player.x > winW/2-player.image:getWidth()/2 then player.x = winW/2-player.image:getWidth()/2 end
	if love.keyboard.isDown("left") and player.y_velocity == 0 then player.x = player.x - player.x_gspeed*dt end
	if love.keyboard.isDown("left") and player.y_velocity ~= 0 then player.x = player.x - player.x_aspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity == 0 then player.x = player.x + player.x_gspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity ~= 0 then player.x = player.x + player.x_aspeed*dt end
end

function field.keypressed(key)
	if key == " " then
		if player.y >= -15 then
			player.y_velocity = launch
			player.can_float = true
		end
	end
end

function field.keyreleased(key)
	if key == " " then player.can_float = false end
end