-- minetest expansion (Leo DLC 1)
-- by LeoStark84 (leandroortenzi@gmail.com)
-- Additional graphics by Andrei Trifon
-- Beta testing by Luis Ortenzi and Andrei Trifon
-- minetest expansion, expanding vanilla game to the proper places
--
-- Quick directions
--
-- API is split into aeveral parts
-- nodeboxes API is in xnode.lua
-- farming API is in xfarm.lua
-- dyes, wool and PVC API is in xcolor.lua
-- additional functions in functions.lua (everything xhelper is here)
xpand = {}
local modpath = minetest.get_modpath("xpand")
local thismod = minetest.get_current_modname()
modules = 0

-- xhelper module
dofile(modpath .. "/functions.lua")
-- xnode module
dofile(modpath .. "/models.lua")
dofile(modpath .. "/materials.lua")
dofile(modpath .. "/xnode.lua")
-- xfarm module
dofile(modpath .. "/plants.lua")
dofile(modpath .. "/xfarm.lua")
-- xcolor module
dofile(modpath .. "/xcolor.lua")
-- mapgen stuff
dofile(modpath .. "/oresreg.lua")
minetest.log("xpand ver " .. modules .. "." .. (xfarmver + xnodever + xcolver + xhelperver) / modules)

xpand.register_xnode_all = function(tm, materials, models)
	for k, v in pairs(materials.nonredundant) do
		if (v.crafter == nil) or (v.crafter == "") then
			xnode.register_material_base(tm, v)
		end
		xnode.register_all_models(tm, v)
	end
	for k, v in pairs(materials.redundant) do
		xnode.register_non_redundant_models(tm, v)
	end
end

xpand.register_xnode_all(thismod, materials, models)

-- MATERIAL / MODEL REGISTRATION END
models = xhelper.purge()
materials = xhelper.purge()

xfarm.register_all_plants(thismod, plants)
plants = xhelper.purge()



minetest.register_node( "xpand:stone_with_luciferite", {
	description = "Stone with Luciferite",
	tiles = { "default_stone.png^xpand_luciferite_ore.png" },
	groups = { cracky = 3 },
	light_source = 3,
	drop = "xpand:luciferite_powder",
})

minetest.register_craftitem( "xpand:luciferite_powder", {
	description = "Luciferite Powder",
	inventory_image = "xpand_luciferite_powder.png",
})

minetest.register_craft({
	type = "shaped",
	output = "xpand:luciferite_bottle",
	recipe = {
		{ "xpand:luciferite_powder" },
		{ "vessels:glass_bottle" }
	}
})

minetest.register_node("xpand:stone_with_silver", {
	description = "Stone with Silver",
	tiles = { "default_stone.png^xpand_silver_ore.png" },
	groups = { cracky = 3 },
	drop = "xpand:silver_lump",
})
	
minetest.register_node("xpand:stone_with_aluminum", {
  description = "Stone with Aluminum", 
  tiles = { "default_stone.png^xpand_aluminum_ore.png" }, 
  groups = { cracky = 2 },
  drop = "xpand:aluminum_lump",
})

minetest.register_craftitem("xpand:aluminum_lump", {
  description = "Aluminum Lump",
  inventory_image = "xpand_aluminum_lump.png"
})

minetest.register_craft({
  type = "cooking",
  output = "xpand:aluminum_ingot",
  recipe = "xpand:aluminum_lump",
  cooktime = 5,
})

minetest.register_craftitem("xpand:aluminum_ingot", {
  description = "Aluminum Ingot",
 inventory_image = "xpand_aluminum_ingot.png",
})

minetest.register_node("xpand:stone_with_lead", {
  description = "Stone with Lead",
  tiles = { "default_stone.png^xpand_lead_ore.png" },
  groups = { cracky = 2},
  drop = "xpand:lead_lump",
})

minetest.register_craftitem("xpand:lead_lump", {
  description = "Lead Lump", 
  inventory_image = "xpand_lead_lump.png",
})

minetest.register_craft({
  type = "cooking",
  output = "xpand:lead_ingot",
  recipe = "xpand:lead_lump",
  cooktime = 3,
})

