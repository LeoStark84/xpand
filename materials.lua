materials = { redundant = {}, nonredundant = {} }

materials.nonredundant.marble = {
	name = "marble",
	crafter = "", -- to be registered by regjstrr_material_base at runtime
	texture = { "xpand_white_marble.png" },
	soundset = default.node_sound_stone_defaults(),
	flammability = 0,
	gr = { cracky = 2, marble = 1 }
}

materials.redundant.cobblestone = {
	name = "cobblestone",
	 crafter = "default:cobble",
	texture = { "default_cobble.png" },
	soundset = default.node_sound_stone_defaults(),
	flammability = 0,
	gr = { cracky = 3 },
}
	
	