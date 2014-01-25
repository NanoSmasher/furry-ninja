if (field) then return end -- make sure it doesn't call itself

field = {}

check = false

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
		y_velocity = 0, ground = "none",
		float = 0.5, float_max = 0.5, can_float = true
	}
	
	
	rect = {
		{name = "floor",	xini = 0,			yini = winH-20,		width = winW,	height = 10},
		{name = "blockA",	xini = winW*8/9,	yini = winH*3/4,	width = winW/9,	height = 50},
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
	
	if check then love.graphics.print("Yep", 500,500) end
end

function field.update(dt)

	--check invisible bounds
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
	
	for i = 1, #rect do
		--collision from the top
		if player.y >= rect[i].yini and player.y <= rect[i].yini + 20
		   and player.x > rect[i].xini and player.x < rect[i].xini + rect[i].width 
		   and player.y_velocity < 0 then
			player.y_velocity = 0
			player.y = rect[i].yini
			player.float = player.float_max
			player.can_float = true
			player.ground = rect[i].name
		end
	
		--start falling if player moves off platform
		if (player.x < rect[i].xini or player.x > rect[i].xini + rect[i].width)
		   and player.ground == rect[i].name then
			player.ground = ""
			player.y_velocity = -0.0000001
			player.can_float = false
		end
		
		--collision from the left
		if (player.x+player.iw/2 > rect[i].xini and player.x+player.iw/2 < rect[i].xini + 20)
		   and (
		    (player.y > rect[i].yini and player.y < rect[i].yini+rect[i].height)
			 or
			(player.y-player.ih > rect[i].yini and player.y-player.ih < rect[i].yini+rect[i].height)
		   ) then
					player.x = rect[i].xini - player.iw/2
		end
		
		--collision from the right
		if (player.x-player.iw/2 < rect[i].xini+rect[i].width
			and player.x-player.iw/2 > rect[i].xini+rect[i].width-20
		   )
		   and (
		    (player.y > rect[i].yini and player.y < rect[i].yini+rect[i].height)
			 or
			(player.y-player.ih > rect[i].yini and player.y-player.ih < rect[i].yini+rect[i].height)
		   ) then
					player.x = rect[i].xini + rect[i].width + player.iw/2
		end
		
		
		--(player.x+player.iw/2 > rect[i].xini and player.x+player.iw/2 < rect[i].xini + 20)
		--(player.y >= rect[i].yini and player.y <= rect[i].yini+rect[i].height)
		--(player.y-player.ih >= rect[i].yini and player.y-player.ih <= rect[i].yini+rect[i].height)
		
--		(player.y >= rect[i].yini and player.y <= rect[i].yini+rect[i].height)
	--		or
		--	(player.y-player.ih >= rect[i].yini and player.y-player.ih <= rect[i].yini+rect[i].height)
		
		--and
		--((player.y >= rect[i].yini and player.y <= rect[i].yini+rect[1].height)
		--or (player.y+player.ih >= rect[i].yini and player.y+player.ih <= rect[i].yini+rect[1].height)) then
		--player.x = rect[i].xini - player.iw
	end
	
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