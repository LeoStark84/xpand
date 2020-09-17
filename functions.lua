xhelper = {}
-- checks if a value is defined, if it is it returns it unchabged, if it is nit, returns the given default value
xhelper.def_or_def = function(var, vartype, valid_range, defaultvalue)
	local retval = false
	if type(var) == vartype then
		if vartype == "table" then
			if valid_range then
				retval = var
			elseif var ~= {} then
				retval = var
			else
				retval = defaultvalue
			end
		elseif vartype == "string" then
			if type(valid_range) == "table" then
				if xhelper.is_in_table(var, valid_range) then
					retval = var
				else
					retval = default
				end
			elseif var ~= "" then
				retval = var
			elseif valid_range then
				retval = var
			else
				retval = defaultvalue
			end
		elseif vartype == "number" then
			if type(valid_range) == "table" then
				if (var >= valid_range.min) and (var <= valid_range.max) then
					retval = var
				else
					retval = defaultvalue
				end
			elseif var > 0 then
				retval = var
			else
				retval = defaultvalue
			end
		else
			minetest.log("Something went wrong in xhelper")
			minetest.log("def_or_def does not ecaluate boolean or nil type values")
		end
	else
		var = defaultvalue
	end
	return retval
end



-- returns the key where a given value is stored in a table,or false if it's not
-- param#1   the atring to be searched
-- param#2   the table to search in
-- [param#3] a prefix to concat at the beginning of param#1 string prior to the actual search
-- [param#4] a suffix to concat at the end of param#1 string prior to the actual search
--
-- t = { a="a lot of berries",b="a lot of tomatoes",c="a few berries",d="a few tomatoes"}
-- xhelper("berries",t,"a lot of",nil)
--
-- returns "a"
xhelper.is_in_table = function(string, table, spref, ssuf, tpref, tsuf)
	if spref == nil then spref = "" end
	if ssuf == nil then ssuf = "" end
	if tpref == nil then tpref = "" end
	if tsuf == nil then tsuf = "" end
	local retval = false
	for k, v in pairs(table) do
		if spref .. string .. ssuf == tpref .. v .. tsuf then
			retval = k
		end
	end
	return retval
end

-- takes one or two strings, replaces all underscores ("_") for empty spaces (" "), then capitalize (a->A) the first letter of every word. if two strings are provided, it returns them concatenated, if only one argument is prkvided concatenarion is ignored 
xhelper.descriptify = function(string_one, string_two)
	if string_two ~= nil then
		return ((string_one:gsub("_", " ") .. " " .. string_two:gsub("_", " ")):gsub("^%l", string.upper)):gsub("%A%l", string.upper)
	else
		return ((string_one:gsub("_", " ")):gsub("^%l", string.upper)):gsub("%A%l", string.upper)
	end
end

-- places a node oriented in x and z axis relative to the player
-- param#1 player's usertable
-- param#2 {x,y,z} style coordinates to place the node
-- param#3 name of the node to placd
xhelper.set_oriented_node = function(who, where, what)
	local lookang = math.deg(who.get_look_horizontal(who))
	local dir = 0
	if lookang > 315 or lookang <= 45 then
		dir = 0
	elseif lookang > 45 and lookang <= 135 then
		dir = 3
	elseif lookang >135 and lookang <= 225 then
		dir = 2
	elseif lookang > 225 and lookang <= 315 then
		dir = 1
	else
		minetest.log("The looking angle is over or less a full circle: " .. lookang .. "°")
	end
	minetest.set_node(where, { name = what, param2 = dir })
end

xhelper.yaw_to_param2 = function(who)
local lookang = math.deg(who.get_look_horizontal(who))
	local dir = 0
	if lookang > 315 or lookang <= 45 then
		dir = 0
	elseif lookang > 45 and lookang <= 135 then
		dir = 3
	elseif lookang >135 and lookang <= 225 then
		dir = 2
	elseif lookang > 225 and lookang <= 315 then
		dir = 1
	else
		minetest.log("The looking angle is over or less a full circle: " .. lookang .. "°")
	end
	return dir
end

xhelper.get_four_sides = function(pos)
	local left = { x = pos.x - 1, y = pos.y, z = pos.z }
	local right = { x = pos.x + 1, y = pos.y, z = pos.z }
	local front = { x = pos.x, y = pos.y, z = pos.z - 1 }
	local back = { x = pos.x, y = pos.y, z = pos.z + 1 }
	return left, right, front, back
end


xhelper.purge = function()
	return nil
end

xhelper.if_nearby = function(pos, radius, nodenear, nodetrue, nodefalse)
	local retval = false
	local neartab = minetest.find_node_near(pos, radius, nodenear)
	if type(neartab) ~= "nil" then
		retval = nodetrue
	else
		retval = nodefalse
	end
	return retval
end
-- unregisters every minetest game item that's already registered by this mod
-- so far only dyes and wools are deleted
-- but not stairs
xhelper.kill_redundance = function()
	minetest.unregister_item("wool:white")
	minetest.unregister_item("dye:white")
end