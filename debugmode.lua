if (debugmode) then return end -- make sure it doesn't call itself

debugmode = {}
fullsupport = false

function debugmode.draw() 
	love.graphics.setColor(255, 255, 255) 
	love.graphics.print("Debug mode",0,0)
	if fullsupport then love.graphics.print("All graphics allowed",0,20) end
end

function debugmode.keypressed(key)
	if key == "c" then debugmode.checksupport() end
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