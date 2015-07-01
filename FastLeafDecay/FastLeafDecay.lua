
PLUGIN = nil

local MinTickDelay = 2
local MaxTickDelay = 6

local LeafTypes = {}
local LogTypes = {}

local function bit(p)
  return 2 ^ (p - 1)  -- 1-based indexing
end

local function hasbit(x, p)
  return x % (p + p) >= p       
end

function Initialize(Plugin)
	-- Load the Info.lua file
	dofile(cPluginManager:GetPluginsPath() .. "/FastLeafDecay/Info.lua")

	PLUGIN = Plugin

	PLUGIN:SetName(g_PluginInfo.Name)
	PLUGIN:SetVersion(g_PluginInfo.Version)

	-- Register known Leaf block types
	LeafTypes[E_BLOCK_LEAVES] = true
	LeafTypes[E_BLOCK_NEW_LEAVES] = true

	-- Register known Log block types
	LogTypes[E_BLOCK_LOG] = true
	LogTypes[E_BLOCK_NEW_LOG] = true

	-- Hooks
	cPluginManager.AddHook(cPluginManager.HOOK_BLOCK_TO_PICKUPS, TestForDecay)

	LOG("Initialized " .. PLUGIN:GetName() .. " v." .. PLUGIN:GetVersion())
	return true
end

function OnDisable()
	LOG("Disabled " .. PLUGIN:GetName() .. "!")
end

function TestForDecay(World, Digger, BlockX, BlockY, BlockZ, BlockType, BlockMeta, Pickups)
	if (LogTypes[BlockType] ~= nil or ((LeafTypes[BlockType] ~= nil) and not hasbit(BlockMeta, bit(3)))) then
		if (LeafTypes[World:GetBlock(BlockX + 1, BlockY, BlockZ)] ~= nil) then
			World:QueueBlockForTick(BlockX + 1, BlockY, BlockZ, TickDelay())
		end

		if (LeafTypes[World:GetBlock(BlockX - 1, BlockY, BlockZ)] ~= nil) then
			World:QueueBlockForTick(BlockX - 1, BlockY, BlockZ, TickDelay())
		end

		if (LeafTypes[World:GetBlock(BlockX, BlockY + 1, BlockZ)] ~= nil) then
			World:QueueBlockForTick(BlockX, BlockY + 1, BlockZ, TickDelay())
		end

		if (LeafTypes[World:GetBlock(BlockX, BlockY - 1, BlockZ)] ~= nil) then
			World:QueueBlockForTick(BlockX, BlockY - 1, BlockZ, TickDelay())
		end

		if (LeafTypes[World:GetBlock(BlockX, BlockY, BlockZ + 1)] ~= nil) then
			World:QueueBlockForTick(BlockX, BlockY, BlockZ + 1, TickDelay())
		end

		if (LeafTypes[World:GetBlock(BlockX, BlockY, BlockZ - 1)] ~= nil) then
			World:QueueBlockForTick(BlockX, BlockY, BlockZ - 1, TickDelay())
		end
	end
end


function TickDelay()
	return math.random(MinTickDelay, MaxTickDelay)
end

