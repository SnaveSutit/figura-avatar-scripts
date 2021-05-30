
math.clamp = function(v, min, max) return math.max(math.min(v, max), min) end

util = {
	__version=1,
	__vars = {
		c = 0,
		pv = vectors.of{0,0,0},
		pp = player.getPos(),
		lpp = player.getPos()
	},
	__functions = {}
}
util.__functions.updatePlayerVelocity = function()
	util.__vars.lpp = util.__vars.pp
	util.__vars.pp = player.getPos()
	util.__vars.pv = util.__vars.lpp - util.__vars.pp
end

-- Runs a function with every key value pair of a table
util.forEachPair = function(t, func)
	for k,v in pairs(t) do
		func(k,v)
	end
end

-- Prints out every key a table has
util.dir = function(t) util.forEachPair(t, log) end

-- Returns the player's current velocity
util.getPlayerVelocity = function() return util.__vars.pv end
util.getPlayerSpeed = function() return util.__vars.pv.getLength() end

-- Returns the tick count since the beginning of the script's execution
util.time = function(n) return util.__vars.c / (n or 1) end
-- Returns a wave with length x and height y
util.wave = function(x, y) return math.sin(util.time(x)) * (y or 1) end
-- Returns a random number scaled by n
util.random = function(n) return math.random() * (n or 1) end

function tick()
	util.__vars.c = util.__vars.c + 1
	util.__functions.updatePlayerVelocity()
end
