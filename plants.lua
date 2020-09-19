plants = {}

plants = {
	{
		name = "corn",
		phases = 8,
		tallphase = 6,
		seconds_per_phase = 30,
		first_seed = "grass",
		primary_drop_name = "ear", -- 
		primary_drop_count = 3,
		seed_name = "grains", -- 
		seed_origin = "from_primary", -- 
		seed_count = 3,
		ivylike = false,
		drop_else = false -- { name="", count=1 register = true } | { { name="", count=0, register=false }, { name="", count=0, register=false } }
	},
	{
		name = "tomato", -- mandatory param
		phases = 8, -- 1
		tall_phase = false, -- false
		seconds_per_phasee = 34, -- 30
		first_seed = { -- grass
			biomes = { "grassland_ocean" }, -- all_default
			drop_count = 2 -- 1
		},
		primary_drop_name = "", -- plant.name
		primary_drop_count = 4, -- 1
		seed_name = "seeds", -- seed
		seed_origin = "from_primary", -- from plant
		seed_count = 2, -- 2
		ivylike = false, --  false
		drop_else = false -- false
	},
	{
		name = "potato",
		phases = 4,
		tall_phase = false,
		first_seed = "grass",
		primary_drop_name = "",
		primary_drop_count = 4,
		seed_origin = "is_primary",
		seed_count = false,
		ivylike = false,
		drop_else = false
	},
	{
		name = "cabbage",
		phases = 6,
		tall_phase = false,
		seconds_per_phase = 60,
		first_seed = {
			biomes= { "grassland" },
			drop_count = 3
		},
		primary_drop_name = "leaves",
		primary_drop_count = 8,
		seed_origin = "from_plant",
		seed_name = "seeds",
		seed_count = 3,
		ivylike = false,
		drop_else = false
	},
	{
		name = "onion",
		phases = 5,
		seconds_per_phase = 33,
		first_seed = "grass",
		primary_drop_name = "",
		primary_drop_count = 6,
		seed_origin = "is_primary",
		seed_name = false,
		seed_count = 0,
		drop_else = false 
	},
	{
		name = "garlic",
		phases = 5,
		seconds_per_phase = 35,
		first_seed = "grass",
		primary_drop_name = "head",
		primary_drop_count = 4,
		seed_origin = "from_primary",
		seed_name = "clove",
		seed_count = 3,
		drop_else = false
	},
	{
		name = "carrot",
		phases = 8,
		seconds_per_phase = 28,
		first_seed = "grass",
		primary_drop_name = "",
		primary_drop_count = 3,
		seed_origin = "is_primary",
		seed_name = false,
		seed_count = 0,
		ivylike = false,
		drop_else = false
	},
	{
		name = "blueberry",
		phases = 4,
		seconds_per_phase = 45,
		first_seed = {
			biomes = { "grassland", "deciduous_forest", "coniferous_forest", "coniferous_forest_dunes" },
			drop_count = 2
		},
		primary_drop_name = "",
		primary_drop_count = 4,
		seed_origin = "from_primary",
		seed_name = "seeds",
		seed_count = 2,
		ivylike = false,
		drop_else = false
	}
}