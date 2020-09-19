xnodever = 4
xnodestatus = "beta"
modules = modules + 1
minetest.log("xnode ver " .. xnodever .. " " .. xnodestatus)
xnode = {}

-- takes a nodebox definition as argument and returns it's volume in voxels
xnode.get_volume = function(box_def)
	local volume = 0
	for k, v in pairs(box_def) do
		volume = volume + math.abs(((v[4] - v[1]) * (v[5] - v[2]) * (v[6] - v[3])))
	end
	return volume
end

-- takes a material's burn tjme and the volume of a model as arguments. Returns the burning time of the new node based on it's volume.
xnode.get_flammability = function(base_flammability, vol)
	return base_flammability * vol
end

-- takes a recipe mask as arg and returns the number of nodes that recipe uses
xnode.get_recipe_amount = function(recipe_grid)
	local nodes_amount = 0
	for i = 1, 3 do
		for j = 1, 3 do
			if recipe_grid[i][j] == true then
				nodes_amount = nodes_amount + 1
			end
		end
	end
	return nodes_amount
end

--it should return how many new nodes a crafting recipe should give, based on the amount of base nodes jt uses (arg 1) and the volume of the new node (arg 2). but Ijust can't fifure out how to do it.
function get_do_amount(rec_amount, nnvol)
	return math.floor(rec_amount / nnvol)
end

function get_undo_amount(undorec_amount, nnvol)
	return math.floor(undorec_amount * nnvol)
end

xnode.register_xnode = function(parentmod, material, model)
	local newnodename = parentmod .. ":" .. material.name .. "_" .. model.name
	local nugroups = material.gr
	for k, v in pairs(model.gr) do
		nugroups[k] = v
	end
	local node_volume = xnode.get_volume(model.box)
	local do_recipe_amount = xnode.get_recipe_amount(model.dogrid)
	-- start node registration
	minetest.register_node( newnodename, {
		--description = (material.name:gsub("^%l", string.upper) .. " " .. model.name:gsub("^%l", string.upper)):gsub("_", " "),
		-- description = (material.name:gsub("_", " ") .. " " .. model.name:gsub("_", " ")):gsub("^%l", string.upper),
		--description = (material.name:gsub("_", " ")):gsub("^%l", string.upper) .. " " .. (model.name:gsub("_", " ")):gsub("^%l", string.upper),
		-- description = (((material.name:gsub("_", " ") .. " " .. model.name:gsub("_", " ")):gsub("^%l", string.upper)):gsub("%A%l", string.upper)),
		description = xhelper.descriptify(material.name, model.name),
		groups = nugroups,
		tiles = material.texture,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = model.box
		},
		sounds = material.soundset,
		on_place = minetest.rotate_node
	})
	
	local tempgrid = {
		[1] = {},
		[2] = {},
		[3] = {}
	}
	local do_recipe_amount = 0
	for i  = 1,3 do
		for j = 1,3 do
			if model.dogrid[i][j] == true then
				tempgrid[i][j] = material.crafter
				do_recipe_amount = do_recipe_amount + 1
			else
				tempgrid[i][j] = ""
			end
		end
	end
	
	minetest.register_craft({
		type = "shaped",
		output = newnodename .. " " .. get_do_amount(do_recipe_amount, node_volume),
		recipe = tempgrid
	})
	
	if material.flammability  > 0 then
		minetest.register_craft({
			type = "fuel",
			recipe = newnodename,
			burntime = xnode.get_flammability(material.flammability, node_volume)
		})
	end
	
	if model.undogrid ~= nil then
		local undo_recipe_amount = 0
		for i  = 1,3 do
			for j = 1,3 do
				if model.undogrid[i][j] == true then
					tempgrid[i][j] = newnodename
					undo_recipe_amount = undo_recipe_amount + 1
				else
					tempgrid[i][j] = ""
				end
			end
		end
		local recout = material.crafter .. " " .. get_undo_amount(undo_recipe_amount, node_volume)
		minetest.register_craft({
			type = "shaped",
			output = recout,
			recipe = tempgrid
		})
	end
end

xnode.register_material_base = function(parentmod, material)
	local base_name = parentmod .. ":" .. material.name
	minetest.register_node( base_name, {
		description = xhelper.descriptify(material.name),
		tiles = material.texture,
		groups = material.gr,
		sounds = material.soundset
	})
	
	material.crafter = base_name
	
	if material.flammability > 0 then
		minetest.register_craft({
			type = "fuel",
			recipe = base_name,
			burntime = material.flammability
		})
	end
	return base_name
end

xnode.register_non_redundant_models = function(parentmod, material)
	local k = 0
	local v = 0
	for k, v in pairs(models.nonredundant) do
		xnode.register_xnode(parentmod, material, v)
	end
end

xnode.register_redundant_models = function(parentmod, material)
	local k = 0
	local v = 0
	for k, v in pairs(models.redundant) do
		xnode.register_xnode(parentmod, material, v)
	end
end

xnode.register_all_models = function(parentmod, material)
	xnode.register_non_redundant_models(parentmod, material)
	xnode.register_redundant_models(parentmod, material)
end
