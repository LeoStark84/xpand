minetest.register_node("xpand:quebracho_trunk", {
  description = "Quebracho Tree Trunk",
  tiles = { "xpand_quebracho_trunk_top.png", "xpand_quebracho_trunk_top.png", "xpand_quebracho_trunk_sides.png" },
  groups = { choppy = 1 },
})

minetest.register_node( "xpand:quebracho_leaves", {
  description = "Quebracho Tree Leaves",
  tiles = { "xpand_quebracho_leaves.png" },
  groups = { oddly_breakable_by_hand = 3, snappy = 3, leaves = 1},
  drawtype = "allfaces_optional",
  paramtype = "light",
})

local quebracho_tree = {
   axiom = "A", 
   rules_a = "B",
   rules_b = "T",
    trunk = "xpand:quebracho_trunk",
    leaves = "xpand:quebracho_leaves",
    angle = 45,
    iterations = 1,
    random_level = 0,
    trunk_type = "single", 
    thin_branches = true,
} 


core.register_chatcommand("spawn_q", { 	params = "", description = "Spawns tree at player position", 	func = function(name, param) 		local pos = minetest.get_player_by_name(name):getpos() 		minetest.chat_send_player(name, "Spawning tree at " .. minetest.pos_to_string(pos) 			.. ", please wait") 		minetest.spawn_tree(pos, quebracho_tree) 		return true, "successfully spawned" 	end, })
core.register_chatcommand("spawn_o", { 	params = "", description = "Spawns tree at player position", 	func = function(name, param) 		local pos = minetest.get_player_by_name(name):getpos() 		minetest.chat_send_player(name, "Spawning tree at " .. minetest.pos_to_string(pos) 			.. ", please wait") 		minetest.spawn_tree(pos, oak_tree) 		return true, "successfully spawned" 	end, })

minetest.register_node( "xpand:oak_trunk", {
	description = "Oak Tree Trunk",
	tiles = { "xpand_oak_trunk_tb.png", "xpand_oak_trunk_tb.png", "xpand_oak_trunk_sides.png" },
	groups = { choppy = 2, flammable = 1, trunk = 1 },
})

minetest.register_node( "xpand:oak_leaves", {
	description = "Oak Tree Leaves",
	tiles = { "xpand_oak_leaves.png" },
	groups = { snappy = 3, leaves = 1 },
	drawtype = "allfaces",
	paramtype = "light",
	drop = {
		max_items = 2,
		items = {
			{
				rarity = 8,
				items = { "xpand:oak_sapling" }
			},
			{
				rarity = 1,
				items = { "xpand:oak_leaves" }
			}
		}
	}
})

minetest.register_node( "xpand:oak_sapling", {
	description = "Oak Tree Sapling",
	inventory_image = "xpand_oak_sapling.png",
	drawtype = "plantlike",
	walkable = false,
	groups = { snappy = 3, oddly_breakable_by_hand = 1 }
})

oak_tree={
	axiom="FFFFFFA",
	rules_a="[&FFBFA]////[&BFFFA]////[&FBFFA]",
	rules_b="[&FFFA]////[&FFFA]////[&FFFA]",
	trunk="xpand:oak_trunk",
	leaves="xpand:oak_leaves",
	angle=30,
	iterations=5,
	random_level=2,
	trunk_type="crossed",
	thin_branches=false,
	--fruit="moretrees:acorn",
	--fruit_chance=3,
}

minetest.register_node( "xpand:grassland_dirt_with_truffle", {
	description = "Dirt with Truffle",
	tiles = {
		"default_grass.png",
		"default_dirt.png",
		{ name = "default_dirt.png^xpand_truffle.png^default_grass_side.png", tileable_vertical = false}
	},
	groups = { crumbly = 2 },
	drop = {
		max_items = 2,
		items= {
			{
				rarity = 1,
				items = { "xpand:truffle" }
			},
			{
				rarity = 1,
				items = {  "default:dirt" }
			}
		}
	}
})

minetest.register_node( "xpand:dirt_with_truffle", {
	description = "Dirt with Truffle",
	tiles = {
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png^xpand_truffle.png"
	},
	groups = { crumbly = 2 },
	drop = {
		max_items = 2,
		items= {
			{
				rarity = 1,
				items = { "xpand:truffle" }
			},
			{
				rarity = 1,
				items = {  "default:dirt" }
			}
		}
	}
})

minetest.register_lbm({
	label = "Truffle LBM",
	name = "xpand:truffle_lbm",
	nodenames = { "group:dirt" },
	run_at_every_load = true,
	action = function(pos, node)
		if minetest.find_node_near(pos, 2, "xpand:oak_trunk") ~= nil then
			minetest.get_node_timer(pos).start(30)
		end
	end
})

minetest.override_item("default:dirt", {
	on_construct = function(pos)
		if minetest.find_node_near(pos, 2, "xpand:oak_trunk") ~= nil then
			minetest.get_node_timer(pos):start(30)
		end
	end,
	on_timer = function(pos)
		local temp = math.random()
		if temp > 0.85 then
			minetest.set_node(pos, { name = "xpand:dirt_with_truffle"})
		end
		return false
	end
})

minetest.register_craftitem("xpand:truffle", {
	description = "Black Truffle",
	inventory_image = "xpand_truffle.png"
})

minetest.register_craft({
	type = "shaped",
	output = "xpand:bottle_truffle_oil",
	recipe = {
		{ "xpand:truffle", "xpand:truffle", "xpand:truffle" },
		{ "", "vessels:glass_bottle", "" },
		{ "", "", "" }
	}
})

