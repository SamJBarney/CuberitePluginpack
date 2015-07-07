local E_BLOCK_ANY = -1
local E_META_ANY = -1

local CHUNK_WIDTH = 16
local CHUNK_HEIGHT = 256

local TickRegistry = {}
local ChunkRegistry = {}

function GetAnyMarkers()
	return E_BLOCK_ANY, E_META_ANY
end

function RegisterCallback(WorldName, BlockId, BlockMeta, a_Plugin, a_Callback)
	if TickRegistry[WorldName] == nil then
		TickRegistry[WorldName] = {}
		TickRegistry[WorldName][BlockId] = {}
		TickRegistry[WorldName][BlockId][BlockMeta] = {}
	end
	if TickRegistry[WorldName][BlockId] == nil then
		TickRegistry[WorldName][BlockId] = {}
		TickRegistry[WorldName][BlockId][BlockMeta] = {}
	end

	if TickRegistry[WorldName][BlockId][BlockMeta] == nil then
		TickRegistry[WorldName][BlockId][BlockMeta] = {}
	end

	local already_exists = false
	for i,callback in ipairs(TickRegistry[WorldName][BlockId][BlockMeta]) do
		if callback.plugin == a_Plugin and callback.theCallback == a_Callback then
			already_exists = true
			break
		end
	end

	if not already_exists and a_Callback ~= nil then

		table.insert(TickRegistry[WorldName][BlockId][BlockMeta], {theCallback = a_Callback, remove = false})
		return true
	end
	return false
end

function UnregisterCallback(WorldName, BlockId, BlockMeta, a_Callback)
	if TickRegistry[WorldName] == nil or TickRegistry[WorldName][BlockId] == nil or TickRegistry[WorldName][BlockId][BlockMeta] == nil then
		return false
	end

	for i,callback in ipairs(TickRegistry[WorldName][BlockId][BlockMeta]) do
		if callback.theCallback == a_Callback then
			callback.remove = true
			return true
		end
	end

	return false
end

function Initialize(Plugin)
	-- Load the Info.lua file
	dofile(cPluginManager:GetPluginsPath() .. "/Ticker/Info.lua")

	PLUGIN = Plugin

	PLUGIN:SetName(g_PluginInfo.Name)
	PLUGIN:SetVersion(g_PluginInfo.Version)

	-- Callbacks
	cPluginManager.AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick)
	cPluginManager.AddHook(cPluginManager.HOOK_CHUNK_AVAILABLE, OnChunkAvailable)
	cPluginManager.AddHook(cPluginManager.HOOK_CHUNK_UNLOADING, OnChunkUnloading)

	LOG("Initialized " .. PLUGIN:GetName() .. " v." .. PLUGIN:GetVersion())
	return true
end

function OnDisable()
	LOG("Disabled " .. PLUGIN:GetName() .. "!")
end

function OnChunkAvailable(World, ChunkX, ChunkZ)
	local WorldName = World:GetName()
	if ChunkRegistry[WorldName] == nil then
		ChunkRegistry[WorldName] = {}
	end
	ChunkRegistry[WorldName][ChunkX .. ChunkZ] = {x=ChunkX, z=ChunkZ, TickX=0, TickY=0, TickZ=0}

end


function OnChunkUnloading(World, ChunkX, ChunkZ)
	local WorldName = World:GetName()

	ChunkRegistry[WorldName][ChunkX .. ChunkZ] = nil
end


function OnWorldTick(World, TimeDelta)
	local WorldName = World:GetName()
	if TickRegistry[WorldName] ~= nil and ChunkRegistry[WorldName] ~= nil then
		for _, chunk in pairs(ChunkRegistry[WorldName]) do
			TickChunk(World, TimeDelta, chunk)
		end
	end
end


local function TickChunk(World, TimeDelta, a_Chunk)
	local RandomX = math.random(0,16777215)
	local RandomY = math.random(0,16777215)
	local RandomZ = math.random(0,16777215)

	local TickX = a_Chunk.TickX
	local TickY = a_Chunk.TickY
	local TickZ = a_Chunk.TickZ

	for i=0,50 do
		TickX = (TickX + RandomX) % (CHUNK_WIDTH * 2)
		TickY = (TickY + RandomY) % (CHUNK_HEIGHT * 2)
		TickZ = (TickZ + RandomZ) % (CHUNK_WIDTH * 2)
		a_Chunk.TickX = math.floor(TickX / 2)
		a_Chunk.TickY = math.floor(TickY / 2)
		a_Chunk.TickZ = math.floor(TickZ / 2)
	end

	local Valid, BlockType, BlockMeta, SkyLight, BlockLight = World:GetBlockInfo(a_Chunk.TickX, a_Chunk.TickY, a_Chunk.TickZ)

	local WorldName = World:GetName()

	if TickRegistry[WorldName][BlockType] ~= nil then
		if TickRegistry[WorldName][BlockType][BlockMeta] ~= nil then
			for i,callback in iparis(TickRegistry[WorldName][BlockType][BlockMeta]) do
				if callback.remove ~= true then
					callback.theCallback(World, a_Chunk.TickX, a_Chunk.TickY, a_Chunk.TickZ, BlockType, BlockMeta, SkyLight, BlockLight)
				else
					TickRegistry[WorldName][BlockType][BlockMeta][i] = nil
				end
			end
		end

		if TickRegistry[WorldName][BlockType][E_META_ANY] ~= nil then
			for i,callback in iparis(TickRegistry[WorldName][BlockType][E_META_ANY]) do
				if callback.remove ~= true then
					callback.theCallback(World, a_Chunk.TickX, a_Chunk.TickY, a_Chunk.TickZ, BlockType, BlockMeta, SkyLight, BlockLight)
				else
					TickRegistry[WorldName][BlockType][E_META_ANY][i] = nil
				end
			end
		end

		if TickRegistry[WorldName][E_BLOCK_ANY][E_META_ANY] ~= nil then
			for i,callback in iparis(TickRegistry[WorldName][E_BLOCK_ANY][E_META_ANY]) do
				if callback.remove ~= true then
					callback.theCallback(World, a_Chunk.TickX, a_Chunk.TickY, a_Chunk.TickZ, BlockType, BlockMeta, SkyLight, BlockLight)
				else
					TickRegistry[WorldName][E_BLOCK_ANY][E_META_ANY][i] = nil
				end
			end
		end
	end
end