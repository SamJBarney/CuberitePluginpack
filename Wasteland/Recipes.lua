wasteland_Recipes = {}

local stick = cItem(E_ITEM_STICK)

local tmp = CraftingRecipe.new(2,2)
tmp:SetResult(w_Items['wasteland:dry_planks'])
tmp:SetItem(0,0, stick)
tmp:SetItem(0,1, stick)
tmp:SetItem(1,0, stick)
tmp:SetItem(1,1, stick)

table.insert(wasteland_Recipes, tmp)