xfarmver = 3

xfarm = {}
crop = {}
ditchnodes = { "s", "c", "t", "x" }
point_at = { b = 0, r = 1, f = 2, l = 3 }
local newgrassdrop = {}
newgrassdrop.items = {}






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

xfarm.get_drop_count = function(fertility, nominal_drop_count)
	return nominal_drop_count + ( fertility - 2)
end

xfarm.register_all_plants = function(parentmod, plants)
	for k, v in pairs(plants) do
		xfarm.register_xplant(parentmod, v)
	end
end




-- the big bad-ass function that does all the magic
xfarm.register_xplant = function(parentmod, plant)
	-- big fat initialization of vars
	local abortdef = false
	local seed_name = ""
	local seed_node_name = ""
	local seed_count = 0
	local primary_drop = ""
	local primary_drop_count = 0
	local primary_drop_node_name = ""
	local top_nodes = {}
	-- getting type-specific parameters
	if (type(plant.name) == "string") and (plant.name ~= "") then
		if plant.type == "cereal" then
			if type(plant.cereal) == "table" then
				if plant.cereal.grain_name and (plant.cereal.grain_name ~= "") and (type(plant.cereal.grain_name) == "string") then
					seed_name = plant.name .. "_" .. plant.cereal.grain_name
				else
					seed_name = plant_name .. "_grain"
				end
				if plant.cereal.pod_name and (plant.cereal.pod_name ~= "") and (type(plant.cereal.pod_name) == "string") then
					primary_drop = plant.name .. "_" .. plant.cereal.pod_name
				else
					primary_drop = plant.name .. "_spike"
				end
				if plant.cereal.pod_count and (plant.cereal.pod_count > 0) then
					primary_drop_count = plant.cereal.pod_count
				else
					primary_drop_count = 1
				end
				if plant.cereal.grains_per_pod and plant.cereal.grains_per_pod > 2 then
					seed_count = plant.cereal.grains_per_pod
				else
					seed_count = 2
				end
				seed_node_name = parentmod .. ":" .. seed_name
				primary_drop_node_name = parentmod .. ":" .. primary_drop
				seed_tile_name = parentmod .. "_" .. seed_name .. ".png"
			else
				minetest.log("Something went awfully wrong in xfarm")
				minetest.log(plant.name .. "'s type is \"cereal\", but " .. plant.name ..".cereal is undefined")
				minetest.log(plant.name .. " registration aborted")
			end
		elseif plant.type == "fruit" then
			if type(plant.fruit) == "table" then
				if plant.fruit.name and (plant.fruit.fruit_name ~= "") and (type(plant.fruit.fruit_name) == "string") then
					primary_drop = plant.name .. "_" .. plant.fruit_name
				else
					primary_drop = plant.name
				end
				if plant.fruit.fruit_count and (plant.fruit.fruit_count > 1) then
					primary_drop_count = plant.fruit.fruit_count
				else
					primary_drop_count = 2
				end
				if plant.fruit.seed_count and (plant.fruit.seed_count > 0) then
					seed_count = plant.fruit.seed_count
				else
					seed_count = 1
				end
				if plant.fruit.seed_name and (plant.fruit.seed_name ~= "") and (type(plant.fruit.seed_name) == "string") then
					seed_name = plant.name .. "_" .. plant.fruit.seed_name
				else
					seed_name = plant.name .. "_seeds"
				end
				seed_node_name = parentmod .. ":" .. seed_name
				primary_drop_node_name = parentmod .. ":" .. primary_drop
				seed_tile_name = parentmod .. "_" .. seed_name .. ".png"
			else
				minetest.log("Something went awfully wrong in xfarm")
				minetest.log(plant.name .. "'s type is \"fruit\", but " .. plant.name ..".fruit is undefined")
				minetest.log(plant.name .. " registration aborted")
			end
		elseif plant.type == "tuber" then
			if type(plant.tuber) == "table" then
				if plant.tuber.tubers_name and (plant.tuber.tubers_name ~= "") and (type(plant.tuber.tubers_name) == "string") then
					primary_drop = plant.name .. "_" .. plant..tuber.tubers_name
				else
					primary_drop= plant.name
				end
				if plant.tuber.tubers_count and plant.tuber.tubers_count > 1 then
					primary_drop_count = plant.tuber.tubers_count
				else
					primary_drop_count = 2
				end
				seed_name = primary_drop
				seed_node_name = parentmod .. ":" .. seed_name
				primary_drop_node_name = parentmod .. ":" .. primary_drop
				seed_tile_name = parentmod .. "_" .. plant.name .. "_0.png"
			else
				minetest.log("Something went awfully wrong in xfarm")
				minetest.log(plant.name .. "'s type is \"ruber\", but " .. plant.name ..".tuber is undefined")
				minetest.log(plant.name .. " registration aborted")
			end
		elseif plant.type == "leaf" then
			if type(plant.leaf) == "table" then
				if plant.leaf.leaves_name and (plant.leaf.leaves_name ~= "") and (type(plant.leaf.leaves_name) == "string") then
					primary_drop = plant.name .. "_" .. plant.leaf.leaves_name
				else
					primary_drop = plant.name .. "_leaves"
				end
				if plant.leaf.seed_name and (plant.leaf.seed_name ~= "") and (type(plant.leaf.seed_name) == "string") then
					seed_name = plant.name .. "_" .. plant.leaf.seed_name
				else
					seed_name = plant.name .. "_seeds"
				end
				if plant.leaf.leaves_count and (plant.leaf.leaves_count > 0) then
					primary_drop_count = plant.leaf.leaves_count
				else
					primary_drop_count = 1
				end
				if plant.leaf.seed_count and (plant.leaf.seed_count > 1) then
					seed_count = plant.leaf.seed_count
				else
					seed_count = 2
				end
				seed_node_name = parentmod .. ":" .. seed_name
				primary_drop_node_name = parentmod .. ":" .. primary_drop
				seed_tile_name = parentmod .. "_" .. seed_name .. ".png"
			else
				minetest.log("Something went awfully wrong in xfarm")
				minetest.log(plant.name .. "'s type is \"leaf\", but " .. plant.name ..".leaf is undefined")
				minetest.log(plant.name .. " registration aborted")
			end
		else
			minetest.log("Somerhing went awfully wrong in xfarm")
			minetest.log("while trying to register " .. plant.name)
			minetest.log("Invalid type parameter " .. plant.type .. " plant type not defined")
			abortdef = true
		end
	else
		abortdef = true
		abortdef = trueminetest.log("Something went awfully wrong in xfarm")
		if type(plant.type) == "nil" then
			minetest.log("Plant type undefined")
		else
			minetest.log("Plant name is" .. type(plant.type))
		end
		minetest.log("Plant name must be a (non-empty) string")
	end
	if not abortdef then
		-- register seed
		local gr = { xfarm = 1, snappy = 3, flammable = 1 }
		gr[plant.type] = 1
		minetest.register_node(seed_node_name, {
			description = xhelper.descriptify(seed_name),
			tiles = { seed_tile_name },
			inventory_image = parentmod .. "_" .. seed_name .. ".png",
			groups = gr,
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
					minetest.get_node_timer(pos):start(xfarm.get_phase_timer(fertility, plant.seconds_per_phase))
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
		-- initialize for phases registration
		local phases
		if (plant.phases <= 0) or (plant.phases == nil) or (plant.phases == false) or (plant.phases == "") then
			phases = 1
		else
			phases = plant.phases
		end
		-- and iterate phase registration
		local scale = 1
		if phases > 1 then
			for i = 1, phases - 1 do -- except for last phase
				if plant.tall_phase then
					if (plant.tall_phase > 0) and (plant.tall_phase <= i) then
						scale = 2
					end
				end
				minetest.register_node(parentmod .. ":"  .. plant.name .. "_" .. i, {
					description = xhelper.descriptify(plant.name) .. i,
					tiles = { parentmod .. "_" .. plant.name .. "_" .. i .. ".png" },
					visual_scale = scale,
					inventory_image = parentmod .. "_" .. plant.name .. "_" .. i .. ".png",
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
							minetest.set_node(pos, { name = parentmod .. ":" .. plant.name .. "_" .. i + 1})
						else
							minetest.remove_node(pos)
						end
					end
				})
			end
		end
		-- initialize for last phase
		if plant.tall_phase then
			if (plant.tall_phase > 0) and (plant.tall_phase <= phases) then
				scale = 2
			end
		end
		local plantdrop = {}
		plantdrop.items = {}
		-- put drop on a table
		local primary_drop_node = parentmod .. ":" .. primary_drop
		table.insert(plantdrop.items, { items = { primary_drop_node .. " " .. primary_drop_count } } )
		if plant.type == "leaf" then
			table.insert(plantdrop.items, { items = { seed_node_name .. " " .. seed_count } } )
		end
		if plant.drop_else and (plant.drop_else ~= "") and (type(plant.drop_else) == "string") then
			local drop_else_node_name = parentmod .. ":" .. plant.drop_else
			local drop_else_flag = true
			if plant.drop_else_count and (plant.drop_else_count > 0) then
				table.insert(plantdrop.items, { items = { drop_else_node_name .. " " .. plant.drop_else_count } } )
			else
				table.insert(plantdrop.items, { items = { drop_else_node_name } } )
			end
		end
		plantdrop.max_items = #plantdrop.items
		-- register last phase
		minetest.register_node(parentmod .. ":"  .. plant.name .. "_" .. plant.phases, {
			description = xhelper.descriptify(plant.name) .. " phase " .. plant.phases,
			tiles = { parentmod .. "_" .. plant.name .. "_" .. plant.phases .. ".png" },
			visual_scale = scale,
			inventory_image = parentmod .. "_" .. plant.name .. "_" .. plant.phases .. ".png",
			groups = gr,
			walkable = false,
			buildable_to = true,
			paramtype = "light" ,
			drawtype = "plantlike",
			sounds = default.node_sound_leaves_defaults(),
			sunlight_propagates = true,
			drop = plantdrop
		})
		-- whew... primary drop registration
		if plant.type ~= "tuber" then -- tybers primary drop was already registered as node, along with seeds
			minetest.register_craftitem( primary_drop_node_name, {
				description = xhelper.descriptify(primary_drop),
				inventory_image = parentmod .. "_" .. primary_drop .. ".png",
			})
			--register seed craft
			if plant.type ~= "leaf" then -- but not for leaf type because they are gotten from the plant itself
				minetest.register_craft({
					type = "shapeless",
					output = seed_node_name,
					recipe = { primary_drop_node_name }
				})
			end
		end
		-- register wild plants
		if plant.first_seed == "wild" then
			local wild_name = "wild_" .. plant.name
			minetest.register_node( parentmod .. ":" .. wild_name, {
				description = xhelper.descriptify(wild_name),
				tiles = { parentmod .. "_" .. wild_name .. ".png" },
				paramtype = "light",
				drawtype = "plantlike",
				sunlight_propagates = true,
				walkable = false,
				buildable_to = true,
				drop = seed_node_name
			})
			-- get the top node of every registered biome
			if not top_nodes then
				for k, v in pairs(minetest.registered_biomes) do
					top_nodes[k] = v.node_top
				end
			end
			-- register wild for every biome
			minetest.register_decoration({
				name = parentmod .. ":" .. wild_name,
				deco_type = "simple",
				place_on = top_nodes,
				sidelen = 16,
				noise_params = {
					offset = -0.1,
					scale = 0.1,
					spread = {x = 50, y = 50, z = 50},
					seed = 840405,
					octaves = 3,
					persist = 0.7
				},
				biomes = plant.wild.biomes,
				y_max = 31000,
				y_min = 1,
				decoration = parentmod .. ":" .. wild_name
			})
		else
		-- if below is single line if-then-end statement
			if plant.first_seed ~= "grass" then minetest.log("first seed undefined or not properly defined " .. plant.first_seed) end
			table.insert(newgrassdrop.items, { items = { seed_node_name }, rarity = 8 })
		end
	end
end

xfarm.set_grass_drop = function(nudrop)
	for i = 1, 5 do
		minetest.override_item( "default:grass_" .. i, {
			drop = nudrop
		})
	end
end









