--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_PlayerMain_C


require "UnLua"

local BP_PlayerMain_C = Class()
function BP_PlayerMain_C:ReceiveBeginPlay()
    print("BP_PlayerMain_C:ReceiveBeginPlay()")
    -- -- 测试2：UE命名空间
    -- print("2. UE命名空间:", UE ~= nil)
    -- print("3. UE.UClass:", UE.UClass ~= nil)
    -- print("4. UE.UObject:", UE.UObject ~= nil)
    --  -- 测试3：加载一个已知的引擎内置类
    --  local ActorClass = UE.UClass.Load("/Script/Engine.Actor")
    --  print("5. 加载Actor类:", ActorClass ~= nil)
    --  if ActorClass then
    --      print("   Actor类名:", ActorClass:GetName())
    --  end

    --  -- 测试4：加载Widget基础类
    -- local WidgetBaseClass = UE.UClass.Load("/Script/UMG.UserWidget")
    -- print("6. 加载UserWidget基类:", WidgetBaseClass ~= nil)
    -- -- 测试3：列出可用的UObject函数
    -- print("\n5. UE.UObject可用函数:")
    -- for k, v in pairs(UE4.UClass) do
    --     if type(v) == "function" then
    --         print("   - " .. k)
    --     end
    -- end
    -- -- -- 测试5：直接使用FindObject查找
    -- -- local FoundClass = UE.UObject.Load("/Game/UI/UMG/StartWindow.StartWindow")
    -- -- print("7. FindObject查找:", FoundClass ~= nil)
       
    -- print("=============================BP_PlayerMain_C:ReceiveBeginPlay()")
    -- -- local umg = UE4.UClass.Load("/Game/UI/UMG/UMG_StartWindow.UMG_StartWindow")
    -- -- print("7. umg:", umg ~= nil)
	-- --local Widget = UE4.UWidgetBlueprintLibrary.Create(self,umg )
    -- local Widget = UE4.UWidgetBlueprintLibrary.StaticLoadWidgetBlueprintClass(nil, "/Game/UI/UMG/UMG_StartWindow")
	-- if Widget then
	-- 	Widget:AddToViewport()
    -- else
    --     print("load HelloWorld UMG file Failed!")
	-- end

	-- self.ForwardVec = UE4.FVector()
	-- self.RightVec = UE4.FVector()
	-- self.ControlRot = UE4.FRotator()

	-- self.BaseTurnRate = 45.0
	-- self.BaseLookUpRate = 45.0

	--self.Overridden.ReceiveBeginPlay(self)
end
-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return BP_PlayerMain_C
