xfarmver = 4
xfarmstatus = "beta"
modules = modules + 1
minetest.log("xfarm ver " .. xfarmver .. " " .. xfarmstatus)

xfarm = {}
ditchnodes = { "s", "c", "t", "x" }
point_at = { b = 0, r = 1, f = 2, l = 3 }
grassdrop = { items = {}, max_items = 1 } 






minetest.register_tool( "xpand:plow", {
	description = "Plow",
	inventory_image = "xpand_tool_plow.png",
	groups = { tools = 1 },
	on_use = function(itemstack, user, pointed_thing)
		if minetest.get_item_group(minetest.get_node(pointed_thing.under).name, "soil") == 1 then
		minetest.set_node(pointed_thing.under, { name = xhelper.if_nearby(pointed_thing.under, 3, "group:fditch", "xpand:irrigated_soil", "xpand:tiled_soil"), param2 = xhelper.yaw_to_param2(user)})
			--xhelper.set_oriented_node(user, pointed_thing.under, "xpand:tiled_soil")
		end
		return nil
	end
})

minetest.register_node( "xpand:tiled_soil", {
	description = "Tiled Soil",
	tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
	groups = { soil = 2, crumbly = 3 },
	paramtype2 = "facedir",
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults()
})

minetest.register_node("xpand:irrigated_soil", {
	description = "Irrigated Soil",
	tiles = {"default_dirt.png^farming_soil_wet.png", "default_dirt.png^farming_soil_wet_side.png"},
	groups = { soil = 3, crumbly = 3 },
	paramtype2 = "facedir",
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults()
})

xfarm.get_tiled_soil = function(pos, radius)
	local retval = false
	ditchpos = minetest.find_node_near(pos, radius, "group:ditch")
	if ditchpos then
		retval = "xpand:irrigated_soil"
	else
		retval = "xpand:tiled_soil"
	end
	return retval
end

xfarm.irrigate = function(pos, radius)
	local p1 = { x = pos.x - radius, y = pos.y, z = pos.z - radius}
	local p2 = { x = pos.x + radius, y = pos.y, z = pos.z + radius}
	local tiledpos = {}
	local indexes = {}
	tiledpos, indexes = minetest.find_nodes_in_area(p1, p2, "xpand:tiled_soil")
	for k, v in pairs(tiledpos) do
		minetest.swap_node(v, { name = "xpand:irrigated_soil", param2 = minetest.get_node(v).param2 })
	end
end



minetest.register_node( "xpand:dirt_with_empty_ditch_s", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, ditch = 1 },
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_empty_ditch_s.png", "default_dirt.png" }
})

minetest.register_node( "xpand:dirt_with_empty_ditch_c", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, ditch = 1 },
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_empty_ditch_c.png", "default_dirt.png" }
})

minetest.register_node( "xpand:dirt_with_empty_ditch_t", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, ditch = 1 },
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_empty_ditch_t.png", "default_dirt.png" }
})

minetest.register_node( "xpand:dirt_with_empty_ditch_x", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, ditch = 1},
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_empty_ditch_x.png", "default_dirt.png" }
})

minetest.register_node( "xpand:dirt_with_flooded_ditch_s", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, fditch = 1 },
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_flooded_ditch_s.png^[opacity:127", "default_dirt.png" }
})

minetest.register_node( "xpand:dirt_with_flooded_ditch_c", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, fditch= 1 },
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_flooded_ditch_c.png", "default_dirt.png" }
})

minetest.register_node( "xpand:dirt_with_flooded_ditch_t", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, fditch = 1 },
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_flooded_ditch_t.png", "default_dirt.png" }
})

minetest.register_node( "xpand:dirt_with_flooded_ditch_x", {
	description = "Dirt with Ditch",
	groups = { crumbly = 3, fditch = 1 },
	drop = "default:dirt",
	paramtype2 = "facedir",
	drop = "default:dirt",
	tiles = { "default_dirt.png^xpand_flooded_ditch_x.png", "default_dirt.png" }
})

