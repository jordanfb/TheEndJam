



require "class"

Scoredisplay = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Scoredisplay:_init(game, filename)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.game = game
	self.filename = filename
	self.finished = false -- if they have a score
	self:checkScore()
end

function Scoredisplay:checkScore()
	if love.filesystem.exists(self.filename) then
		-- check the file, it holds the score.
		local text = love.filesystem.read(self.filename)
		self.score = text
		self.finished = true
	else
		self.score = 0
		self.finished = false
	end
	local file, errormessage = io.open(self.filename, "r")
	-- if file ~= nil then
	-- 	-- then it's an actual file!
	-- 	for line in io.lines(self.filename) do
	-- 		if line == "Jordan Faas-Bush" then
	-- 			-- there's no score yet
	-- 			self.finished = false
	-- 			file:close()
	-- 			return
	-- 		else
	-- 			-- there's a score, display it!
	-- 			self.score = line
	-- 			self.finished = true
	-- 			file:close()
	-- 			return
	-- 		end
	-- 	end
	-- else
	-- 	error("ERROR: unable to open file: "..errormessage)
	-- end
end

function Scoredisplay:load()
	-- run when the level is given control
	if not self.finished or love.keyboard.isDown("f1") then
		self.game:popScreenStack()
		self.game:addToScreenStack(self.game.opening)
	end
	love.graphics.setFont(love.graphics.newFont(36))
end

function Scoredisplay:leave()
	-- run when the level no longer has control
end

function Scoredisplay:draw()
	if self.finished then
		-- draw the score
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf("Your score is:", 0, 1080/6, 1920, "center")
		love.graphics.printf(self.score, 0, 1080/3, 1920, "center")
	end
end

function Scoredisplay:update(dt)
	--
end

function Scoredisplay:resize(w, h)
	--
end

function Scoredisplay:keypressed(key, unicode)
	--
	if key == "p" and self.game.debug then
		-- self.game:popScreenStack()
		-- self.game:addToScreenStack(self.game.opening)
		-- local file = io.open(self.filename, "w")
		-- file:write("Jordan Faas-Bush")
		-- file:close()
		love.filesystem.remove(self.filename)
		love.event.quit()
	elseif self.finished then
		love.event.quit()
	end
end

function Scoredisplay:keyreleased(key, unicode)
	--
end

function Scoredisplay:mousepressed(x, y, button)
	if self.finished then
		love.event.quit()
	end
end

function Scoredisplay:mousereleased(x, y, button)
	--
end