minetest.register_craftitem("xpand:lead_ingot", {
  description = "Lead Ingot",
  inventory_image = "xpand_lead_ingot.png",
})

minetest.register_node("xpand:stone_with_emerald", {
  description = "Stone with Emerald",
  tiles = { "default_stone.png^xpand_emerald_ore.png" },
  groups = { cracky = 2 },
  drop = "xpand:emerald",
})

minetest.register_craftitem("xpand:emerald", {
  description = "Emerald",
  inventory_image = "xpand_emerald.png",
  use_texture_alpha = true
})

minetest.register_node("xpand:stone_with_topaz", {
  description = "Stone with Topaz", 
  tiles = { "default_stone.png^xpand_topaz_ore.png"},
  groups = { cracky = 2 },
  drop = "xpand:topaz",
})

minetest.register_craftitem("xpand:topaz", {
  description = "Topaz", 
  inventory_image = "xpand_topaz.png", 
  groups = { gems = 1 }
})

minetest.register_node("xpand:stone_with_amethyst", {
  description = "Stone with Amethyst", 
  tiles = { "default_stone.png^xpand_amethyst_ore.png" },
  groups = { cracky = 2 },
  drop = "xpand:amethyst",
})

minetest.register_craftitem("xpand:amethyst", {
  description = "Amethyst",
  inventory_image = "xpand_amethyst.png",
  groups = { gems = 1 }
})

minetest.register_node("xpand:stone_with_sapphire", {
  description = "Stone with Sapphire",
  tiles = { "default_stone.png^xpand_sapphire_ore.png" },
  groups = { cracky = 2 },
  drop = "xpand:sapphire",
})

minetest.register_craftitem("xpand:sapphire", {
  description = "Sapphire",
  inventory_image = "xpand_sapphire.png",
  groups = { gems = 1 }
})

minetest.register_node("xpand:stone_with_ruby", {
  description = "Stone with Ruby", 
  tiles = { "default_stone.png^xpand_ruby_ore.png" },
  groups = { cracky = 2 },
  drop = "xpand:ruby",
})

minetest.register_craftitem("xpand:ruby", {
  description = "Ruby",
  inventory_image = "xpand_ruby.png",
  groups = { gems = 1 }
})



minetest.register_craft({
  type = "shaped",
  output = "xpand:aluminum_block",
  recipe = {
    {
      "xpand:aluminum_ingot",
      "xpand:aluminum_ingot",
      "xpand:aluminum_ingot"
    },
    {
      "xpand:aluminum_ingot",
      "xpand:aluminum_ingot",
      "xpand:aluminum_ingot"
    },
    {
      "xpand:aluminum_ingot",
      "xpand:aluminum_ingot",
      "xpand:aluminum_ingot"
    }
 }
})

minetest.register_node("xpand:aluminum_block", {
  description = "Aluminum Block",
  tiles = { "xpand_aluminum_block.png" },
  groups = { cracky = 2 },
})

minetest.register_craft({
  type = "shaped",
  output = "xpand:lead_block", 
  recipe = {
    {
      "xpand:lead_ingot",
      "xpand:lead_ingot",
      "xpand:lead_ingot"
    },
    {
      "xpand:lead_ingot",
      "xpand:lead_ingot",
      "xpand:lead_ingot"
    },
    {
      "xpand:lead_ingot",
      "xpand:lead_ingot",
      "xpand:lead_ingot"
    }
  }
})

minetest.register_node("xpand:lead_block", {
  description = "Lead Block",
  tiles = { "xpand_lead_block.png" },
  groups = { cracky = 2 },
})

minetest.register_node("xpand:stone_with_salt", {
	description = "Stone with Salt",
	tiles = { "default_stone.png^xpand_salt_ore.png" },
	groups = { cracky = 3 },
	drop = "xpand:salt_lump 4",
})

minetest.register_craftitem( "xpand:salt_lump", {
	description = "Salt Lump",
	inventory_image = "xpand_salt_lump.png",
})

