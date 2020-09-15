xcolver= 1

xcolor = {}

colors = {
	def = {
		black = "0x000000",
		navy = "0x000080",
		blue = "0x0000FF",
		green = "0x008000",
		teal = "0x008080",
		dodger_blue = "0x0080FF",
		green = "0x00FF00",
		spring_green = "0x00FF80",
		aqua = "0x00FFFF",
		maroon = "0x800000",
		purple = "0x800080",
		electric_indigo = "0x8000FF",
		olive = "0x808000",
		gray = "0x808080",
		light_slate_blue = "0x8080FF",
		chartreuse = "0x80FF00",
		light_green = "0x80FF80",
		electric_blue = "0x80FFFF",
		red = "0xFF0000",
		deep_pink = "0xFF0080",
		fuchsia = "0xFF00FF",
		dark_orange = "0xFF8000",
		light_coral = "0xFF8080",
		pink = "0xFF80FF",
		yellow = "0xFFFF00",
		haze = "0xFFFF80",
		white = "0xFFFFFF"
	},
	basic = {
		"black",
		"white",
		"red",
		"green",
		"blue"
	},
	derived = {
		"navy",
		"teal",
		"dodger_blue",
		"spring_green",
		"aqua",
		"maroon",
		"purple",
		"electric_indigo",
		"olive",
		"gray",
		"light_slate_blue",
		"chartreuse",
		"light_green",
		"electric_blue",
		"deep_pink",
		"fuchsia",
		"dark_orange",
		"light_coral",
		"pink",
		"yellow",
		"haze"
	}
}

-- register white wool
		
xcolor.register_xdyes = function(colors)
	local k = ""
	local v = ""
	for k, v in pairs(colors.basic) do
		xcolor.register_basic_dye(v,colors.def[v])
	end
	for k, v in pairs(colors.derived) do
		xcolor.register_derived_dye(v, colors.def[v])
	end
	xcolor.register_aditional_crafts()
end

xcolor.register_basic_dye = function(cname, hexcol)
	local dyerec = {}
	local dyename = "xpand:" .. cname .. "_dye"
	local needrec = true
	minetest.register_craftitem( dyename, {
		description = xhelper.descriptify(cname) .. " Dye",
		inventory_image = "xpand_dye_base.png",
		inventory_overlay = { name = "xpand_dye_base.png", color = hexcol },
	})
	if cname == "black" then 
		table.insert(dyerec, "default:coal")
	elseif cname == "red" then
		table.insert(dyerec, "flowers:rose")
	elseif cname == "green" then
		table.insert(dyerec, "flowers:green_chrysanthemum_green")
	elseif cname == "blue" then
		table.insert(dyerec, "flowers:geranium_blue")
	elseif cname ==  "white" then 
		table.insert(dyerec, "flowers:dandelion_white")
		needrec = false
	else
		minetest.log("something went awfully wrong in xcolors.register_basic_dye")
		minetest.log("cname=" .. cname .. ", hexcol=" .. hexcol)
	end
	minetest.register_craft({
		type = "shapeless",
		output = dyename,
		recipe = dyerec
	})
	if needrec then
		xcolor.register_dyed_stuff(cname, hexcol)
	end
end

xcolor.register_derived_dye = function(cname, hexcol)
-- initialize vars
	local rq = string.sub(hexcol, 3, 4)
	local gq = string.sub(hexcol, 5, 6)
	local bq = string.sub(hexcol, 7, 8)
	local dyerec = {}
	local dyename = "xpand:" .. cname .. "_dye"
-- register due as craftitem
	local nucol = string.sub(hexcol, 3,8)
	minetest.register_craftitem( dyename, {
		description = xhelper.descriptify(cname) .. " Dye",
		inventory_image = "xpand_dye_base.png^[multiply:#" .. nucol,
	})
-- split color number into r, g, b, calculate proper amount of each basic dye for crafting recipe
	if rq == "FF" then
			table.insert(dyerec, "xpand:red_dye")
			table.insert(dyerec, "xpand:red_dye")
		elseif rq == "80" then
			table.insert(dyerec, "xpand:red_dye")
		end
		if gq == "FF" then
			table.insert(dyerec, "xpand:green_dye")
			table.insert(dyerec, "xpand:green_dye")
		elseif gq == "80" then
			table.insert(dyerec, "xpand:green_dye")
		end
		if bq == "FF" then
			table.insert(dyerec, "xpand:blue_dye")
			table.insert(dyerec, "xpand:blue_dye")
		elseif rq == "80" then
			table.insert(dyerec, "xpand:blue_dye")
		end
-- register the actual craft
		minetest.register_craft({
			type = "shapeless",
			output = dyename,
			recipe = dyerec
		})
		xcolor.register_dyed_stuff(cname, hexcol)
end

xcolor.register_dyed_stuff = function(cname, hexcol)
	local plasticname = "xpand:pvc_" .. cname
	local woolname = "xpand:wool_" .. cname
	local dyename = "xpand:" .. cname .. "_dye"
-- register pvc and wool blocks
	minetest.register_node(plasticname, {
		description = xhelper.descriptify(cname) .. " PVC",
		tiles = { "xpand_pvc.png" },
		overlay_tiles = { { name = "xpand_pvc.png", color = hexcol } },
		groups = { choppy = 3, cracky = 3, oddly_breakable_by_hand = 2, pvc = 1}
	})
	
	minetest.register_node(woolname, {
		description = xhelper.descriptify(cname) .. " Wool",
		tiles = { "wool_white.png" },
		overlay_tiles = { { name = "wool_white.png", color = hexcol } },
		groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3, wool = 1},
		sounds = default.node_sound_defaults(),
	})
-- register crafts fir pvc and wool
local fullrec = { "xpand:pvc_white", dyename }
	minetest.register_craft({
		type = "shapeless",
		output = plasticname,
		recipe = fullrec
		--recipe = { "xpand:pvc_white", dyename }
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = woolname,
		recipe = { "xpand:wool_white", dyename }
	})
end

xcolor.register_aditional_crafts = function()
return nil
end

xcolor.register_xdyes(colors)

