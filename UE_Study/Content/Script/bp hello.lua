-- --
-- -- DESCRIPTION
-- --
-- -- @COMPANY **
-- -- @AUTHOR **
-- -- @DATE ${date} ${time}
-- --

-- ---@type bp_unlua_C
-- local M = UnLua.Class()

-- -- function M:Initialize(Initializer)
-- -- end

-- -- function M:UserConstructionScript()
-- -- end

-- -- function M:ReceiveBeginPlay()
-- -- end

-- -- function M:ReceiveEndPlay()
-- -- end

-- -- function M:ReceiveTick(DeltaSeconds)
-- -- end

-- -- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- -- end

-- -- function M:ReceiveActorBeginOverlap(OtherActor)
-- -- end

-- -- function M:ReceiveActorEndOverlap(OtherActor)
-- -- end

-- return M





--[[
    说明：在蓝图中实现UnLuaInterface接口，并通过 GetModuleName 指定脚本路径，即可绑定到Lua

    例如：
    本脚本由 "Content/Tutorials/01_HelloWorld/HelloWorld.map" 的关卡蓝图绑定
]]

---@type BP_Hello_C
local M = UnLua.Class()

local PrintString = UE.UKismetSystemLibrary.PrintString

function PrintMsg(text, color, duration)
    color = color or UE.FLinearColor(1, 1, 1, 1)
    duration = duration or 100
    PrintString(nil, text, true, false, color, duration)
end

-- 所有绑定到Lua的对象初始化时都会调用Initialize的实例方法
function M:Initialize()
    local msg = [[
    Hello World!

    —— 本示例来自 "Content/Script/BP_Hello.lua"
    ]]
    print("testtest") -- 输出到日志
    PrintMsg(msg) -- 输出到屏幕左上角
end

return M
