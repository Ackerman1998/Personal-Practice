--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
--ui 背包界面
---@type BagWindow_C
local BagWindow_C = UnLua.Class()
function BagWindow_C:Construct()
    self.CloseButton.OnClicked:Add(self,self.OnClicked_CloseButton)
end

function BagWindow_C:OnClicked_CloseButton()
	print("关闭背包")
    self:RemoveFromViewport()
end

return BagWindow_C