minetest.register_node("xpand:oil_source", {
	description = "Oil Source",
	tiles = { "xpand_oil.png" },
	special_tiles = { "xpand_oil.png" },
	groups = { liquid = 3, water = 3 },
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drawtype = "liquid",
	paramtype2 = "flowingliquid",
	liquidtype = "source",
	liquid_range = 8,
	liquid_viscosity = 5,
	liquid_alternative_flowing = "xpand:oil_flowing",
	liquid_alternative_source = "xpand:oil_source",
	liquid_renewable = false,
	drowning = 1,
	waving = 3, -- 3 for flowing
})

minetest.register_node("xpand:oil_flowing", {
	description = "Oil Flowing",
	tiles = { "xpand_oil.png" },
	--special_tiles = { "xpand_oil.png" },
	special_tiles = {
			{
				name = "xpand_oil_flowing.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 6.0,
				},
			},
			{
				name = "xpand_oil_flowing.png",
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 6.0,
				},
			},
		},
	groups = { liquid = 3, water = 3 },
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drawtype = "flowingliquid",
	liquidtype = "flowing",
	paramtype2 = "flowingliquid",
	liquid_viscosity = 5,
	liquid_alternative_source = "xpand:oil_source",
	liquid_alternative_flowing = "xpand:oil_flowing",
	liquid_renewable = false,
	drowning = 1,
	waving = 3, -- 3 for flowing
})

minetest.register_craftitem( "xpand:barrel_empty", {
	description = "Empty Barrel",
	inventory_image = "xpand_empty_barrel.png",
})

minetest.register_craft({
	type = "shaped",
	output = "xpand:barrel_empty",
	recipe = {
		{ "xpand:aluminum_ingot", "xpand:aluminum_ingot", "xpand:aluminum_ingot" },
		{ "xpand:aluminum_ingot", "", "xpand:aluminum_ingot" },
		{ "xpand:aluminum_ingot", "xpand:aluminum_ingot", "xpand:aluminum_ingot" }
	}
})

minetest.register_craftitem("xpand:barrel_oil", {
	description = "Oil Barrel",
	inventory_image = "xpand_full_barrel.png",
})

bucket.register_liquid(
	"xpand:oil_source",
	"xpand:oil_flowing",
	"xpand:bucket_oil",
	"xpand_bucket_oil.png",
	"Oil Bucket",
	{tool = 1 }
)

minetest.register_craft({
	type = "shapeless",
	output = "xpand:barrel_oil",
	recipe = { "xpand:barrel_empty", "xpand:bucket_oil", "xpand:bucket_oil", "xpand:bucket_oil", "xpand:bucket_oil", "xpand:bucket_oil", "xpand:bucket_oil", "xpand:bucket_oil", "xpand:bucket_oil" },
	replacements = {
		{ "xpand:bucket_oil", "bucket:bucket_empty 8" }
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "xpand:barrel_empty",
	recipe = { "xpand:barrel_oil", "bucket:bucket_empty", "bucket:bucket_empty", "bucket:bucket_empty", "bucket:bucket_empty", "bucket:bucket_empty", "bucket:bucket_empty", "bucket:bucket_empty", "bucket:bucket_empty" },
	replacements = {
		{ "bucket:bucket_empty", "xpand:bucket_oil" },
		{ "bucket:bucket_empty", "xpand:bucket_oil" },
		{ "bucket:bucket_empty", "xpand:bucket_oil" },
		{ "bucket:bucket_empty", "xpand:bucket_oil" },
		{ "bucket:bucket_empty", "xpand:bucket_oil" },
		{ "bucket:bucket_empty", "xpand:bucket_oil" },
		{ "bucket:bucket_empty", "xpand:bucket_oil" },
		{ "bucket:bucket_empty", "xpand:bucket_oil" }
	}
})

minetest.register_craftitem( "xpand:salt_block", {
	description = "Salt Block",
	inventory_image = "xpand_salt_block.png",
})

minetest.register_craft({
	type = "shaped",
	output = "xpand:salt_block",
	recipe = {
		{ "xpand:salt_lump", "xpand:salt_lump", "" },
		{ "xpand:salt_lump", "xpand:salt_lump", "" },
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "xpand:pvc_white",
	recipe = { "xpand:barrel_oil", "xpand:salt_block" }
})

minetest.register_node( "xpand:pvc_white", {
	description = "PVC White",
	tiles = { "xpand_pvc.png" },
	groups = { cracky = 3, choppy = 2, plastic= 1 },
})