minetest.register_tool( "xpand:ditcher", {
	description = "Ditch Shovel",
	inventory_image = "xpand_sharp_shovel.png",
	wield_image = "xpand_sharp_shovel.png",
	on_use = function(itemstack, user, pointed_thing)
		if minetest.get_item_group(minetest.get_node(pointed_thing.under).name, "soil") >= 1 then
			xfarm.place_ditch_and_update(pointed_thing.under, "n")
		end
		return nil
	end
})

xfarm.place_ditch_and_update = function(pos, dir)
	local left = {} -- left node pos
	local right = {} --right node pos
	local front = {}-- front node pos
	local back = {}-- back node pos
	left, right, front, back = xhelper.get_four_sides(pos)
	local lbool = false -- is left nkde a ditch?
	local rbool = false -- is right node a ditch?
	local fbool = false -- is front node a ditch?
	local bbool = false -- is back node a ditch?
	local totalcons = 0 -- total connectable nodes available
	local dname = "" -- ditch nodename
	local ddir = 0 -- ditch param2 value
	local isflooded = false -- is the ditch flooded?
	local errflag = false -- has there been an error?
	local dstatus = ""
	local oldnode = ""
	local newnode = ""
	if minetest.get_item_group(minetest.get_node(left).name, "water") ~= 0 then
		isflooded = true
	elseif minetest.get_item_group(minetest.get_node(right).name, "water") ~= 0 then
		isflooded = true
	elseif minetest.get_item_group(minetest.get_node(front).name, "water") ~= 0 then
		isflooded = true
	elseif minetest.get_item_group(minetest.get_node(back).name, "water") ~= 0 then
		isflooded = true
	end
	if xhelper.is_in_table(minetest.get_node(left).name, ditchnodes, nil, nil, "xpand:dirt_with_flooded_ditch_") then
		lbool = true
		isflooded = true
		totalcons = totalcons+ 1
	elseif xhelper.is_in_table(minetest.get_node(left).name, ditchnodes, nil, nil, "xpand:dirt_with_empty_ditch_") then
		lbool = true
		totalcons = totalcons + 1
	end
	if xhelper.is_in_table(minetest.get_node(right).name, ditchnodes, nil, nil, "xpand:dirt_with_flooded_ditch_") then
		rbool = true
		isflooded = true
		totalcons = totalcons+ 1
	elseif xhelper.is_in_table(minetest.get_node(right).name, ditchnodes, nil, nil, "xpand:dirt_with_empty_ditch_") then
		rbool = true
		totalcons = totalcons + 1
	end
	if xhelper.is_in_table(minetest.get_node(front).name, ditchnodes, nil, nil, "xpand:dirt_with_flooded_ditch_") then
		fbool = true
		isflooded = true
		totalcons = totalcons+ 1
	elseif xhelper.is_in_table(minetest.get_node(front).name, ditchnodes, nil, nil, "xpand:dirt_with_empty_ditch_") then
		fbool = true
		totalcons = totalcons + 1
	end
	if xhelper.is_in_table(minetest.get_node(back).name, ditchnodes, nil, nil, "xpand:dirt_with_flooded_ditch_") then
		bbool = true
		isflooded = true
		totalcons = totalcons+ 1
	elseif xhelper.is_in_table(minetest.get_node(back).name, ditchnodes, nil, nil, "xpand:dirt_with_empty_ditch_") then
		bbool = true
		totalcons = totalcons + 1
	end
	if totalcons == 4 then
		dname = "x"
		ddir = 0
	elseif totalcons == 3 then
		dname = "t"
		if not lbool then
			ddir = point_at.l
		elseif not rbool then
			ddir = point_at.r
		elseif not fbool then
			ddir = point_at.f
		elseif not bbool then -- not bbool
			ddir = point_at.b
		else
			minetest.log("Something went awfully wrong")
			minetest.log("in totalcons=3, totalcons is " .. totalcons)
			minetest.log("lbool=" .. tostring(lbool) .. ", rbool=" .. tostring(rbool) .. ", fbool=" .. tostring(fbool) .. ", bbool=" .. tostring(bbool))
			errflag = true
		end
	elseif totalcons == 2 then
		if lbool and bbool then
			dname = "c"
			ddir = point_at.b
		elseif lbool and rbool then
			dname = "s"
			ddir = point_at.l
		elseif lbool and fbool then
			dname = "c"
			ddir = point_at.l
		elseif bbool and rbool then
			dname = "c"
			ddir = point_at.r
		elseif bbool and fbool then
			dname = "s"
			ddir = point_at.b
		elseif rbool and fbool then-- rbool and fbool
			dname = "c"
			ddir = point_at.f
		else
			minetest.log("Something went awfully wrong")
			minetest.log("in totalcons=2, totalcons is " .. totalcons)
			minetest.log("lbool=" .. tostring(lbool) .. ", rbool=" .. tostring(rbool) .. ", fbool=" .. tostring(fbool) .. ", bbool=" .. tostring(bbool))
			errflag = true
		end
	elseif totalcons == 1 then
		dname = "s"
		if lbool then
			ddir = point_at.l
		elseif rbool then
			ddir = point_at.r
		elseif fbool then
			ddir= point_at.f
		elseif bbool then
			ddir = point_at.b
		else
			minetest.log("Something went awfully wrong")
			minetest.log("in totalcons=1, totalcons is " .. totalcons)
			minetest.log("lbool=" .. tostring(lbool) .. ", rbool=" .. tostring(rbool) .. ", fbool=" .. tostring(fbool) .. ", bbool=" .. tostring(bbool))
			errflag = true
		end
	elseif totalcons == 0 then
		dname = "s"
		ddir = 0
	end
	if not errflag then
		if isflooded then
			dstatus = "flooded"
			xfarm.irrigate(pos,3)
		else
			dstatus = "empty"
		end
		oldnode = minetest.get_node(pos).name
		newnode = "xpand:dirt_with_" .. dstatus .. "_ditch_" .. dname
		minetest.set_node(pos, { name = newnode, param2 = ddir })
		if oldnode ~= newnode then
			if lbool and (dir ~= "l") then xfarm.place_ditch_and_update(left, "r") end
			if rbool and (dir ~= "r") then xfarm.place_ditch_and_update(right, "l") end
			if fbool and (dir ~= "f") then xfarm.place_ditch_and_update(front, "b") end
			if bbool and (dir ~= "b") then xfarm.place_ditch_and_update(back, "f") end
		end
	else
		minetest.log("Ditch placing aborted")
	end