minetest.register_craftitem( "xpand:bottle_truffle_oil", {
	description = "Truffle Oil Bottle",
	inventory_image = "xpand_bottle_truffle.png"
})





farming.register_plant("xpand:potato", {
    description = "Potato Seed",
	inventory_image = "xpand_potato_seed.png",
	steps = 3,
	minlight = 8,
	maxlight = 20,
	fertility = {"grassland", "desert"}
})

minetest.override_item( "xpand:potato_3", {
	drop = "xpand:potato",
})

minetest.register_craftitem("xpand:potato", {
	description = "Potato",
	inventory_image = "xpand_potato.png",
	groups = { food = 2, },
	on_use = minetest.item_eat(0),
})

minetest.register_craftitem ("xpand:peeled_potato", {
  description = "Peeled Potato",
  inventory_image = "xpand_peeled_potato.png",
groups = { food = 2,},
on_use = minetest.item_eat(0),
})

minetest.register_craftitem ( "xpand:baked_potato", {
  description = "Baked Potato", 
  inventory_image = "xpand_baked_potato.png",
  groups = {food = 4 }, 
  on_use = minetest.item_eat(2), 
}) 

minetest.register_craft({
  type = "shapeless", 
  output = "xpand:seed_potato 3",
  recipe = { "xpand:potato" },
  replacements = {
    {"xpand:potato", "xpand:peeled_potato"}
  }
})

minetest.register_craft ({
  type = "cooking", 
  output = "xpand:baked_potato",
  recipe = "xpand:peeled_potato", 
  cooktime = 3,
}) 

farming.register_plant("xpand:tomato", {
	description = "Tomato Seed",
	inventory_image = "xpand_tomato_seed.png",
	groups = { food = 4 },
	steps = 4,
	minlight = 8,
	maxlight = 14,
	fertility = { "grassland" }
})

minetest.override_item( "xpand:tomato_4", {
	drop = "xpand:tomato 3",
})

minetest.register_craftitem( "xpand:tomato", {
	description = "Tomato",
	inventory_image = "xpand_tomato.png",
	groups = { food = 2 },
	on_use = minetest.item_eat(1)
})

minetest.register_craft({
	type = "shapeless",
	output = "xpand:seed_tomato",
	recipe = { "xpand:tomato" }
})

farming.register_plant("xpand:corn", {
	description = "Corn Grains",
	inventory_image = "xpand_corn_seed.png",
	groups = { food = 4 },
	steps = 4,
	minlight = 8,
	maxlight = 14,
	fertility = { "grassland" }
})

minetest.override_item( "xpand:corn_3", {
	visual_scale = 1.9
})


minetest.override_item("xpand:corn_4", {
	drop = "xpand:corn 2",
	visual_scale = 1.9
})

minetest.register_craftitem( "xpand:corn", {
	description = "Corn",
	inventory_image = "xpand_corn.png",
	groups = { food = 4 },
	on_use = minetest.item_eat(0)
})

minetest.register_craft({
	type = "shapeless",
	output = "xpand:seed_corn 8",
	recipe = { "xpand:corn" }
})

farming.register_plant( "xpand:lentil", {
	description = "Lentil Seed",
	inventory_image = "xpand_lentil_seed.png",
	steps = 4,
	minlight = 8,
	maxlight = 14,
	fertility = { "grassland" }
})

minetest.override_item( "xpand:lentil_4", {
	drop = "xpand:lentil_pods 8",
})


minetest.register_craftitem( "xpand:lentil_pods", {
	description = "Lentil Pods",
	inventory_image = "xpand_lentil_pods.png",
	on_use = minetest.item_eat(0)
})

minetest.register_craft({
	type = "shapeless",
	output = "xpand:seed_lentil 2",
	recipe = { "xpand:lentil_pods" }
})

minetest.register_craft({
	type = "shaped",
	output = "xpand:lentils",
	recipe = {
		{ "xpand:seed_lentil", "xpand:seed_lentil", "xpand:seed_lentil" },
		{ "xpand:seed_lentil", "xpand:seed_lentil", "xpand:seed_lentil" },
		{ "xpand:seed_lentil", "xpand:seed_lentil", "xpand:seed_lentil" }
	}
})

minetest.register_craftitem( "xpand:lentils", {
	description = "Lentils",
	inventory_image = "xpand_lentils.png",
	on_use = minetest.item_eat(0)
})

minetest.register_craftitem( "xpand:lentil", {
	description = "not lentil",
	inventory_image = "default_dirt.png",
	not_in_creative_inventort = true
})

farming.register_plant( "xpand:olive", {
	description = "Olive Seed",
	inventory_image = "xpand_olive_seed.png",
	steps = 5,
	groups = { food = 4 },
	minlight = 8,
	maxlight = 14,
	fertility = { "grassland", "soil" }
})

minetest.override_item( "xpand:olive_5", {
	drop = "xpand:olive 6",
})

minetest.register_node( "xpand:olive", {
	description = "Olive",
	inventory_image = "xpand_olive.png",
	groups = { food = 4 },
	on_use = minetest.item_eat(1)
})

minetest.register_craft({
	type = "shapeless",
	output = "xpand:olive_seed",
	recipe = { "xpand:olive" }
})

minetest.register_craft({
	type = "shaped",
	output = "xpand:bottle_olive_oil",
	recipe = {
		{ "xpand:olive", "xpand:olive", "xpand:olive" },
		{ "", "vessels:glass_bottle", "" },
		{ "", "", "" }
	},
})

minetest.register_craftitem( "xpand:bottle_olive_oil", {
	description = "Olive Oil Bottle",
	inventory_image = "xpand_bottle_olive.png",
	on_use = minetest.item_eat(0)
})



