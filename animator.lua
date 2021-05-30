if(not util)or(util.__version<1)then error('animator.lua requires utilities.lua')end animator={vars={},bones={},functions={},classes={}}animator.classes.Bone={__BONECLASS=true}function animator.classes.Bone:create(t)local obj=t setmetatable(obj, animator.classes.Bone)self.__index=self obj.data={pos={this=t.origin.pos,last=t.origin.pos},rot={this=t.origin.rot,last=t.origin.rot},scale={this=t.origin.scale,last=t.origin.scale}}return obj end function animator.classes.Bone:updateLastData()self.data.pos.last=self.data.pos.this self.data.rot.last=self.data.rot.this self.data.scale.last=self.data.scale.this end function animator.classes.Bone:forEachModel(func)util.forEachPair(self.models, func)end function animator.functions.getPartData(part)if part.getOriginPos then local origin_rotation=part.getOriginRot()return part.getOriginPos(),vectors.of{math.deg(-origin_rotation.x), math.deg(-origin_rotation.y), math.deg(origin_rotation.z)},vectors.of{1,1,1}elseif part.getPos then return part.getPos(),part.getRot(),part.getScale()else error("Bone model did not have proper data fetchers.")end end animator.functions.forEachBone=function(func)util.forEachPair(animator.bones, func)end function tick()animator.functions.forEachBone(function(bone_name, bone)local pos,rot,scale if (type(bone.parent) == "nil") then pos,rot,scale=bone.data.pos.this, bone.data.rot.this, bone.data.scale.this else pos,rot,scale=animator.functions.getPartData(bone.parent)end bone:updateLastData()bone.data.pos.this=bone.modifiers.pos.enabled and bone.modifiers.pos.tick(bone.data.pos.last, bone.modifiers.pos.locked and pos or bone.data.pos.this) or bone.origin.pos bone.data.rot.this=bone.modifiers.rot.enabled and bone.modifiers.rot.tick(bone.data.rot.last, bone.modifiers.rot.locked and rot or bone.data.rot.this) or bone.origin.rot bone.data.scale.this=bone.modifiers.scale.enabled and bone.modifiers.scale.tick(bone.data.scale.last, bone.modifiers.scale.locked and scale or bone.data.scale.this) or bone.origin.scale end)end function render(delta)animator.functions.forEachBone(function(bone_name, bone)local lerp_pos,lerp_rot,lerp_scale=bone.modifiers.pos.render(bone.data.pos.last, bone.data.pos.this, delta),bone.modifiers.rot.render(bone.data.rot.last, bone.data.rot.this, delta),bone.modifiers.scale.render(bone.data.scale.last, bone.data.scale.this, delta)bone:forEachModel(function(model_name, model)model.setPos(lerp_pos)model.setRot(lerp_rot)model.setScale(lerp_scale)end)end)end

--!| Define Helper Functions Up Here |!--

-- An Example Helper Function
function breathingOffset()
	return vectors.of{0,math.sin(util.wave(20, 0.5)),0}
end

--!| Create Bones Here |!--

animator.bones.head = animator.classes.Bone:create({
	parent = vanilla_model.HEAD,
	models = { models.head },
	origin = {
		pos = vectors.of{0,0,0},
		rot = vectors.of{0,0,0},
		scale = vectors.of{1,1,1}
	},
	modifiers = {
		pos = {
			enabled = true,
			locked = true,
			tick = function(last_pos, pos) return pos + breathingOffset() end,
			render = function(last_pos, pos, delta) return vectors.lerp(last_pos, pos, delta) end
		},
		rot = {
			enabled = true,
			locked = true,
			tick = function(last_rot, rot) return rot end,
			render = function(last_rot, rot, delta) return vectors.lerp(last_rot, rot, delta) end
		},
		scale = {
			enabled = false,
			locked = true,
			tick = function(last_scale, scale) return scale end,
			render = function(last_scale, scale, delta) return vectors.lerp(last_scale, scale, delta) end
		}
	}
})

