if (debugmode) then return end -- make sure it doesn't call itself

debugmode = {}
fullsupport = false

misc_flag = 0

function debugmode.draw() 
	love.graphics.setColor(255, 255, 255) 
	love.graphics.print("Debug mode. dt="..delt,0,0)
	love.graphics.print("Player world coordinates: "..player.y..", "..player.x,0,20)
	love.graphics.print("Velocity "..player.y_velocity..":: "..player.x_velocity,0,40)
	if fullsupport then love.graphics.print("All graphics allowed",0,60) end
	if player.can_float then love.graphics.print("Player can use jetpack.",0,80) end

	if (misc_flag==1) then love.graphics.print("Flag trigger",100,0) end

	--invisible bounds
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("line", borderleft+player.iw/2-player.x+player.xoff, bordertop+player.ih/2-player.y+player.yoff, borderright-borderleft, borderbottom-bordertop)
end

function debugmode.keypressed(key)
	if key == "f2" then debugmode.checksupport() end
end

function debugmode.checksupport()
	assert(love.graphics.isSupported("canvas"),"no canvas support!")
	assert(love.graphics.isSupported("npot"),"no npot support!")
	assert(love.graphics.isSupported("subtractive"),"no subtractive support!")
	assert(love.graphics.isSupported("shader"),"no shader support!")
	assert(love.graphics.isSupported("hdrcanvas"),"no hdr support!")
	assert(love.graphics.isSupported("multicanvas"),"no multicanvas support!")
	assert(love.graphics.isSupported("mipmap"),"no mimap support!")
	assert(love.graphics.isSupported("dxt"),"no dxt support!")
	assert(love.graphics.isSupported("bc5"),"no bc5 support!")
	fullsupport = true
end                                                                                             