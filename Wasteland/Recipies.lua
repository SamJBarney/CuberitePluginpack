local wRecipe = {}
wRecipe.mt = {}
wRecipe.mt.fns = {}
wRecipe.mt.__index = wRecipe.mt.fns

function wRecipe.new(items)
	local retval = {};
	for i=1,9 do 
		retval[i] = items[i];
	end
	setmetatable(retval, wRecipe.mt)
	return retval
end

function wRecipe.mt.__eq(self, other) {
	local retval = true
	for i=1,9 do
		local v1 = self[i]
		local v2 = other[i]
		if (v1 ~= nil && v2 ~= nil and v1.m_ItemType == v2.m_ItemType and v1.m_ItemCount == v2.m_ItemCount and v1.m_ItemDamage == v2.m_ItemDamage and v1.m_CustomName == v2.m_CustomName) then
		elseif (v1 == nil and v2 == nil) then
		else
			retval = false
			break
		end
	end
	return retval
}


wasteland_Recipies = {
	wRecipe.new({cItem(E_BLOCK_SAND,6), cItem(E_BLOCK_DIRT)}) =
		cItem(E_ITEM_STICK),
	wRecipe.new({cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT),cItem(E_BLOCK_DIRT)}) = 
		cItem(E_ITEM_SEED, 1, 0, "", "Unknown Seed", "Who knows what this will grow"),
}