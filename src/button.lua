

require "class"

Button = class()


function Button:_init(x, y, width, height, text)
	self.height = height
	self.width = width
	self.x = x
	self.y = y
	self.text = text
end

function Button:draw()
	if self:mouseOver() then
		love.graphics.setColor(255, 0, 0)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.printf(self.text, self.x, self.y+self.height/2-18, self.width, "center")
end

function Button:mouseOver()
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
	return self:mousepressed(mx, my, 1)
end

function Button:mousepressed(mx, my, button)
	mx = mx / love.graphics.getWidth() * 1920
	my = my / love.graphics.getHeight() * 1080
	if mx < self.x or mx > self.x + self.width then
		return false
	elseif my < self.y or my > self.y + self.height then
		return false
	end
	return true
end

