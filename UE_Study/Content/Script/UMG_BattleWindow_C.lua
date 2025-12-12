--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
--ui战斗界面
---@type UMG_BattleWindow_C
local UMG_BattleWindow_C = UnLua.Class()

function UMG_BattleWindow_C:Initialize(Initializer)
    print("UMG_BattleWindow_C lua 初始化成功")
    
end
function UMG_BattleWindow_C:Construct()
    print("UMG_BattleWindow_C lua UserConstructionScript")
    self.BagButton.OnClicked:Add(self,UMG_BattleWindow_C.OnClicked_BagButton)
    --创建背包列表
    local bagData = {
                    [1]={name="长剑",num=1,quality = 1 },
                    [2]={name="短剑",num=1,quality = 1 },
                    [3]={name="暴风大剑",num=1,quality = 2 },
                    [4]={name="无尽之刃",num=1,quality = 3 },
                    }
    

end

function UMG_BattleWindow_C:OnClicked_BagButton()
	print("lua 调用打开背包界面")
    local umg = UE.UClass.Load("/Game/UI/UMG/BagWindow.BagWindow_C")
	local Widget = UE4.UWidgetBlueprintLibrary.Create(self,umg )
   	if Widget then
		Widget:AddToViewport()
    else
        print("load HelloWorld UMG file Failed!")
	end
end
--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return UMG_BattleWindow_C
