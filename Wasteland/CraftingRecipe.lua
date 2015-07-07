local CraftingRecipe = {}
CraftingRecipe.mt = {}
CraftingRecipe.prototype = { width=3, height=3, items={}, result=cItem()}
CraftingRecipe.mt.__index = CraftingRecipe.prototype

function CraftingRecipe.new(width, height)
	local tmp = {}
	setmetatable(tmp, CraftingRecipe.mt)

	-- set values
	if width ~= nil then tmp.width = width end
	if height ~= nil then tmp.height = height end

	-- Initialize item grid
	for x = 1,tmp.width do
		for y = 1, tmp.height do
			tmp.items[tmp:GetIndex(x,y)] = cItem()
		end
	end


	return tmp
end

function CraftingRecipe:GetItem(X,Y)
	if X >= self.width or Y >= self.height or X < 0 or Y < 0 then return false end
	local idx = self:GetIndex(X,Y)
	return self.items[idx]
end

function CraftingRecipe:SetItem(X, Y, a_Item)
	if X >= self.width or Y >= self.height or X < 0 or Y < 0 then return false end

	-- Get the index
	local idx = self:GetIndex(X,Y)
	-- Get the previous value
	local previous = self.items[idx]

	-- 
	self.items[idx] = a_Item
	return previous
end

function CraftingRecipe:GetResult() 
	return result
end

function CraftingRecipe:SetResult(a_Item)
	local previous = self.result
	self.result = a_Item
	return previous
end

function CraftingRecipe:ClearItem(X,Y)
	return self:SetItem(X,Y, cItem())
end

function CraftingRecipe:Compare(a_Comparable, isCraftingRecipeType)
	if isCraftingRecipeType == nil then
		return self:CompareCraftingGrid(a_Comparable)
	else
		return self:CompareCraftingRecipe(a_Recipe)
	end
end

local function CraftingRecipe:GetIndex(X,Y)
	return y * self.width + x + 1
end

-- Returns true when the two CraftingRecipe objects have the same crafting inputs
local function CraftingRecipe:CompareCraftingRecipe(a_Recipe)
	if a_Recipe.width ~= self.width or a_Recipe.height ~= self.height then return false end

	local equal = true

	for x=0,self.width-1 do
		for y=0,self.height-1 do
			local idx = self:GetIndex(x,y)
			local i1 = self.items[idx]
			local i2 = a_Recipe.items[idx]
			equal = equal and i1.m_ItemType == i2.m_ItemType and i1.m_ItemDamage == i2.m_ItemDamage and i1.m_CustomName == i2.m_CustomName
			if not equal then
				return false
			end
		end
	end

	return true
end

local function CraftingRecipe:CompareCraftingGrid(a_Grid)
	local found = false
	local matching_positions = {}
	for x_offset = 0, a_Grid:GetWidth() - self:GetWidth() do
		for y_offset = 0, a_Grid:GetHeight() - self:GetHeight() do
			local equal = true
			for x = 0,self:GetWidth()-1 do
				for y=0,self:GetHeight()-1 do
					local i1 = self:GetItem(x, y)
					local i2 = a_Grid:GetItem(x+x_offset, y+y_offset)
					equal = equal and i1.m_ItemType == i2.m_ItemType and i1.m_ItemDamage == i2.m_ItemDamage and i1.m_CustomName == i2.m_CustomName
					matching_positions[self:GetIndex(x,y)] = true
				end
			end
			if equal then
				found = true
				break
			else
				matching_positions = {}
			end
		end
		if found then break end
	end

	if found then
		for x=0,a_Grid:GetWidth() - 1 do
			for y=0,a_Grid:GetHeight()-1 do
				local idx = y * a_Grid:GetWidth() + x + 1
				if matching_positions[idx] == nil then
					local item = a_Grid:GetItem(x,y)
					if item.m_ItemCount ~= 0 then
						found = false
						break
					end
				end
			end
			if not found then break end
		end
	end

	return found
end
