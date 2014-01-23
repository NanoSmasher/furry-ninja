if (field) then return end -- make sure it doesn't call itself

field = {}

function field.load()
	gravity = -2000
	launch = 600
	terminal_velocity = -981
	winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
	
	player = {
		image = love.graphics.newImage("hamster.png"),
		
		x = 500,
		y = 100,
		x_gspeed = 800,
		x_aspeed = 800,
		y_velocity = 0,
		ground = "none",
		
		float = 0.5,
		float_max = 0.5,
		can_float = true
		}
		
	rect = {
		{
		name = "floor",
		xini = 0,
		yini = winH-20,
		width = winW,
		height = 10
		},
		{
		name = "block",
		xini = 0,
		yini = winH*3/4,
		width = winW/4,
		height = 100
		}
	}
end

function field.draw() 

	if yep then love.graphics.print("Boop",700,200) end

	love.graphics.setColor(0, 0, 255)
	for i = 1, #rect do
		love.graphics.rectangle("fill",rect[i].xini,rect[i].yini,rect[i].width,rect[i].height)
	end
	
	love.graphics.setColor(255, 255, 255) --reset colour
	love.graphics.draw(player.image, player.x-player.image:getWidth()/2, player.y-player.image:getHeight()/2, 0, 1, 1, player.image:getWidth()/2, player.image:getHeight()/2)
	love.graphics.rectangle("fill",player.x-1, player.y-1, 3,3)
	love.graphics.rectangle("fill", rect[2].xini + rect[2].width,rect[2].yini,1,1)
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
	
	if player.y >= rect[2].yini and player.y <= rect[2].yini + 20 and player.y_velocity < 0 and player.x < rect[2].xini + rect[2].width then
		player.y_velocity = 0
		player.y = rect[2].yini
		player.float = player.float_max
		player.can_float = true
		player.ground = rect[2].name
	end
	
	if player.x > rect[2].xini + rect[2].width and player.ground == rect[2].name then
		player.ground = ""
		player.y_velocity = -0.0000001
	end
	
	if player.y >= rect[1].yini and player.y_velocity < 0 then
		player.y_velocity = 0
		player.y = rect[1].yini
		player.float = player.float_max
		player.can_float = true
		player.ground = rect[1].name
	end
	
	--scrolling mechanics
	if player.x < player.image:getWidth()/2 then player.x = player.image:getWidth()/2 end
	if player.x > winW-player.image:getWidth()/2 then player.x = winW-player.image:getWidth()/2 end
	if love.keyboard.isDown("left") and player.y_velocity == 0 then player.x = player.x - player.x_gspeed*dt end
	if love.keyboard.isDown("left") and player.y_velocity ~= 0 then player.x = player.x - player.x_aspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity == 0 then player.x = player.x + player.x_gspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity ~= 0 then player.x = player.x + player.x_aspeed*dt end
end

function field.keypressed(key)
	if key == " " then
		if player.y_velocity == 0 then
			player.y_velocity = launch
			player.can_float = true
			player.ground = "none"
		end
	end
end

function field.keyreleased(key)
	if key == " " then player.can_float = false end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end