animator.bones.torso = animator.classes.Bone:create({
	parent = vanilla_model.TORSO,
	models = { models.body },
	origin = {
		pos = vectors.of{0,0,0},
		rot = vectors.of{0,0,0},
		scale = vectors.of{1,1,1}
	},
	modifiers = {
		pos = {
			enabled = true,
			locked = true,
			tick = function(last_pos, pos) return pos + breathingOffset() end,
			render = function(last_pos, pos, delta) return vectors.lerp(last_pos, pos, delta) end
		},
		rot = {
			enabled = true,
			locked = true,
			tick = function(last_rot, rot) return rot end,
			render = function(last_rot, rot, delta) return vectors.lerp(last_rot, rot, delta) end
		},
		scale = {
			enabled = false,
			locked = true,
			tick = function(last_scale, scale) return scale end,
			render = function(last_scale, scale, delta) return vectors.lerp(last_scale, scale, delta) end
		}
	}
})

animator.bones.left_arm = animator.classes.Bone:create({
	parent = vanilla_model.LEFT_ARM,
	models = { models.leftArm },
	origin = {
		pos = vectors.of{5,2,0},
		rot = vectors.of{0,0,0},
		scale = vectors.of{1,1,1}
	},
	modifiers = {
		pos = {
			enabled = true,
			locked = true,
			tick = function(last_pos, pos) return pos + breathingOffset() end,
			render = function(last_pos, pos, delta) return vectors.lerp(last_pos, pos, delta) end
		},
		rot = {
			enabled = true,
			locked = true,
			tick = function(last_rot, rot) return rot end,
			render = function(last_rot, rot, delta) return vectors.lerp(last_rot, rot, delta) end
		},
		scale = {
			enabled = false,
			locked = true,
			tick = function(last_scale, scale) return scale end,
			render = function(last_scale, scale, delta) return vectors.lerp(last_scale, scale, delta) end
		}
	}
})

animator.bones.right_arm = animator.classes.Bone:create({
	parent = vanilla_model.RIGHT_ARM,
	models = { models.rightArm },
	origin = {
		pos = vectors.of{0,0,0},
		rot = vectors.of{0,0,0},
		scale = vectors.of{1,1,1}
	},
	modifiers = {
		pos = {
			enabled = true,
			locked = true,
			tick = function(last_pos, pos) return pos + breathingOffset() end,
			render = function(last_pos, pos, delta) return vectors.lerp(last_pos, pos, delta) end
		},
		rot = {
			enabled = true,
			locked = true,
			tick = function(last_rot, rot) return rot end,
			render = function(last_rot, rot, delta) return vectors.lerp(last_rot, rot, delta) end
		},
		scale = {
			enabled = false,
			locked = true,
			tick = function(last_scale, scale) return scale end,
			render = function(last_scale, scale, delta) return vectors.lerp(last_scale, scale, delta) end
		}
	}
})

animator.bones.left_leg = animator.classes.Bone:create({
	parent = vanilla_model.LEFT_LEG,
	models = { models.leftLeg },
	origin = {
		pos = vectors.of{0,0,0},
		rot = vectors.of{0,0,0},
		scale = vectors.of{1,1,1}
	},
	modifiers = {
		pos = {
			enabled = true,
			locked = true,
			tick = function(last_pos, pos) return pos end,
			render = function(last_pos, pos, delta) return vectors.lerp(last_pos, pos, delta) end
		},
		rot = {
			enabled = true,
			locked = true,
			tick = function(last_rot, rot) return rot end,
			render = function(last_rot, rot, delta) return vectors.lerp(last_rot, rot, delta) end
		},
		scale = {
			enabled = false,
			locked = true,
			tick = function(last_scale, scale) return scale end,
			render = function(last_scale, scale, delta) return vectors.lerp(last_scale, scale, delta) end
		}
	}
})

animator.bones.right_leg = animator.classes.Bone:create({
	parent = vanilla_model.RIGHT_LEG,
	models = { models.rightLeg },
	origin = {
		pos = vectors.of{0,0,0},
		rot = vectors.of{0,0,0},
		scale = vectors.of{1,1,1}
	},
	modifiers = {
		pos = {
			enabled = true,
			locked = true,
			tick = function(last_pos, pos) return pos end,
			render = function(last_pos, pos, delta) return vectors.lerp(last_pos, pos, delta) end
		},
		rot = {
			enabled = true,
			locked = true,
			tick = function(last_rot, rot) return rot end,
			render = function(last_rot, rot, delta) return vectors.lerp(last_rot, rot, delta) end
		},
		scale = {
			enabled = false,
			locked = true,
			tick = function(last_scale, scale) return scale end,
			render = function(last_scale, scale, delta) return vectors.lerp(last_scale, scale, delta) end
		}
	}
})
