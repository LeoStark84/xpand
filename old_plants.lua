plants = {}

plants.wheat = {
	name = "test_wheat", -- mandatory
	phases = 4, --mandatory
	tall_phase = 2, -- 0, nil or false for no tall phase. doubled on untiled soil, unchanged for tiled dry soil, reduced by 1/3 on tiled iirigated soil. formula: (2 * seconds_per_phase) / value of [soil] of node where it is planted
	seconds_per_phase = 90, -- default varies acirding to type
	first_seed = "grass", -- if undefined default is grass
	type = "cereal", -- mandatory
	cereal = { -- key matching type is mandatory
		pod_name = "spike", -- if not defined, plant name will be used, if defined, it will be concatenated as [plant_name].name .. " " .. [plant_name].cereal.pod_name
		pod_count = 2, -- default is one
		grain_name = "grains", -- default is grain
		grains_per_pod = 3, --  default is two
		raw_pod_eatable = false, -- 0, nil or false = non-eatable, any value n>0 makes it replenish n hearts
	},
	drop_else = "straw", -- 0, false or nil for none drop name for drop else
	drop_else_count = 4, -- if drop_else is defined, ddefault is 1, otherwise this is ignored
}

plants.pepper = {
	name = "pepper",
	phases = 3,
	tall_phase = false,
	seconds_per_phase = 90,
	first_seed = "wild",
	wild = {
		biomes = { "grassland_ocean" }, -- default is all biomes
		wild_drop_count = 2 -- if undefined, default is 1. for fruits and cereals, grain per pod / seed per fruit are halved (unless 1)
	},
	type = "fruit",
	fruit = {
		fruit_name = nil, -- nil, false or empty string for plants name
		fruit_count = 10, -- if not >0, one will be used by default
		seed_count = 1, -- if not >0, default is two
		raw_fruit_eatable = 1
	},
	drop_else = false,
	drop_else_count = 0
}

plants.potato = {
	name = "potato",
	phases = 3,
	tall_phase = false,
	seconds_per_phase = 85,
	first_seed = "grass",
	type = "tuber",
	tuber = {
		tubers_name = "",
		tubers_count = 4,
		raw_tuber_eatable = 0
	},
	drop_else = false,
	drop_else_count = 0,
}

plants.cabbage = {
	name = "cabbagge",
	phases = 3,
	tall_phase = false,
	seconds_per_phase = 80,
	first_seed = "wild",
	wild = {
		wild_biome = { "grassland" },
		wild_drop_count = 1
	},
	type = "leaf",
	leaf = {
		leaf_name = "leaves",
		leaves_count = 8,
		seed_name = nil,
		seed_count = 3
	},
	drop_else = false,
	drop_else_count = 0
}