if (field) then return end -- make sure it doesn't call itself

field = {}

function field.load()
	gravity = -2000
	launch = 600
	terminal_velocity = -981
	winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
	
	player = {
		image = love.graphics.newImage("hamster.png"),

		iw = 82, ih = 82,
		x = 500, y = 100,
		x_gspeed = 800, x_aspeed = 800,
		y_velocity = -0.0000001, ground = "none",
		float = 0.5, float_max = 0.5, can_float = true, can_drop = false
	}
	
	
	rect = {
		{name = "floor",	xini = 0,			yini = winH-20,		width = winW,	height = 50},
		{name = "blockA",	xini = winW*5/9,	yini = winH*3/4,	width = winW/9,	height = 50},
		{name = "blockB",	xini = 0,			yini = winH*1/2,	width = winW/4,	height = 100}		
	}
	
	canvas = love.graphics.newCanvas(winW, winH)
	love.graphics.setCanvas(canvas)
        canvas:clear()
		love.graphics.setColor(0, 0, 255)
		for i = 1, #rect do
			love.graphics.rectangle("fill",rect[i].xini,rect[i].yini,rect[i].width,rect[i].height)
		end
	love.graphics.setCanvas()
	
end

function field.draw() 

	love.graphics.setColor(255, 255, 255) --reset colour
	love.graphics.draw(canvas, 0, 0)
	
	love.graphics.draw(player.image, player.x-player.iw/2, player.y-player.ih/2, 0, 1, 1, 0, player.ih/2)
	
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill",player.x+player.iw/2, player.y-player.ih, 3, 3) 
end

function field.update(dt)
	if love.keyboard.isDown("left") and player.y_velocity == 0 then player.x = player.x - player.x_gspeed*dt end
	if love.keyboard.isDown("left") and player.y_velocity ~= 0 then player.x = player.x - player.x_aspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity == 0 then player.x = player.x + player.x_gspeed*dt end
	if love.keyboard.isDown("right") and player.y_velocity ~= 0 then player.x = player.x + player.x_aspeed*dt end
	
	--check invisible side bounds
	if player.x < player.iw/2 then player.x = player.iw/2 end
	if player.x > winW-player.iw/2 then player.x = winW-player.iw/2 end
	
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
	
	-- collisions with solid platforms
	for i = 1, #rect do
		c = CheckCollision(i)

		if (c == [[left]]) then player.x = rect[i].xini - player.iw/2 end
		if (c == [[right]]) then player.x = rect[i].xini + rect[i].width + player.iw/2 end
	
		if (c == [[top]]) then
			player.y_velocity = 0
			player.y = rect[i].yini
			player.float = player.float_max
			player.can_float = true
			player.ground = rect[i].name
		end
		
		if (c == [[bottom]]) then
			player.y = rect[i].yini+rect[i].height+player.ih
			player.ground = ""
			player.y_velocity = -0.0000001
			player.can_float = false
		end
	
		--start falling if player moves off platform
		if (player.x < rect[i].xini or player.x > rect[i].xini + rect[i].width)
		   and player.ground == rect[i].name then
			player.ground = ""
			player.y_velocity = -0.0000001
			player.can_float = false
			player.can_drop = true
		end
		
	end

end

function field.keypressed(key)
	if key == "z" then
		if player.y_velocity == 0 then
			player.y_velocity = launch
			player.can_float = true
			player.ground = "none"
			player.can_drop = true
		end
	end
	if key == "x" then
		if player.y_velocity > 0 then
			player.y_velocity = -0.0000001
		elseif player.y_velocity < 0 and player.can_drop == true then
			player.y_velocity = player.y_velocity - 1000
			player.can_drop = false
		end
	end
end

function field.keyreleased(key)
	if key == "z" then player.can_float = false end
end

function CheckCollision(i)
	if player.y >= rect[i].yini and player.y <= rect[i].yini + rect[i].height
		and player.x > rect[i].xini and player.x < rect[i].xini + rect[i].width 
		and player.y_velocity < 0 then
			return [[top]]
	end
	if player.y-player.ih > rect[i].yini and player.y-player.ih <= rect[i].yini + rect[i].height
		and player.x > rect[i].xini and player.x < rect[i].xini + rect[i].width 
		and player.y_velocity > 0 then
			return [[bottom]]
	end
	if (player.x+player.iw/2 > rect[i].xini and player.x+player.iw/2 < rect[i].xini + rect[i].width)
	   and (
		 (player.y > rect[i].yini and player.y < rect[i].yini+rect[i].height)
		  or
		 (player.y-player.ih > rect[i].yini and player.y-player.ih < rect[i].yini+rect[i].height)
	   )  then
		   return [[left]]
	end
	if (player.x-player.iw/2 < rect[i].xini+rect[i].width
		and player.x-player.iw/2 > rect[i].xini--+rect[i].width-20
	   )
	   and (
		(player.y > rect[i].yini and player.y < rect[i].yini+rect[i].height)
		 or
		(player.y-player.ih > rect[i].yini and player.y-player.ih < rect[i].yini+rect[i].height)
	   ) then
			return [[right]]
	end
	return
end