-- [ Script built for Figura v0.0.05a ] --

local walk_animation_container = {}

--| Math functions |--
function clamp(v, min, max) return math.max(math.min(v, max), min) end

walk_animation_container.vars = {}

walk_animation_container.vars.counter = 0

walk_animation_container.vars.player_pos = player.getPos()
walk_animation_container.vars.last_player_pos = walk_animation_container.vars.player_pos
walk_animation_container.vars.player_velocity = vectors.of({0,0,0})

walk_animation_container.legs = {}

walk_animation_container.legs.left_leg = {}
walk_animation_container.legs.left_leg.pos = vectors.of({0,0,0})
walk_animation_container.legs.left_leg.last_pos = vectors.of({0,0,0})

walk_animation_container.legs.right_leg = {}
walk_animation_container.legs.right_leg.pos = vectors.of({0,0,0})
walk_animation_container.legs.right_leg.last_pos = vectors.of({0,0,0})


--!| Walk Animation Config |!--
walk_animation_container.vars.walk_animation_speed = 0.9

walk_animation_container.legs.left_leg.bones = {
	model.Player.Legs.LeftLeg,
	model.Player.Feet.LeftFoot
}

walk_animation_container.legs.right_leg.bones = {
	model.Player.Legs.RightLeg,
	model.Player.Feet.RightFoot
}

--!| End Walk Animation Config |!--

function walkAnimation()

	for k,_ in pairs(walk_animation_container.legs) do
		walk_animation_container.legs[k].last_pos = walk_animation_container.legs[k].pos
	end

	if (not (walk_animation_container.vars.player_velocity.x == 0)) and (not (walk_animation_container.vars.player_velocity.z == 0)) then
		local vel = vectors.of({
			walk_animation_container.vars.player_velocity.x,
			walk_animation_container.vars.player_velocity.z
		})
		local mul = vel.getLength()

		walk_animation_container.legs.left_leg.pos = vectors.of({
			0,
			clamp(math.sin(walk_animation_container.vars.counter * walk_animation_container.vars.walk_animation_speed) * 3 - 1, -2, 1),
			-math.cos(walk_animation_container.vars.counter * walk_animation_container.vars.walk_animation_speed) * (20 * mul),
		})

		walk_animation_container.legs.right_leg.pos = vectors.of({
			0,
			clamp(-math.sin(walk_animation_container.vars.counter * walk_animation_container.vars.walk_animation_speed) * 3 - 2, -2, 0),
			math.cos(walk_animation_container.vars.counter * walk_animation_container.vars.walk_animation_speed) * (20 * mul)
		})

	else
		for k,_ in pairs(walk_animation_container.legs) do
			walk_animation_container.legs[k].pos = vectors.of({0,0,0})
		end
	end
end

function tick()
	walk_animation_container.vars.counter = walk_animation_container.vars.counter + 1

	walk_animation_container.vars.last_player_pos = walk_animation_container.vars.player_pos
	walk_animation_container.vars.player_pos = player.getPos()
	walk_animation_container.vars.player_velocity = walk_animation_container.vars.last_player_pos - walk_animation_container.vars.player_pos

	walkAnimation()

end

function render(delta)

	for k, v in pairs(walk_animation_container.legs) do
		local lerp_pos = vectors.lerp(
			walk_animation_container.legs[k].last_pos,
			walk_animation_container.legs[k].pos,
			delta
		)
		for _,bone in ipairs(walk_animation_container.legs[k].bones) do
			bone.setPos(lerp_pos)
		end
	end
end

