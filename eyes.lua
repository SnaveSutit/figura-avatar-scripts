function clamp(v, min, max) return math.max(math.min(v, max), min) end
function newVector3(a) return {['x'] = a[1], ['y'] = a[2], ['z'] = a[3]} end
function newVector2(a) return {['x'] = a[1], ['y'] = a[2]} end
function vec2Add(a, b) return newVector2({a.x + b.x, a.y + b.y}) end
function vec2Sub(a, b) return newVector2({a.x - b.x, a.y - b.y}) end

-- How far away from the center point your eyes can drift (Measured in pixels)
local eye_movement_freedom = newVector2({0.8, 0.8})
-- How fast the eyes re-center. Smaller is faster. Should be less than 1 or you'll have issues.
local eye_centering_friction = 0.8
-- Set this to your model's eye(s) bone. if you have more than 1 eye, you can join them under a single bone
local eye_model = model.Player.Head.Hat.Eye
-- How often the eyes have a chance to look around randomly
local random_eye_look_time = 60

local timer = 0
local eye_pos = newVector3({0,0,0})
local eye_look_offset = newVector2({0,0})
local last_player_rot = newVector2(player.getRot())

function render(delta)
	timer = timer + delta

	if timer >= random_eye_look_time then
		local random = math.floor(math.random() * 50)
		if random == 0 then
			eye_look_offset.y = eye_movement_freedom.x * math.random() * 4
		elseif random == 1 then
			eye_look_offset.y = -eye_movement_freedom.x * math.random() * 4
		elseif random == 2 then
			eye_look_offset.x = eye_movement_freedom.y * math.random() * 4
		elseif random == 3 then
			eye_look_offset.x = -eye_movement_freedom.y * math.random() * 4
		elseif random == 4 then
			eye_look_offset.x = eye_movement_freedom.y * math.random() * 4
			eye_look_offset.y = eye_movement_freedom.x * math.random() * 4
		elseif random == 5 then
			eye_look_offset.x = -eye_movement_freedom.y * math.random() * 4
			eye_look_offset.y = -eye_movement_freedom.x * math.random() * 4
		elseif random == 6 then
			eye_look_offset.x = eye_movement_freedom.y * math.random() * 4
			eye_look_offset.y = -eye_movement_freedom.x * math.random() * 4
		elseif random == 7 then
			eye_look_offset.x = -eye_movement_freedom.y * math.random() * 4
			eye_look_offset.y = eye_movement_freedom.x * math.random() * 4
		else
			eye_look_offset.y = 0
			eye_look_offset.x = 0
		end

		timer = 0
	end

	eye_pos.x = eye_pos.x * eye_centering_friction
	eye_pos.y = eye_pos.y * eye_centering_friction

	local player_rot = newVector2(player.getRot())
	local diff = vec2Sub(player_rot, last_player_rot)
	last_player_rot = player_rot

	diff = vec2Add(diff, eye_look_offset)

	eye_pos.x = clamp(eye_pos.x - (diff.y / 20), -eye_movement_freedom.x, eye_movement_freedom.x)
	eye_pos.y = clamp(eye_pos.y + (diff.x / 20), -eye_movement_freedom.y, eye_movement_freedom.y)

	eye_model.setPos({
		eye_pos.x,
		eye_pos.y,
		eye_pos.z
	})
end
