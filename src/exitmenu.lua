

require "button"

require "class"

Exitmenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Exitmenu:_init(game, score)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.game = game
	self.filename = self.game.filename
	self.score = math.floor(score)*100
	self.yes = Button(1920/9*3, 1080/2, 1920/9, 1080/9, "Yes")
	self.no = Button(1920/9*5, 1080/2, 1920/9, 1080/9, "No")
end

function Exitmenu:load()
	-- run when the level is given control
	love.mouse.setRelativeMode(true)
	love.mouse.setRelativeMode(false)
	love.mouse.setVisible(true)
end

function Exitmenu:leave()
	-- run when the level no longer has control
	love.mouse.setVisible(false)
end

function Exitmenu:draw()
	--
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("Score:", 0, 1080/8, 1920, "center")
	love.graphics.printf(self.score, 0, 1080*2/8, 1920, "center")
	love.graphics.printf("Are you satisfied with your score?", 0, 1080*3/8, 1920, "center")
	self.yes:draw()
	self.no:draw()
end

function Exitmenu:update(dt)
	--
end

function Exitmenu:resize(w, h)
	--
end

function Exitmenu:keypressed(key, unicode)
	if key == "escape" then
		self.game:popScreenStack()
	end
end

function Exitmenu:keyreleased(key, unicode)
	--
end

function Exitmenu:mousepressed(x, y, button)
	--
end

function Exitmenu:mousereleased(x, y, button)
	--
	if self.yes:mousepressed(x, y, button) then
		-- they're happy with it, so set it in stone
		-- local file = io.open(self.filename, "w")
		-- file:write(self.score)
		-- file:close()
		
		love.filesystem.write(self.filename, self.score)
		love.event.quit()
	end
	if self.no:mousepressed(x, y, button) then
		self.game:popScreenStack()
	end
end