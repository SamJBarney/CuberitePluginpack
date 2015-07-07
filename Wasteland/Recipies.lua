local wRecipe = {}
wRecipe.mt = {}
wRecipe.mt.fns = {}
wRecipe.mt.__index = wRecipe.mt.fns

function wRecipe.new(items, result)
	local retval = {};
	for i=1,9 do 
		retval[i] = items[i];
	end
	retval.result = result;
	setmetatable(retval, wRecipe.mt)
	return retval
end

function compareRecipies(self, other)
	local retval = true
	for i=1,9 do
		local v1 = self[i]
		local v2 = other[i]
		if (v1 ~= nil and v2 ~= nil and v1.m_ItemType == v2.m_ItemType and v1.m_ItemDamage == v2.m_ItemDamage and v1.m_CustomName == v2.m_CustomName) then
		elseif (v1 == nil and v2.m_ItemCount == 0) then
		else
			retval = false
			break
		end
	end
	return retval
end


wasteland_Recipies = {}
