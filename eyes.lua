-- [ Script built for Figura v0.0.05a ] --

local eye_script = {
	vars = {},
	settings = {},
	functions = {}
}

--!| Eye Config |!--
-- This should be your model's eye(s) bone. if you have more than 1 eye, you can join them under a single bone
eye_script.settings.model = model.eye
-- How fast the eye(s) will move towards their goal. (0 - 1) Default: 0.025
eye_script.settings.glance_speed = 0.025
-- The chance to glance when tryRandomGlance is ran. (0, 1) Default: 0.05
eye_script.settings.glance_chance = 0.05
-- How often to tryForGlance in ticks. Default: 40
eye_script.settings.glance_cooldown = 40
-- How much time to randomly add to the eye_glance_cooldown every time a successful glance is made.
-- This allows for more varied glance holding times. (Should be > eye_glance_cooldown) Default: 10
eye_script.settings.glance_cooldown_random_offset = 10
-- The higher this number the more often the eye(s) will glance left and right rather than up/down/diagonally. Larger numbers favor the x axis (0 - 1) Default: 0.5
eye_script.settings.glance_x_y_bias = 0.5
-- How far in x and y the eye(s) can travel before being stopped. ({0 - 1, 0 - 1}) Default: {0.9, 0.9}
eye_script.settings.eye_freedom = vectors.of({0.9,0.9})
-- How fast the eye(s) return to their center. Smaller values are faster. (0 - 1) Default: {0.7, 0.7}
eye_script.settings.eye_gravity = vectors.of({0.7,0.7})
--!| End Eye Config |!--

--| Math functions |--
eye_script.functions.clamp = function(v, min, max) return math.max(math.min(v, max), min) end

--| Var INIT |--
eye_script.vars.counter = 0

eye_script.vars.eye_pos = eye_script.settings.model.getPos()
eye_script.vars.last_eye_pos = eye_script.vars.eye_pos
eye_script.vars.glance_diff = vectors.of({0,0,0})
eye_script.vars.glance_cooldown = eye_script.settings.glance_cooldown

eye_script.vars.player_rot = player.getRot()
eye_script.vars.last_player_rot = eye_script.vars.player_rot

eye_script.functions.randomizeGlanceCooldown = function()
	eye_script.vars.glance_cooldown = eye_script.settings.glance_cooldown + (eye_script.settings.glance_cooldown_random_offset * (math.random() * 2 - 1))
end

eye_script.functions.tryRandomGlance = function()
	if math.random() < eye_script.settings.glance_chance then
		local random = math.random()
		if (random < eye_script.settings.glance_x_y_bias) then
			eye_script.vars.glance_diff = eye_script.settings.eye_freedom * vectors.of({math.random() * 2 - 1, math.random() * 0.5 - 0.25}) / eye_script.settings.glance_speed
		else
			eye_script.vars.glance_diff = eye_script.settings.eye_freedom * vectors.of({math.random() * 2 - 1, math.random() * 2 - 1}) / eye_script.settings.glance_speed
		end
	else
		eye_script.vars.glance_diff = vectors.of({0,0,0})
	end
	eye_script.functions.randomizeGlanceCooldown()
end

function tick()
	eye_script.vars.counter = eye_script.vars.counter + 1

	eye_script.vars.last_eye_pos = eye_script.vars.eye_pos
	eye_script.vars.last_player_rot = eye_script.vars.player_rot
	eye_script.vars.player_rot = player.getRot()

	if math.floor(eye_script.vars.counter % eye_script.vars.glance_cooldown) == 0 then
		eye_script.functions.tryRandomGlance()
	end

	local diff = (eye_script.vars.player_rot - eye_script.vars.last_player_rot)
	diff = diff + eye_script.vars.glance_diff

	eye_script.vars.eye_pos = vectors.of({
		eye_script.functions.clamp(eye_script.vars.eye_pos.x - (diff.y * eye_script.settings.glance_speed), -eye_script.settings.eye_freedom.x, eye_script.settings.eye_freedom.x),
		eye_script.functions.clamp(eye_script.vars.eye_pos.y + (diff.x * eye_script.settings.glance_speed), -eye_script.settings.eye_freedom.y, eye_script.settings.eye_freedom.y)
	})

	eye_script.vars.eye_pos = vectors.of({
		eye_script.vars.eye_pos.x * eye_script.settings.eye_gravity.x,
		eye_script.vars.eye_pos.y * eye_script.settings.eye_gravity.y,
		eye_script.vars.eye_pos.z
	})
end

function render(delta)
	local lerp_pos = vectors.lerp(eye_script.vars.last_eye_pos, eye_script.vars.eye_pos, delta)
	eye_script.settings.model.setPos(lerp_pos)
end
