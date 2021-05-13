
local armor_script = {
	vars = {},
	settings = {},
	functions = {}
}

armor_script.settings.models = {}
armor_script.settings.models.head = {
	model.head
}
armor_script.settings.models.chest = {
	model.body,
	model.arms
}
armor_script.settings.models.legs = {
	model.legs
}
armor_script.settings.models.feet = {
	model.feet
}

armor_script.settings.texture_size = vectors.of({256,256})

armor_script.settings.uv_offsets = {
	head = {
		["minecraft:air"] = vectors.of({0,0}),
		["minecraft:iron_helmet"] = vectors.of({0,128}),
		["minecraft:golden_helmet"] = vectors.of({0,64}),
		["minecraft:diamond_helmet"] = vectors.of({0,192}),
	},
	chest = {
		["minecraft:air"] = vectors.of({0,0}),
		["minecraft:iron_chestplate"] = vectors.of({0,128}),
		["minecraft:golden_chestplate"] = vectors.of({0,64}),
		["minecraft:diamond_chestplate"] = vectors.of({0,192}),
	},
	legs = {
		["minecraft:air"] = vectors.of({0,0}),
		["minecraft:iron_leggings"] = vectors.of({0,128}),
		["minecraft:golden_leggings"] = vectors.of({0,64}),
		["minecraft:diamond_leggings"] = vectors.of({0,192}),
	},
	feet = {
		["minecraft:air"] = vectors.of({0,0}),
		["minecraft:iron_boots"] = vectors.of({0,128}),
		["minecraft:golden_boots"] = vectors.of({0,64}),
		["minecraft:diamond_boots"] = vectors.of({0,192}),
	}
}

-- Collect the model UV maps
armor_script.vars.uv_map = {}
armor_script.functions.getArmorUV = function()
	for k,v in pairs(armor_script.settings.models) do
		armor_script.vars.uv_map[k] = {}
		for i,v2 in pairs(v) do
			armor_script.vars.uv_map[k][i] = v2.getUV()
		end
	end
end
armor_script.functions.getArmorUV()

armor_script.vars.last_armor = {}
armor_script.vars.armor = {
	head = "minecraft:air",
	chest = "minecraft:air",
	legs = "minecraft:air",
	feet = "minecraft:air"
}

armor_script.functions.updateArmor = function(this_armor)

	for slot, item_name in pairs(this_armor) do
		local uv_offset_exists = armor_script.settings.uv_offsets[slot][item_name]
		if uv_offset_exists then
			-- ((1 / texture_size) * offset)
			local uv_offset = (vectors.of({1,1}) / armor_script.settings.texture_size) * armor_script.settings.uv_offsets[slot][item_name]
			for i, part in pairs(armor_script.settings.models[slot]) do
				part.setUV(armor_script.vars.uv_map[slot][i] + uv_offset)
			end
		end
	end

end

armor_script.functions.checkForArmorChanges = function()
	armor_script.vars.last_armor = armor_script.vars.armor

	local this_armor = {
		head = player.getEquipmentItem(6).getType(),
		chest = player.getEquipmentItem(5).getType(),
		legs = player.getEquipmentItem(4).getType(),
		feet = player.getEquipmentItem(3).getType()
	}
	local updated = false
	local updated_armor = {}


	for k,v in pairs(this_armor) do
		if not (armor_script.vars.last_armor[k] == this_armor[k]) then
			armor_script.vars.armor[k] = this_armor[k]

			updated_armor[k] = this_armor[k]
			updated = true
		end
	end

	if updated then armor_script.functions.updateArmor(updated_armor) end
end

function tick()
	armor_script.functions.checkForArmorChanges()
end
