


require "exitmenu"
require "class"

Gameplay = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Gameplay:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.updatePlayer = true

	self.game = game

	self.x = 1920/2
	self.y = 0
	self.width = 100
	self.height = 150
	self.currentWidth = self.width
	self.currentHeight = self.height
	self.dx = 0
	self.dy = 0
	self.ay = 0
	self.ax = 0
	self.heightAnimationChange = 0
	self.animationHeightDy = 0
	self.topOffset = 0
	self.topOffsetDx = 0

	self.timeConstant = 50
	self.platformDistance = 300
	self.platformHeight = 30
	self.platformChange = 400
	self.platformWidth = 200

	self.friction = .8
	self.horizontalSpeed = 20
	self.horizontalAcceleration = 1.5

	self.gravity = 1
	self.jumpdy = 30

	self.screenOffset = 400 -- the distance from the bottom of the screen to the bottom of the player
	self.platforms = {1920/2}
end

function Gameplay:load()
	-- run when the level is given control
	-- while #self.platforms < 1080/self.platformDistance + 1 do
	-- 	-- make more platforms
	-- 	self:makeAnotherPlatform()
	-- end
end

function Gameplay:makeAnotherPlatform()
	self.platforms[#self.platforms+1] = math.max(self.platformWidth/2, math.min(1920-self.platformWidth/2, self.platforms[#self.platforms] + math.random(-self.platformChange, self.platformChange)))
end

function Gameplay:leave()
	-- run when the level no longer has control
end

function Gameplay:draw()
	--
	-- love.graphics.print(self.y, 0, 0)
	self:drawPlatforms()
	-- then draw player
	love.graphics.setColor(255, 255, 255)
	self.currentWidth = math.max(self.width+self.heightAnimationChange, 2)
	self.currentHeight = self.height-self.heightAnimationChange
	-- self.topOffset = -self.dx
	-- love.graphics.rectangle("fill", self.x-self.currentWidth/2, 1080 - self.screenOffset-self.heightAnimationChange*0, self.currentWidth, -self.currentHeight) -- negative self.height since math.
	love.graphics.polygon("fill", self.x-self.currentWidth/2, 1080 - self.screenOffset-self.heightAnimationChange*0, self.x+self.currentWidth/2, 1080 - self.screenOffset-self.heightAnimationChange*0, self.x+self.currentWidth/2-self.topOffset, 1080 - self.screenOffset-self.heightAnimationChange*0-self.currentHeight, self.x-self.currentWidth/2-self.topOffset, 1080 - self.screenOffset-self.heightAnimationChange*0-self.currentHeight) -- negative self.height since math.
	-- draw the instruction text
	love.graphics.setColor(255, 0, 0)
	love.graphics.printf("wasd esc", 0, 1080-self.screenOffset/2+self.y, 1920, "center")
end

function Gameplay:drawPlatforms()
	love.graphics.setColor(255, 0, 0)
	local platY = math.floor((self.y - self.screenOffset)/ self.platformDistance)
	for i = 0, 1080/self.platformDistance+1, 1 do
		-- draw the platform at that height?
		while #self.platforms < i + platY do
			self:makeAnotherPlatform()
		end
		if platY <= 0 and i == 0 then
			-- draw the flat line at the bottom
			-- love.graphics.line(0, 1080-self.screenOffset, 1920, 1080-self.screenOffset)
			love.graphics.rectangle("fill", 0, 1080-self.screenOffset+self.y, 1920, self.platformHeight)
		elseif i+platY > 0 then
			-- print(i+platY)
			-- print(self.platforms[i+platY]-10)
			love.graphics.rectangle("fill", self.platforms[i+platY]-self.platformWidth/2, 1080-self.screenOffset+self.y-(platY+i)*self.platformDistance, self.platformWidth, self.platformHeight)
		end
	end
end

function Gameplay:update(dt)
	--
	if self.updatePlayer then
		local xKeys = 0
		if love.keyboard.isDown("a") then
			xKeys = -1
		end
		if love.keyboard.isDown("d") then
			xKeys = xKeys + 1
		end
		self.ax = xKeys*self.horizontalAcceleration
		self.dx = self.dx + self.ax
		self.dx = math.max(-self.horizontalSpeed, math.min(self.horizontalSpeed, self.dx))
		if xKeys == 0 then
			self.dx = self.dx * self.friction
		end
		self.x = self.x + self.dx*dt*self.timeConstant
		if self.x < self.currentWidth/2 then
			self.x = self.currentWidth/2
			if self.dx < 0 then
				self.dx = 0
			end
		elseif self.x + self.currentWidth/2 > 1920 then
			self.x = 1920-self.currentWidth/2
			if self.dx > 0 then
				self.dx = 0
			end
		end
		-- finished X, now do Y!
		if self.y > 0 then
			-- ignore all collisions, just do gravity
			self.dy = self.dy - self.gravity
		end
		-- if self.dy == 0 and not self:isPlayerOnPlatform() then
		-- 	-- gravity still affects them!
		-- 	self.dy = self.dy - self.gravity
		-- end
		if self.dy < 0 then
			self:downwardCollision()
		end
		if self:isPlayerOnPlatform() and (love.keyboard.isDown("space") or love.keyboard.isDown("w")) then
			-- jump
			self.dy = self.jumpdy
		-- else
		-- 	self.ay = 0
		end
		self.dy = self.dy + self.ay
		self.y = self.y +self.dy * dt * self.timeConstant
		if self.y < 0 then
			self.y = 0
		end

		self.topOffsetDx = self.topOffsetDx + (self.dx-self.topOffset)/10
		self.topOffsetDx = self.topOffsetDx*.9
		self.topOffset = self.topOffset + self.topOffsetDx*dt*self.timeConstant

		self.animationHeightDy = self.animationHeightDy + (self.dy - self.heightAnimationChange)/10
		self.animationHeightDy = self.animationHeightDy*.9
		self.heightAnimationChange = self.heightAnimationChange + self.animationHeightDy*dt*self.timeConstant
	end
end

function Gameplay:downwardCollision()
	if math.floor(self.y/self.platformDistance) > math.floor((self.y+self.dy)/self.platformDistance) then
		-- it passed through a platform height, (or would) so check if it should collide
		-- local i = math.floor(self.y/self.platformDistance)
		local i = 0
		for i = math.floor(self.y/self.platformDistance), math.floor((self.y+self.dy)/self.platformDistance)+1, -1 do
			local collision = true
			if i <= 0 then
				self.y = 0
				self.dy = -self.dy/5*0
				collision = false
			elseif self.platforms[i]+self.platformWidth/2 < self.x - self.currentWidth/2 then
				-- it's wrong to the side
				collision = false
			elseif self.platforms[i]-self.platformWidth/2 > self.x + self.currentWidth/2 then
				collision = false
			end
			if collision then
				self.y = i*self.platformDistance
				self.dy = -self.dy/5*0
				return
			end
		end
	end
end

-- this is just for jumping, not for collisions
function Gameplay:isPlayerOnPlatform()
	-- if self.y == 0 then
	-- 	return true
	-- end
	-- otherwise we have to find some actual evidence.
	if self.y % self.platformDistance == 0 then
		-- then it's on a platform
		return true
	end
	return false
end


function Gameplay:resize(w, h)
	--
end

function Gameplay:keypressed(key, unicode)
	--
	if key == "n" and self.game.debug then
		self.y = 0
	end
	if key == "y" and self.game.debug then
		self.y = self.y + 1000
	end
	if key == "m" and self.game.debug then
		self.dy = -1000
	end
	if key == "escape" then
		self.game:addToScreenStack(Exitmenu(self.game, self.y/self.platformDistance))
	end
end

function Gameplay:keyreleased(key, unicode)
	--
end

function Gameplay:mousepressed(x, y, button)
	--
end

function Gameplay:mousereleased(x, y, button)
	--
end