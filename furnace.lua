
ufos.fuel = "default:obsidian_shard"
ufos.fuel_time = 10

local materials = xcompat.materials
local sounds = xcompat.sounds

if materials.obsidian ~= "default:obsidian" then
	ufos.fuel = materials.obsidian
	ufos.fuel_time = 90
end

local steel_block_face = core.registered_nodes[materials.steel_block].tiles[1]

ufos.furnace_inactive_formspec =
	"size[8,5.5]"..
	"list[current_name;fuel;3.5,0;1,1;]"..
	"list[current_player;main;0,1.5;8,4;]"..
	"label[4.5,0;Fuel needed: "..ufos.fuel.."]"..
	"label[0,1;Press run (E) inside your UFO.]"..
	"label[4,1;You need to park it next to this.]"


minetest.register_node("ufos:furnace", {
	description = "UFO charging device",
	tiles = {steel_block_face, steel_block_face, steel_block_face,
		steel_block_face, steel_block_face, steel_block_face.."^ufos_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = sounds.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", ufos.furnace_inactive_formspec)
		meta:set_string("infotext", "UFO charging device")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		end
		return true
	end,
})

minetest.register_node("ufos:furnace_active", {
	description = "UFO charging device",
	tiles = {
		steel_block_face,
		steel_block_face,
		steel_block_face,
		steel_block_face,
		steel_block_face,
		steel_block_face.."^ufos_furnace_front.png^ufos_furnace_front_active.png"
	},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "ufos:furnace",
	groups = {cracky=2, not_in_creative_inventory=1},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = sounds.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", ufos.furnace_inactive_formspec)
		meta:set_string("infotext", "UFO charging device")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"ufos:furnace","ufos:furnace_active"},
	interval = .25,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack("fuel",1)
		if stack:get_name() == ufos.fuel then
			inv:remove_item("fuel",ItemStack(ufos.fuel))
			meta:set_int("charge",meta:get_int("charge")+1)
			meta:set_string("formspec", ufos.furnace_inactive_formspec
				.. "label[0,0;Charge: "..meta:get_int("charge"))
		end
	end,
})

minetest.register_craft( {
	output = 'ufos:furnace',
	recipe = {
		{ materials.steel_ingot, materials.obsidian, materials.steel_ingot},
		{ materials.obsidian, "default:furnace", materials.obsidian},
		{ materials.steel_ingot, materials.obsidian, materials.steel_ingot},
	},
})

