LunaUnitFrames = CreateFrame("Frame")
LunaUnitFrames.frames = {}
LunaUnitFrames.proximity = ProximityLib:GetInstance("1")
LunaUnitFrames:RegisterEvent("ADDON_LOADED")
LunaUnitFrames:RegisterEvent("RAID_ROSTER_UPDATE")
LunaUnitFrames:RegisterEvent("PLAYER_ENTERING_WORLD")
function LunaUnitFrames:OnEvent()
	if event == "ADDON_LOADED" and arg1 == "LunaUnitFrames" then
		--Load the Addon here
		ChatFrame1:AddMessage("Luna Unit Frames loaded. Enjoy the ride!")
		LunaUnitFrames:CreatePlayerFrame()
		LunaUnitFrames:CreatePetFrame()
		LunaUnitFrames:CreateTargetFrame()
		LunaUnitFrames:CreateTargetTargetFrame()
		LunaUnitFrames:CreateTargetTargetTargetFrame()
		LunaUnitFrames:CreatePartyFrames()
		LunaUnitFrames:CreatePartyPetFrames()
		LunaUnitFrames:CreateRaidFrames()
		LunaUnitFrames:CreateXPBar()
		LunaOptionsModule:CreateMenu()
	elseif event == "RAID_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
		LunaUnitFrames:UpdateRaidRoster()
	end
end
LunaUnitFrames:SetScript("OnEvent", LunaUnitFrames.OnEvent)

SLASH_LUF1, SLASH_LUF2, SLASH_LUF3 = "/luf", "/luna", "/lunaunitframes"
function SlashCmdList.LUF(msg, editbox)
	LunaOptionsFrame:Show()
end

SLASH_LUFMO1, SLASH_LUFMO2 = "/lunamo", "/lunamouseover"
function SlashCmdList.LUFMO(msg, editbox)
	if GetMouseFocus().unit then
		if UnitIsUnit("target", GetMouseFocus().unit) then
			CastSpellByName(msg)
		else
			TargetUnit(GetMouseFocus().unit)
			CastSpellByName(msg)
			TargetLastTarget()
		end
	else 
		CastSpellByName(msg)
	end
end