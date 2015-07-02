local PLUGIN = nil

-- Load the recipies
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/Recipies.lua")

local RegisteredWorlds = {}

function Initialize(Plugin)
	-- Load the Info.lua file
	dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/Info.lua")

	PLUGIN = Plugin

	PLUGIN:SetName(g_PluginInfo.Name)
	PLUGIN:SetVersion(g_PluginInfo.Version)

	-- Generation Hooks
	cPluginManager.AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
	cPluginManager.AddHook(cPluginManager.HOOK_CHUNK_GENERATED, OnChunkGenerated)

	-- Crafting Hooks
	cPluginManager.AddHook(cPluginManager.HOOK_PRE_CRAFTING, OnPreCrafting)

	LOG("Initialized " .. PLUGIN:GetName() .. " v." .. PLUGIN:GetVersion())

	return true
end

function OnDisable()
	LOG("Disabled " .. PLUGIN:GetName() .. "!")
end


-- Generation Callbacks
function OnChunkGenerating(World, ChunkX, ChunkZ, ChunkDesc)
	--if (RegisteredWorlds[World.GetName()] ~= nil) then
		ChunkDesc:SetUseDefaultBiomes(false)
		ChunkDesc:SetUseDefaultFinish(false)
		-- Change the biome to desert
		for x=0,15 do
			for z=0,15 do
				ChunkDesc:SetBiome(x,z,biDesert)
			end
		end
		return true
	--end
	--return false
end

function OnChunkGenerated(World, ChunkX, ChunkZ, ChunkDesc)
	--if (RegisteredWorlds[World.GetName()] ~= nil) then
		-- Replace all water with air
		ChunkDesc:ReplaceRelCuboid(0,15, 0,255, 0,15, 8,0, 0,0)
		ChunkDesc:ReplaceRelCuboid(0,15, 0,255, 0,15, 9,0, 0,0)

		-- Replace clay with hardend clay
		ChunkDesc:ReplaceRelCuboid(0,15, 0,255, 0,15, 82,0, 172,0)

		return true
	--end
	--return false
end

-- Crafting Callbacks
function OnPreCrafting(Player, Grid, Recipe)
	local recipe_found = false
	local possible_recipie = {

	}


	return recipe_found
end