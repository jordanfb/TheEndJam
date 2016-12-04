require "scoredisplay"
require "opening"
require "gameplay"

require "class"

Game = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Game:_init()
	-- these are for draw stacks:
	self.drawUnder = false
	self.updateUnder = false

	-- here are the actual variables
	self.drawFPS = false
	self.filename = "data.txt"

	self.canvas = love.graphics.newCanvas(1920, 1080)

	-- self.keyboard = Keyboard()


	-- self.countdownScreen = CountdownScreen(self)
	-- self.level = Level(self.keyboard, nil, self) -- we should have it load by filename or something.
	-- self.mainMenu = MainMenu(self)
	love.filesystem.setIdentity("At the End of the Day") -- so that it doesn't save to src.
	self.gameplay = Gameplay(self)
	self.opening = Opening(self)
	self.scoredisplay = Scoredisplay(self, self.filename)
	self.screenStack = {}
	
	-- self.bg = love.graphics.newImage('images/bg.png')
	
	-- bgm = love.audio.newSource("music/battlemusic.mp3")
	-- bgm:setVolume(0.9) -- 90% of ordinary volume
	-- bgm:setLooping( true )
	-- bgm:play()

	self:addToScreenStack(self.scoredisplay)
end

function Game:load(args)
	--
end

function Game:draw()

	-- love.graphics.draw(self.bg, 0, 0)
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	local thingsToDraw = 1 -- this will become the index of the lowest item to draw
	for i = #self.screenStack, 1, -1 do
		thingsToDraw = i
		if not self.screenStack[i].drawUnder then
			break
		end
	end
	-- this is so that the things earlier in the screen stack get drawn first, so that things like pause menus get drawn on top.
	for i = thingsToDraw, #self.screenStack, 1 do
		self.screenStack[i]:draw()
		-- if i ~= 1 then
		-- 	print("DRAWING "..i)
		-- end
	end
	if (self.drawFPS) then
		love.graphics.setColor(255, 0, 0)
		love.graphics.print("FPS: "..love.timer.getFPS(), 10, 1080-45)
		love.graphics.setColor(255, 255, 255)
	end

	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.canvas, 0, 0, 0, love.graphics.getWidth()/1920, love.graphics.getHeight()/1080)

end

function Game:update(dt)
	for i = #self.screenStack, 1, -1 do
		self.screenStack[i]:update(dt)
		if self.screenStack[i] and not self.screenStack[i].updateUnder then
			break
		end
	end
end

function Game:popScreenStack()
	if #self.screenStack > 0 then
		self.screenStack[#self.screenStack]:leave()
		self.screenStack[#self.screenStack] = nil
	end
	if #self.screenStack > 0 then
		self.screenStack[#self.screenStack]:load()
	end
end

function Game:addToScreenStack(newScreen)
	if self.screenStack[#self.screenStack] ~= nil then
		self.screenStack[#self.screenStack]:leave()
	end
	self.screenStack[#self.screenStack+1] = newScreen
	newScreen:load()
end

function Game:resize(w, h)
	for i = 1, #self.screenStack, 1 do
		self.screenStack[i]:resize(w, h)
	end
end

function Game:keypressed(key, unicode)
	if #self.screenStack > 0 then
		self.screenStack[#self.screenStack]:keypressed(key, unicode)
	end
	-- self.keyboard:keypressed(key, unicode)
end

function Game:keyreleased(key, unicode)
	if #self.screenStack > 0 then
		self.screenStack[#self.screenStack]:keyreleased(key, unicode)
	end
	-- self.keyboard:keyreleased(key, unicode)
end

function Game:mousepressed(x, y, button)
	if #self.screenStack > 0 then
		self.screenStack[#self.screenStack]:mousepressed(x, y, button)
	end
end

function Game:mousereleased(x, y, button)
	if #self.screenStack > 0 then
		self.screenStack[#self.screenStack]:mousereleased(x, y, button)
	end
end

function Game:quit()
	--
end