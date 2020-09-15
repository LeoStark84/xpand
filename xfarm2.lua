xfarm.register_plant = function(parentmod, plant)
	-- first var init
	local abortdef = false
	-- mandatory parameters checkup
	if (type(plant.name) ~= "string") or (plant.name == "") then
		abortdef = 1
		minetest.log("Something went wrong in xfarm")
		minetest.log("plant name undefined")
	end
	-- if no fatal error
	if not abortdef then
	-- var declaring
		local phases = 0 -- plants phases
		local basetime = 0 -- nominal grow time
		local tall = 0 -- phase when plant becomes tall
		local get_from = "" -- wild seed from grass or wil wild plant
		local wild_biomes = {} -- biomes where sild plant appears
		local wild_drop = 0 -- seeds wild plant drops
		local seed_dropper = ""
		local primary = ""
		local primary_pre = ""
		local primary_base = ""
		local primary_suf = ""
		local primary_count = 0
		local primary_node = ""
		local primary_tile = ""
		local seed = ""
		local seed_pre = ""
		local seed_base = ""
		local seed_suf = ""
		local seed_count = 0
		local plantgroups = { xfarm = 1, plant = 1 }
		local plantdrop = { items = {}, max_items = 0 }
		
		-- put everything into vars, use default value wjere needed
		phases = xhelper.def_or_def(plant.phases, "number", false, 1)
		basetime = xhelper.def_or_def(plant.seconds_per_phase, "number", false, 30)
		tall = xhelper.def_or_def(plant.tall_phase, "number", false, false)
		if type(plant.first_seed) == "table" then
			wild_biomes = xhelper.def_or_def(plant.first_seed.wild_biomes, false, { "grassland" })
			wild_drop = xhelper.def_or_def(plant.first_seed.drop, "number"
			get_from = "wild"
		else
			get_from = "grass"
		end
		if type(plant.primary_drop_name) == "table" then
			primary_pre = xhelper.def_or_def(plant.primary_drop_name.pre, "string", false, "")
			if not plant.primary_drop_namea.ovr then
				primary_base = plant.name
			else
				primary_base = xhelper.def_or_def(plant.primary_drop_name.ovr, "string", false, "")
			end
			primary.suf = xhelper.def_or_def(plant.primary_drop_name.suf, "string", false, "")
			if (primary_pre == "") and (primary_base == "") and (primary_suf == "") then
				primary = plant.name
			else
				primary = primary.pre .. primary.base .. primary.suf
			end
		else
			primary = xhelper.def_or_def(plant.primary_drop_name, "string", false, plant.name)
		end
		primary_item = parentmod .. ":" .. primary
		primary_tile = parentmod .. "_" .. primary .. ".png"
		primary_count = xhelper.def_or_def(plant.primary_drop_count, "number", false, 1)
		seed_dropper = xhelper.def_or_def(plant.seed_origin, "string", { "from_primary", "from_plant", "is_primary" }, "from_plant")
		if seed_dropper == "is_primary" then -- seed, seednode, seedtile and seedcount here
			seed = primary_name
			seed_count = false
			seed_node = parentmod .. ":" .. seed
			seed_tile = parentmod .. "_" .. seed .. ".png"
			seed_inv = parentmod .. ":" .. plant.name .. "_0.png"
		else
			if type(plant.seed_name = "table" then
				seed_pre = xhelper.def_or_def(plant.seed_name.pre, "string", true, "")
				if plant.seed_name.ovr ~= false then
					seed_base = xhelper.def_or_def(plant.seed_name.ovr, "string", true, "")
				else
					seed_base = plant.name
				end
				seed_suf = xhelper.def_or_def(plant.seed_name.suf, "string", true, "")
				if (seed_pre == "") and (seed_base == "") and (seed_suf == "") then
					seed = plant.name .. "_seed"
				else
					seed = seed_pre .. seed_base .. seed_suf
				end
			else
				seed = xhelper.def_or_def(plant.seed_name, "string", false, "seeds")
			end
			seed_count = xhelper.def_or_def(plant.seed_count, "number", false, 2)
			seed_node = parentmod .. ":" .. seed
			seed_tile = parentmod .. "_" .. seed .. ".png"
			seed_inv = seed_tile
		end
		table.insert(plantdrop.items, { items = primary_node .. primary_count})
		
		-- register seed node
		minetest.register_node(seed_node {
			description = xhelper.descriptify(seed),
			tiles = { seed_tile },
			inventory_image = seedtile,
			wield_image = 
			groups = plantgroups,
			walkable = false,
			buildable_to = true,
			drawtype = "signlike",
			paramtype = "light",
			paramtype2 = "wallmounted",
			sounds = default.node_sound_leaves_defaults(),
			sunlight_propagates = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
			on_construct = function(pos)
				local fertility = minetest.get_node_group(minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z }).name, "soil")
				if (fertility > 0) and (minetest.get_node_light(pos, 0.5) > 9) then
					minetest.get_node_timer(pos):start(xfarm.get_phase_timer(fertility, basetime))
				else
					minetest.get_node_timer(pos):start(300)
				end
			end,
			on_timer = function(pos,time)
				local fertility = minetest.get_node_group(minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z }).name, "soil")
				if (fertility > 0) and (minetest.get_node_light(pos, 0.5) > 9) then
					minetest.set_node(pos, { name = parentmod .. ":" .. plant.name .. "_1" })
				else
					minetest.remove_node(pos)
				end
				return false
			end
		})
		
		-- register non-last phases (if needed)
		if phases > 2 then
			for curphase = 1 to phases - 2 do
				if tall and (tall <= curphase)
					scale = 2
				else
					scale = 1
				end
				minetest.register_node(parentmod .. ":"  .. plant.name .. "_" .. curphase, {
					description = xhelper.descriptify(plant.name) .. " " .. curphase,
					tiles = { parentmod .. "_" .. plant.name .. "_" .. curpphase .. ".png" },
					visual_scale = scale,
					inventory_image = parentmod .. "_" .. plant.name .. "_" .. curphase .. ".png",
					groups = plantgroups,
					walkable = false,
					buildable_to = true,
					paramtype = "light",
					drawtype = "plantlike",
					sunlight_propagates = true,
					drop = seed_node_name,
					on_construct = function(pos)
						local fertility = minetest.get_node_group(minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z }).name, "soil")
						if (fertility > 0) and (minetest.get_node_light(pos, 0.5) > 9) then
							minetest.get_node_timer(pos):start(xfarm.get_phase_timer(fertility, basetime))
						else
							minetest.get_node_timer(pos):start(300)
						end
						return nil
					end,
					on_timer = function(pos,time)
						local fertility = minetest.get_node_group(minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z }).name, "soil")
						if (fertility > 0) and (minetest.get_node_light(pos, 0.5) > 9) then
							minetest.set_node(pos, { name = parentmod .. ":" .. plant.name .. "_" .. curphase + 1})
						else
							minetest.remove_node(pos)
						end
					end
				})
			end -- next curphase
		end -- endif
		
		-- register plant's last phase
		if 
		
		
		
		
		
		
		
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	
		-- second var init
		local seed_full_name = ""
		if (type(plant.seed_name) == "string") and (plant.seed_name ~= "") then
			seed_full_name = plant.name .. "_" .. plant.seed_name
		else
			seed_full_name = plant_name .. "_seed"
		end
		local seed_node_name = parentmod .. ":" .. seed_full_name
		local seed_tile_name = ""
		if plant.seed_origin = "is_primary" then
			seed_file_name = parentmod .. "_" .. plant.name .. "_0.png"
		else
			seed_file_name = parentmod .. "_" .. seed_full_name .. ".png"
		end
		local gr = { xfarm = 1, snappy = 3, flammable = 1 }
		
		-- register seed node
		
		-- third var init
		local phases = 0
		local scale = 0
		
		-- register plant phases
		if (type(plant.phases) ~= "number") or (plant.phases < 1) then
			phases = 1
		else
			phases = plant.phases
		end
		if phases > 1 then
			for curphase = 1, phases do
				if (type(plant.tall_phase) == "number") and (plant.tall_phase > 0) and (plant.tall_phase <= curphase)@ then
					scale = 2
				else
					scale = 1
				end
				
				minetest.register_node(parentmod .. ":"  .. plant.name .. "_" .. curphase, {
					description = xhelper.descriptify(plant.name) .. curphase,
					tiles = { parentmod .. "_" .. plant.name .. "_" .. curphase .. ".png" },
					visual_scale = scale,
					groups = gr,
					walkable = false,
					buildable_to = true,
					paramtype = "light",
					drawtype = "plantlike",
					sunlight_propagates = true,
					drop = seed_node_name,
					on_construct = function(pos)
						local fertility = minetest.get_node_group(minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z }).name, "soil")
						if (fertility > 0) and (minetest.get_node_light(pos, 0.5) > 9) then
							minetest.get_node_timer(pos):start(xfarm.get_phase_timer(fertility, plant.seconds_per_phase))
						else
							minetest.get_node_timer(pos):start(300)
						end
						return nil
					end,
					on_timer = function(pos,time)
					local fertility = minetest.get_node_group(minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z }).name, "soil")
						if (fertility > 0) and (minetest.get_node_light(pos, 0.5) > 9) then
							minetest.set_node(pos, { name = parentmod .. ":" .. plant.name .. "_" .. curphase + 1})
						else
							minetest.remove_node(pos)
						end
					end
				})
			end
		end
		-- fourth var init
		local plantdrop = {}
		plantdrop.items = {}
		if (type(plant.tall_phase) == "number") and (plant.tall_phase > 0) and (plant.tall_phase <= curphase)@ then
			scale = 2
		else
			scale = 1
		end
		local full_drop_name = ""
		if (type(plant.primary_drop_name) == "string") and (plant.primary_drop_name ~= "") then
			full_drop_name = plant.name .. "_" .. plant.primary_drop_name
		elseif type(plant.primary_drop_name) == "table" then
			if (type(plant.primary_drop_name.pre) == "string") and plant.primary_drop_name.pre ~= "" then
				preffix = plant.primary_drop_name.pre
				preffix_exists = true
			else
				preffix = ""
			end
			if (type(plant.primary_drop_name.ovr) == "string") and (plant.primary_drop_name.ovr ~= "") then
				base = plant.primary_drop_name.ovr
				ovr_exists = true
			else
				base = plant.name
			end
			if (type(plant.primary_drop_name.suf) == "string") and (plant.primary_drop_name.suf ~= "") then
				suffix = plant.primary_drop_name.suf
				suffix_exists = true
			else
				suffix = ""
			end
			if preffix_exists or ovr_exists or suffix_exists then
				full_drop_name = preffix .. base .. suffix
			else
				full_drop_name = plant.name
			end
		else
		
		
		
		local primary_drop_item = 
		
		-- register last last phase
	

end