end



xfarm.get_phase_timer = function(fertility, nominal_time)
	return ((nominal_time * 2) / fertility) * ((((math.random() * 2) - 1) / 10) + 1)
end

xfarm.register_all_plants = function(parentmod, plantlist)
	for i = 1, #plantlist do
		xfarm.register_plant(parentmod, plantlist[i])
	end
	table.insert(grassdrop.items, { items = "default:grass_1"})
	for i = 1, 5 do
		minetest.override_item( "default:grass_" .. i, {
			drop = grassdrop
		})
	end
	minetest.log("grass now drops " .. dump(grassdrop))
end


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
		local scale = 0
		local wild = ""
		local wild_tile = ""
		local wild_node
		local get_from = "" -- wild seed from grass or wil wild plant
		local wild_biomes = {} -- biomes where wmild plant appears
		local wild_drop = 0 -- seeds wild plant drops
		local seed_dropper = ""
		local primary = ""
		local primary_pre = ""
		local primary_base = ""
		local primary_suf = ""
		local primary_count = 0
		local primary_node = ""
		local primary_tile = ""
		local preseed = ""
		local preseed_node = ""
		local preseed_tile = ""
		local seed = ""
		local seed_pre = ""
		local seed_base = ""
		local seed_suf = ""
		local seed_count = 0
		local seed_node = ""
		local seed_tile = ""
		local seed_inv = ""
		local plantgroups = { xfarm = 1, plant = 1, snappy = 3 }
		local plantdropminus = { items = {}, max_items = 0 }
		local plantdropbase = { items = {}, max_items = 0 }
		local plantdropplus = { items = {}, max_items = 0 }
		local top_nodes = {}
		-- very utilized vars
		phases = xhelper.def_or_def(plant.phases, "number", false, 1)
		basetime = xhelper.def_or_def(plant.seconds_per_phase, "number", false, 30)
		tall = xhelper.def_or_def(plant.tall_phase, "number", false, false)
		-- first seed vars
		if type(plant.first_seed) == "table" then
			wild_drop = xhelper.def_or_def(plant.first_seed.drop, "number", false, 1)
			get_from = "wild"
			if type(plant.first_seed.wild_biomes) == "table" then
				wild_biomes = xhelper.def_or_def(plant.first_seed.wild_biomes, "table", false, { "grassland"})
			elseif type(plant.first_seed.wild_biomes) == "string" then
				wild_biomes = xhelper.def_or_def(plant.first_seed.wild_biomes, "string", false, { "grassland" })
			else
				wild_biomes = { "grassland" }
			end
		else
			get_from = "grass"
		end
		-- set vars for primary drop
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
			if xhelper.def_or_def(plant.primary_drop_name, "string", false, "") == "" then
				primary = plant.name
			else
				primary = plant.name .. "_" .. xhelper.def_or_def(plant.primary_drop_name, "string", false, "")
			end
		end
		-- set all other primary vars
		primary_node = parentmod .. ":" .. primary
		primary_tile = parentmod .. "_" .. primary .. ".png"
		primary_count = xhelper.def_or_def(plant.primary_drop_count, "number", false, 1)
		seed_dropper = xhelper.def_or_def(plant.seed_origin, "string", { "from_primary", "from_plant", "is_primary" }, "from_plant")
		-- set values for seeds
		if seed_dropper == "is_primary" then --#1-- seed, seednode, seedtile and seedcount here
			seed = primary
			seed_node = primary_node
			seeda_tile = parentmod .. "_" .. plant.name .. "_0.png"
			seed_inv = primary_tile
			seed_count = primary_tile
		else
			if plant.ivylike then -- #2
				if type(plant.seed_name) == "table" then --#3
					seed_pre = xhelper.def_or_def(plant.seed_name.pre, "string", true, "")
					if plant.seed_name.ovr ~= false then --#4
						seed_base = xhelper.def_or_def(plant.seed_name.ovr, "string", true, "")
					else
						seed_base = plant.name
					end --#4
					seed_suf = xhelper.def_or_def(plant.seed_name.suf, "string", true, "")
					if (seed_pre == "") and (seed_base == "") and (seed_suf == "") then
						preseed = plant.name .. "_seed"
					else
						preseed = seed_pre .. seed_base .. seed_suf
					end
				else
					preseed = plant.name .. "_" .. xhelper.def_or_def(plant.seed_name, "string", false, "seeds")
				end
				preseed_item = parentmod  .. ":" .. preseed
				preseed_tile = parentmod .. "_" .. preseed .. ".png"
				seed = preseed .. "_with_support_sticks"
				seed_node = parentmod .. ":" .. seed
				seed_inv = parentmod .. "_" .. seed .. ".png"
				seed_tile = parentmod .. "_" .. seed .. ".png"
				seed_count = xhelper.def_or_def(plant.seed_count, "number", false, 2)
				minetest.register_craftitem(preseed_item, {
					description = xhelper.descriptify(preseed),
					inventory_image = preseed_tile
				})
				minetest.register_craft({
					type = "shapeless",
					output = seed_node,
					recipe = { preseed_node, "xpand:support_sticks" }
				})
			else
				if type(plant.seed_name) == "table" then --#3
					seed_pre = xhelper.def_or_def(plant.seed_name.pre, "string", true, "")
					if plant.seed_name.ovr ~= false then --#4
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
					seed = plant.name .. "_" .. xhelper.def_or_def(plant.seed_name, "string", false, "seeds")
				end
				seed_node = parentmod .. ":" .. seed
				seed_inv = parentmod .. "_" .. seed .. ".png"
				seed_tile = seed_inv
				seed_count = xhelper.def_or_def(plant.seed_count, "number", false, 2)
			end
		end
			-- register seed and phases
		if phases >= 2 then -- grow to single version phase 1
			minetest.register_node(seed_node, {
				description = xhelper.descriptify(seed),
				tiles = { seed_tile },
				inventory_image = seed_inv,
				wield_image = seed_tile,
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
						if fertility == 1 then
							minetest.swap_node({x = pos.x, y = pos.y - 1, z = pos.z }, { name = "default:dirt" })
						end
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
			-- -- all phases but last two
			if phases > 2 then -- only when more than 2 phases
				for curphase = 1, phases - 2 do -- iterate registration for all phases but last two
					if tall and (tall <= curphase) then
						scale = 2
					else
						scale = 1
					end
					minetest.register_node(parentmod .. ":"  .. plant.name .. "_" .. curphase, {
						description = xhelper.descriptify(plant.name) .. " " .. curphase,
						tiles = { parentmod .. "_" .. plant.name .. "_" .. curphase .. ".png" },
						visual_scale = scale,
						inventory_image = parentmod .. "_" .. plant.name .. "_" .. curphase .. ".png",
						groups = plantgroups,
						walkable = false,
						buildable_to = true,
						paramtype = "light",
						drawtype = "plantlike",
						sunlight_propagates = true,
						drop = seed_node,
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
			end
			-- register pre-last phase
			if tall and (tall <= curphase) then
				scale = 2
			else
				scale = 1
			end
			minetest.register_node(parentmod .. ":"  .. plant.name .. "_" .. phases - 1, {
				description = xhelper.descriptify(plant.name) .. " " .. phases - 1,
				tiles = { parentmod .. "_" .. plant.name .. "_" .. phases - 1 .. ".png" },
				visual_scale = scale,
				inventory_image = parentmod .. "_" .. plant.name .. "_" .. phases - 1 .. ".png",
				groups = plantgroups,
				walkable = false,
				buildable_to = true,
				paramtype = "light",
				drawtype = "plantlike",
				sunlight_propagates = true,
				drop = seed_node,
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
						if fertility == 1 then
							minetest.set_node(pos, { name = parentmod .. ":" .. "infra_" .. plant.name .. "_" .. phases })
						elseif fertility == 2 then
							minetest.set_node(pos, { name = parentmod .. ":" .. plant.name .. "_" .. phases })
						else
							minetest.set_node(pos, { name = parentmod .. ":" .. "supra_" .. plant.name .. "_" .. phases })
						end
					else
						minetest.remove_node(pos)
					end
				end
			})
		else -- if only 1 phase 
			minetest.register_node(seed_node { -- grow to -1, 0 or +1 versions of phase 1 depending on soil quality straight from the seed
				description = xhelper.descriptify(seed),
				tiles = { seed_tile },
				inventory_image = seed_inv,
				wield_image = seed_tile,
				groups = plantgroups,
				walkable = false,
				buildable_to = true,
				drawtype = "signlike",
				paramtype2 = "wallmounted",
				paramtype = "light",
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
						if fertility == 1 then
							minetest.swap_node( { x = pos.x, y = pos.y - 1, z = pos.z }, { name = "default:dirt" })
						end
					else
						minetest.get_node_timer(pos):start(300)
					end
				end,
				on_timer = function(pos,time)
					local fertility = minetest.get_node_group(minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z }).name, "soil")
					if (fertility > 0) and (minetest.get_node_light(pos, 0.5) > 9) then
						if fertility == 1 then
							minetest.set_node(pos, { name = parentmod .. ":" .. "infra_" .. plant.name .. "_1" })
						elseif fertility == 2 then
							minetest.set_node(pos, { name = parentmod .. ":" .. plant.name .. "_1" })
						else
							minetest.set_node(pos, { name = parentmod .. ":" .. "supra" .. plant.name .. "_1" })
						end
					else
						minetest.remove_node(pos)
					end
					return false
				end
			})
		end
		
		-- create primary drop
		if primary_count == 1 then
			table.insert(plantdropminus.items, { items = { primary_node }, rarity = 2 })
		else
			table.insert(plantdropminus.items, { items = { primary_node .. " " .. primary_count -1} })
		end
		table.insert(plantdropbase.items, { items = {primary_node .. " " .. primary_count }})
		table.insert(plantdropplus.items, { items = {primary_node .. " " .. primary_count + 1 }})
		-- create seed drop if needed
		if seed_dropper == "from_plant" then
			if plant.ivylike then
				if preseed_count == 1 then
					table.insert(plantdropminus.items, { items = {preseed_node, rarity = 2 }})
				else
					table.insert(plantdropminus.items, { itema = {preseed_node .. " " .. preseed_count - 1 }})
				end
				table.insert(plantdropbase.items, { items = {preseed_node .. " " .. preseed_count }})
				table.insert(plantdropplus.items, { items = {preseed_node .. " " .. preseed_count + 1 }})
			else
				if  seed_count == 1 then
					table.insert(plantdropminus.items, { items = {seed_node, rarity = 2 }})
				else
					table.insert(plantdropminus.items, {items = {seed_node .. " " .. seed_count - 1} })
				end
				table.insert(plantdropbase.items, { items = {seed_node .. " " .. seed_count }})
				table.insert(plantdropplus.items, { items = {seed_node .. " " .. seed_count + 1 }})
			end
		end
		 -- add drop_else to table if needed and oh boy it'going to be long
		if type(plant.drop_else) == "table" then
			if type(plant.drop_else[1]) == "table" then
				for i = 1, #plant.drop_else do --#3
					if plant.drop_else[i]["count"] == 1 then
						table.insert(plantdropminus, { items = {plant.drop_else[i]["name"]}, rarity = 2 })
					else -- #4
						table.insert(plantdropminus, {items = {plantdrop_else[i]["name"] .. " " .. plant.drop_else[i]["count"] - 1} })
					end -- #4
					table.insert(plantdropbase.items, { items = {plant.drop_else[i]["name"] .. " " .. plant.drop_else[i]["count"] }})
					table.insert(plantdropplus.items, { items = {plant.drop_else[i]["name"] .. " " .. plant.drop_else[i]["count"] + 1} })
					if plant.drop_else[i]["register"] then -- #4
						minetest.register_craftitem( parentmod .. ":" .. plant.drop_else[i]["name"], {
							description = xhelper.descriptify(plant.drop_else[i]["name"]),
							tiles = { parentmod .. "_" .. plant.drop_else[i]["name"] .. ".png" },
							groups = { xfarm = 1, byproduct = 1 }
						})
					end
				end
			else
				if plant.drop_else.count == 1 then
					table.insert(plantdropminus, { items = {plant.drop_else.name, rarity = 2} })
				else
					rable.insert(plantdropminus, { items = {plant.drop_else.name .. " " .. plant.drop_else.count - 1 }})
				end
				table.insert(plantdropbase, { items = {plant.drop_else.name .. " " .. plant.drop_else.count }})
				table.insert(plantdropplus, { items = {plant.drop_else.name .. " " .. plant.drop_else.count + 1 }})
				if plant.drop_else.register then
					minetest.register_craftitem( parentmod .. ":" .. plant.drop_else[i]["name"], {
						description = xhelper.descriptify(plant.drop_else[i]["name"]),
						tiles = { parentmod .. "_" .. plant.drop_else[i]["name"] .. ".png" },
						groups = { xfarm = 1, byproduct = 1 }
					})
				end
			end
		else
			if plant.drop_else then
				minetest.log("drop_else for " .. plant.name .. " is not a table")
				minetest.log("assuming either nil or false as scalar values are not allowed")
			end
		end
		-- small but really important step, make plants dropp all items
		plantdropminus.max_items = #plantdropminus.items
		plantdropbase.max_items = #plantdropbase.items
		plantdropplus.max_items = #plantdropplus.items
		-- ok it wasn't that long, moving on to register last phase three flavours
		
		-- register -1 version
		minetest.register_node(parentmod .. ":"  .. "infra_" .. plant.name .. "_" .. phases, {
			description = xhelper.descriptify(plant.name) .. "_" ..  phases,
			tiles = { parentmod .. "_" .. "infra_" .. plant.name .. "_" .. phases .. ".png" },
			visual_scale = scale,
			groups = plantgroups,
			walkable = false,
			buildable_to = true,
			paramtype = "light",
			drawtype = "plantlike",
			sunlight_propagates = true,
			drop = plantdropminus
		})
		
		-- register nominal version
		minetest.register_node(parentmod .. ":"  .. plant.name .. "_" .. phases, {
			description = xhelper.descriptify(plant.name) .. phases,
			tiles = { parentmod .. "_" .. plant.name .. "_" .. phases .. ".png" },
			visual_scale = scale,
			groups = plantgroups,
			walkable = false,
			buildable_to = true,
			paramtype = "light",
			drawtype = "plantlike",
			sunlight_propagates = true,
			drop = plantdropbase,
			sounds = default.node_sound_leaves_defaults()
		})
				
				-- register  +1 version
		minetest.register_node(parentmod .. ":"  .. "supra_" .. plant.name .. "_" .. phases, {
			description = xhelper.descriptify(plant.name) .. phases,
			tiles = { parentmod .. "_" .. "supra_" .. plant.name .. "_" .. phases .. ".png" },
			visual_scale = scale,
			groups = plantgroups,
			walkable = false,
			buildable_to = true,
			paramtype = "light",
			drawtype = "plantlike",
			sunlight_propagates = true,
			drop = plantdropplus
		})
		
		-- register primary drop item
		if seed_dropper ~= "is_primary" then
			minetest.register_craftitem( primary_node, {
				description = xhelper.descriptify(primary),
				inventory_image = primary_tile
			})
			if seed_dropper == "from_primary" then
				if plant.ivylike then
					minetest.register_craft({
						type = "shapeless",
						output = preseed_seed_node,
						recipe = { primary_node }
					})
					minetest.registerr_craft({
						type = "shapeless",
						output = seed_node,
						recipe = { preseed_node, "xfarm:support_sricks" }
					})
					minetest.register_craftitem(preseed_node, {
						description = descriptify(plant.name, preseed),
						inventory_image = preseed_tile,
						groups = plantgroups
					})
				else
					minetest.register_craft({
						type = "shapeless",
						output = seed_node .. " " .. seed_count,
						recipe = { primary_node }
					})
				end
			end
		end
		-- either register wild version of the plant or add seed drop to grass nodes
		if get_from == "wild" then
			local f = false 
			for k, v in pairs(wild_biomes) do
				for l, m in pairs(minetest.registered_biomes) do
					if k == m.name then
						table.insert(top_nodes, v.top_node)
						break
					end
				end
			end
			wild = "wild_" .. plant.name
			wild_tile = parentmod .. "_" .. wild .. ".png"
			wild_node = parentmod .. ":" .. wild
			minetest.register_node(wild_node, {
				description = xhelper.descriptify(wild),
				tiles = { wild_tile },
				walkable = false,
				buildable_to = true,
				paramtype = "light",
				sounds = default.node_sound_leaves_defaults(),
				drawtype = "plantlike",
				sunlight_propagates = true,
				drop = plantdropplus
			})
			-- register the actual decoration
			minetest.register_decoration({
				name = wild_node,
				deco_type = "simple",
				place_on = top_nodes,
				sidelen = 16,
				noise_params = {
					offset = 0,
					scale = 0.007,
					spread = {x = 100, y = 100, z = 100},
					seed = 840405,
					octaves = 3,
					persist = 0.6
				},
				y_max = 30,
				y_min = 1,
				decoration = wild_node
			})
		else
			table.insert(grassdrop.items, { items = seed_node, rarity = 10 })
		end
	else
		minetest.log("Plant registration aborted")
		minetest.log("Fatal error")
	end
end
		
		
		
		
		
	 