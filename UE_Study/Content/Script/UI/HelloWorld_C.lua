--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local HelloWorld_C = Class()

function HelloWorld_C:Construct()
	self.TestButton.OnClicked:Add(self, HelloWorld_C.OnClicked_ExitButton)
end

function HelloWorld_C:OnClicked_ExitButton()
	UE4.UKismetSystemLibrary.PrintString(self,"Get Click Msg From UnLua ")
end

return HelloWorld_C