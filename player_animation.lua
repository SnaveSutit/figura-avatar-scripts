
math.clamp = function(v, min, max) return math.max(math.min(v, max), min) end

local util = {}
util.forEachPair = function(t, func)
	for k,v in pairs(t) do
		func(k,v)
	end
end

local walk_anim = {
	vars = {},
	bones = {},
	settings = {},
	functions = {}
}

walk_anim.vars.counter = 0
walk_anim.vars.frame = 0

walk_anim.vars.player_pos = player.getPos()
walk_anim.vars.last_player_pos = vectors.of({0,0,0})
walk_anim.vars.player_velocity = vectors.of({0,0,0})

walk_anim.functions.getBreathingOffset = function ()
	return vectors.of({0,math.cos(walk_anim.vars.counter / 16) * 0.25,0})
end

walk_anim.bones = {
	head = {},
	body = {},
	arms = {},
	lowerarms = {},
	handitems = {},
	legs = {},
	shins = {},
	feet = {},
}

walk_anim.bones.head.skull = {
	parent = vanilla_model.HEAD,
	models = {
		model.HEAD
	},
	equations = {
		rot = function(rot) return rot end,
		pos = function(pos) return pos + walk_anim.functions.getBreathingOffset() end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.body.torso = {
	parent = vanilla_model.TORSO,
	models = {
		model.TORSO
	},
	equations = {
		rot = function(rot) return rot end,
		pos = function(pos) return pos + walk_anim.functions.getBreathingOffset() end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.arms.left = {
	parent = vanilla_model.LEFT_ARM,
	models = {
		model.LEFT_ARM
	},
	equations = {
		rot = function(rot) return rot end,
		pos = function(pos) return pos + walk_anim.functions.getBreathingOffset() end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.arms.right = {
	parent = vanilla_model.RIGHT_ARM,
	models = {
		model.RIGHT_ARM
	},
	equations = {
		rot = function(rot) return rot end,
		pos = function(pos) return pos + walk_anim.functions.getBreathingOffset() end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.lowerarms.left = {
	parent = vanilla_model.LEFT_ARM,
	models = {
		model.LEFT_ARM.LOWER_LEFT_ARM
	},
	equations = {
		rot = function(rot) return vectors.of({
			math.clamp(rot.x + 10, 0,20),
			0,
			0})
		end,
		pos = function(pos) return vectors.of({0,0,0}) end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.lowerarms.right = {
	parent = vanilla_model.RIGHT_ARM,
	models = {
		model.RIGHT_ARM.LOWER_RIGHT_ARM
	},
	equations = {
		rot = function(rot) return vectors.of({
			math.clamp(rot.x + 10, 0,20),
			0,
			0})
		end,
		pos = function(pos) return vectors.of({0,0,0}) end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.legs.left = {
	parent = vanilla_model.LEFT_LEG,
	models = {
		model.LEFT_LEG
	},
	equations = {
		rot = function(rot) return rot * vectors.of({0.75,0.75,0.75}) end,
		pos = function(pos) return pos end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.legs.right = {
	parent = vanilla_model.RIGHT_LEG,
	models = {
		model.RIGHT_LEG
	},
	equations = {
		rot = function(rot) return rot * vectors.of({0.75,0.75,0.75}) end,
		pos = function(pos) return pos end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.shins.right = {
	parent = vanilla_model.RIGHT_LEG,
	models = {
		model.RIGHT_LEG.RIGHT_SHIN
	},
	equations = {
		rot = function(rot) return vectors.of({
			math.clamp(rot.x, -45, 0),
			0,
			0})
		end,
		pos = function(pos) return vectors.of({0,0,0}) end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.bones.shins.left = {
	parent = vanilla_model.LEFT_LEG,
	models = {
		model.LEFT_LEG.LEFT_SHIN
	},
	equations = {
		rot = function(rot) return vectors.of({
			math.clamp(rot.x, -45, 0),
			0,
			0})
		end,
		pos = function(pos) return vectors.of({0,0,0}) end
	},
	pos = vectors.of({0,0,0}),
	last_pos = vectors.of({0,0,0}),
	rot = vectors.of({0,0,0}),
	last_rot = vectors.of({0,0,0}),
}

walk_anim.functions.forEachBone = function(func)
	util.forEachPair(walk_anim.bones, function(bone_name, bones)
		func(bone_name, bones)
	end)
end

walk_anim.functions.forEachGroup = function(func)
	walk_anim.functions.forEachBone(function (bone_name, bone)
		util.forEachPair(bone, function(group_name, group)
			func(bone_name, bone, group_name, group)
		end)
	end)
end

walk_anim.functions.forEachModel = function(func)
	walk_anim.functions.forEachGroup(function (bone_name, bone, group_name, group)
		util.forEachPair(group.models, function(index, model)
			func(bone_name, bone, group_name, group, index, model)
		end)
	end)
end

walk_anim.functions.getOrigin = function (vanilla_part)
	local pos = vanilla_part.getOriginPos()
	local rot = vanilla_part.getOriginRot()
	rot = vectors.of({
		-math.deg(rot.x),
		-math.deg(rot.y),
		math.deg(rot.z),
	})
	return pos, rot
end

walk_anim.functions.getPosRot = function (part)
	local pos = part.getPos()
	local rot = part.getRot()
	return pos, rot
end

function tick()
	walk_anim.vars.counter = walk_anim.vars.counter + 1

	walk_anim.vars.last_player_pos = walk_anim.vars.player_pos
	walk_anim.vars.player_pos = player.getPos()
	walk_anim.vars.player_velocity = walk_anim.vars.last_player_pos - walk_anim.vars.player_pos
	local player_speed = walk_anim.vars.player_velocity.getLength()

	util.forEachPair(walk_anim.bones.head, function(group_name, group)
		util.forEachPair(group.models, function(index, model)
			local x = not renderer.isFirstPerson()
			model.setEnabled(x)
		end)
	end)

	walk_anim.functions.forEachGroup(function(bone_name, bone, group_name, group)
		walk_anim.bones[bone_name][group_name].last_rot = walk_anim.bones[bone_name][group_name].rot
		walk_anim.bones[bone_name][group_name].last_pos = walk_anim.bones[bone_name][group_name].pos
	end)

	walk_anim.functions.forEachGroup(function (bone_name, bone, group_name, group)
		local pos;
		local rot;

		if type(walk_anim.bones[bone_name][group_name].parent) == "nil" then
			-- If the parent is nil, simply call the equasion getters with vector 0s
			pos = vectors.of({0,0,0})
			rot = vectors.of({0,0,0})

		elseif type(walk_anim.bones[bone_name][group_name].parent.getOriginPos) == "function" then
			-- If the parent is a vanilla_model, getOrigin
			pos, rot = walk_anim.functions.getOrigin(walk_anim.bones[bone_name][group_name].parent)

		else
			-- Else, this is a custom model. So getPosRot
			pos, rot = walk_anim.functions.getPosRot(walk_anim.bones[bone_name][group_name].parent)
		end

		walk_anim.bones[bone_name][group_name].pos = walk_anim.bones[bone_name][group_name].equations.pos(pos)
		walk_anim.bones[bone_name][group_name].rot = walk_anim.bones[bone_name][group_name].equations.rot(rot)
	end)
end

function render(delta)
	walk_anim.functions.forEachModel(function(bone_name, bone, group_name, group, index, model)
			model.setPos(vectors.lerp(group.last_pos, group.pos, delta))
			model.setRot(vectors.lerp(group.last_rot, group.rot, delta))
		end)
end


