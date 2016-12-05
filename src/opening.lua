



require "class"

Opening = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Opening:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.game = game

	local e = {255, 0, 0, 255}
	local o = {255, 255, 255, 255}
	self.quotes = {
			{o, "Begin with ", e, "the end", o, " in mind"},
			{e, "The end", o, " justifies the means."},
			{o, "Only the dead have seen ", e, "the end", o, " of the war."},
			{e, "The end", o, " of laughter and soft lies"},
			{o, "And in ", e, "the end,", o, " the love you take is equal to the love you make"},
			{o, "Hard work always wins in ", e, "the end."},
			{o, "It's ", e, "the end", o, " of the world, as we know it"},
			{o, "Democracy and socialism are means to an end, not ", e, "the end", o, " itself."},
			{o, "A search for ", e, "the end", o, " a dread of ", e, "the end", o, " the obverse and the reverse of the same act."},
			{o, "One approaches the journey's end. But ", e, "the end", o, " is a goal, not a catastrophe."},
			{o, "From ", e, "the end,", o, " springs new beginnings"},
			{o, "", e, "The end", o, " of art is peace."},
			{o, "The traveller has reached ", e, "the end", o, " of the journey!"},
			{e, "The end", o, " of a picture is always an end of a life."},
			{o, "I believe that in ", e, "the end", o, " the truth will conquer."},
			{o, "waiting for ", e, "the end", o, " boys, waiting for ", e, "the end."},
			{o, "I tried so hard, and got so far, but in ", e, "the end", o, " it doesn't even matter"},
			{o, "But it all comes back to me in ", e, "the end"},
			{o, "Injustice in ", e, "the end", o, " produces independence."},
			{o, "Ultimately in ", e, "the end,", o, " it's the director's choice."},
			{o, "Cadillacs are down at ", e, "the end", o, " of the bat."},
			{e, "The ends", o, " must justify the means."},
			{e, "The end", o, " is in the beginning and lies far ahead."},
			{o, "In ", e, "the end", o, " I'm the only one who knows me."},
			{o, "What we call the beginning is often ", e, "the end.", o, " And to make an end is to make a beginning. ", e, "The end", o, " is where we start from."},
			{e, "The end", o, " crowneth the work."},
			{o, "In ", e, "the end", o, " of course, Republicans ended slavery and permanently outlawed it through the Thirteenth Amendment."},
			{o, "Now this is not ", e, "the end.", o, " It is not even the beginning of ", e, "the end.", o, " But it is, perhaps, ", e, "the end", o, " of the beginning"},
			{o, "In ", e, "the end", o, " only kindess matters"},
			{o, "Senators, in ", e, "the end,", o, " must be elected."},
			{o, "Urban neighborhoods and ", e, "the end", o, " of progress towards racial equality"},
			{o, "And in ", e, "the end", o, " it's not the years in your life that count. It's the life in your years."},
			{o, "We're s- so very small, in ", e, "the end."},
			{o, "I'm nearing ", e, "the end", o, " of the road and still learning."},
			{o, "I want to play until ", e, "the end"},
			{o, "It's not ", e, "the end", o, " of the world to lose."},
			{o, "Logic is the beginning of wisdom, not ", e, "the end."},
			{o, "Wisdom begins at ", e, "the end", o, ""},
			{o, "It is ", e, "the end.", o, " But of what? ", e, " The end", o, " of France? No. ", e, "The end", o, "of kings? Yes."},
			{o, "Proud meaning that... proud means that we have to be one till ", e, "the end", o, " eh? Til ", e, "the end", o, " we have to be proud."},
			{o, "The beginning and ", e, "the end"},
			{o, "That friendship will not continue to ", e, "the end", o, " which is begun for an end."},
			{o, "It was the true meaning of a road trip, by ", e, "the end", o, " of the trip we were all really exhausted."},
			{o, "In ", e, "the end,", o, " crime doesn't pay."},
			{o, "at ", e, "the end", o, " of the day"},
		}
	self.updatespeed = 1
	self.speedChange = 2
	self.currentText = 1
	self.time = 0
	self.timeUntilClose = 5
end

function Opening:load()
	-- run when the level is given control
	love.graphics.setFont(love.graphics.newFont(36))
end

function Opening:leave()
	-- run when the level no longer has control
end

function Opening:draw()
	love.graphics.printf(self.quotes[self.currentText], 0, 1080/2, 1920, "center")
end

function Opening:update(dt)
	self.time = self.time + dt
	if self.time > self.updatespeed then
		self.time = self.time - self.updatespeed
		if self.currentText < #self.quotes then
			self.currentText = self.currentText + 1
			self.updatespeed = math.max(.1, self.updatespeed * 6/7)
		end
	end
	if self.currentText >= #self.quotes then
		-- then wait until it's time to close and go to the game
		self.timeUntilClose = self.timeUntilClose - dt
		if self.timeUntilClose <= 0 then
			-- then close yourself!
			self.game:popScreenStack()
			self.game:addToScreenStack(self.game.gameplay)
		end
	end
end

function Opening:resize(w, h)
	--
end

function Opening:keypressed(key, unicode)
	--
	if key == "j" and self.game.debug then
		self.game:popScreenStack()
		self.game:addToScreenStack(self.game.gameplay)
	end
end

function Opening:keyreleased(key, unicode)
	--
end

function Opening:mousepressed(x, y, button)
	--
end

function Opening:mousereleased(x, y, button)
	--
end