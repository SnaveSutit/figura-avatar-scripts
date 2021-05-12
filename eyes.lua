-- [ Script built for Figura v0.0.05a ] --

--!| Eye Config |!--
-- This should be your model's eye(s) bone. if you have more than 1 eye, you can join them under a single bone
local eye_model = model.Player.Head.Hat.Eye
-- How fast the eye(s) will move towards their goal. (0 - 1) Default: 0.025
local eye_glance_speed = 0.025
-- The chance to glance when tryRandomGlance is ran. (0, 1) Default: 0.05
local eye_glance_chance = 0.05
-- How often to tryForGlance in ticks. Default: 40
local eye_glance_cooldown = 40
-- How much time to randomly add to the eye_glance_cooldown every time a successful glance is made.
-- This allows for more varied glance holding times. (Should be > eye_glance_cooldown) Default: 10
local eye_glance_cooldown_random_offset = 10
-- The higher this number the more often the eye(s) will glance left and right rather than up/down/diagonally. Larger numbers favor the x axis (0 - 1) Default: 0.5
local eye_glance_x_y_bias = 0.5
-- How far in x and y the eye(s) can travel before being stopped. ({0 - 1, 0 - 1}) Default: {0.9, 0.9}
local eye_freedom = vectors.of({0.9,0.9})
-- How fast the eye(s) return to their center. Smaller values are faster. (0 - 1) Default: {0.7, 0.7}
local eye_gravity = vectors.of({0.7,0.7})
--!| End Eye Config |!--

--| Math functions |--
function clamp(v, min, max) return math.max(math.min(v, max), min) end

--| Var INIT |--
local counter = 0

local eye_pos = eye_model.getPos()
local last_eye_pos = eye_pos
local eye_glance_diff = vectors.of({0,0,0})
local _eye_glance_cooldown = eye_glance_cooldown

local player_rot = player.getRot()
local last_player_rot = player_rot

function randomizeGlanceCooldown()
	_eye_glance_cooldown = eye_glance_cooldown + (eye_glance_cooldown_random_offset * (math.random() * 2 - 1))
end

function tryRandomGlance()
	if math.random() < eye_glance_chance then
		local random = math.random()
		if (random < eye_glance_x_y_bias) then
			eye_glance_diff = eye_freedom * vectors.of({math.random() * 2 - 1, math.random() * 0.5 - 0.25}) / eye_glance_speed
		else
			eye_glance_diff = eye_freedom * vectors.of({math.random() * 2 - 1, math.random() * 2 - 1}) / eye_glance_speed
		end
	else
		eye_glance_diff = vectors.of({0,0,0})
	end
	randomizeGlanceCooldown()
end

function tick()
	counter = counter + 1

	last_eye_pos = eye_pos
	last_player_rot = player_rot
	player_rot = player.getRot()

	if math.floor(counter % _eye_glance_cooldown) == 0 then
		tryRandomGlance()
	end

	local diff = (player_rot - last_player_rot)
	diff = diff + eye_glance_diff

	eye_pos = vectors.of({
		clamp(eye_pos.x - (diff.y * eye_glance_speed), -eye_freedom.x, eye_freedom.x),
		clamp(eye_pos.y + (diff.x * eye_glance_speed), -eye_freedom.y, eye_freedom.y)
	})

	eye_pos = vectors.of({
		eye_pos.x * eye_gravity.x,
		eye_pos.y * eye_gravity.y,
		eye_pos.z
	})
end

function render(delta)
	local lerp_pos = vectors.lerp(last_eye_pos, eye_pos, delta)
	eye_model.setPos(lerp_pos)
end









