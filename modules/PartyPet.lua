local Luna_PartyPet_Events = {}
LunaPartyPetFrames = {}

function Luna_PartyPet_Tip()
	UnitFrame_OnEnter()
end

function Luna_PartyPet_OnClick()
	local button = arg1
	if (button == "LeftButton") then
		if (SpellIsTargeting()) then
			SpellTargetUnit(this.unit)
		elseif (CursorHasItem()) then
			DropItemOnUnit(this.unit)
		else
			TargetUnit(this.unit)
		end
		return
	end

	if (button == "RightButton") then
		if (SpellIsTargeting()) then
			SpellStopTargeting()
			return;
		end
	end

	if (not (IsAltKeyDown() or IsControlKeyDown() or IsShiftKeyDown())) then
		ToggleDropDownMenu(1, nil, this.dropdown, "cursor", 0, 0)
	end

end

function Luna_PartyPet_OnEvent()
	local func = Luna_PartyPet_Events[event]
	if (func) then
		func()
	else
		DEFAULT_CHAT_FRAME:AddMessage("Luna Unit Frames - PartyPet: Report the following event error to the author: "..event)
	end
end

function LunaUnitFrames:CreatePartyPetFrames()
	for i=1, 4 do
		LunaPartyPetFrames[i] = CreateFrame("Button", "LunaPartyPetFrame"..i, LunaPartyFrames[i])

		LunaPartyPetFrames[i]:SetHeight(LunaOptions.frames["LunaPartyPetFrames"].size.y)
		LunaPartyPetFrames[i]:SetWidth(LunaOptions.frames["LunaPartyPetFrames"].size.x)
		LunaPartyPetFrames[i]:SetScale(LunaOptions.frames["LunaPartyPetFrames"].scale)
		LunaPartyPetFrames[i]:SetBackdrop(LunaOptions.backdrop)
		LunaPartyPetFrames[i]:SetBackdropColor(0,0,0,1)
		LunaPartyPetFrames[i]:SetPoint("BOTTOMLEFT", LunaPartyFrames[i], "BOTTOMRIGHT", 5, 0)
		LunaPartyPetFrames[i]:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		LunaPartyPetFrames[i].unit = "partypet"..i
		LunaPartyPetFrames[i]:SetScript("OnEnter", Luna_PartyPet_Tip)
		LunaPartyPetFrames[i]:SetScript("OnLeave", UnitFrame_OnLeave)
		LunaPartyPetFrames[i]:SetScript("OnClick", Luna_PartyPet_OnClick)
		LunaPartyPetFrames[i]:SetScript("OnEvent", Luna_PartyPet_OnEvent)
		LunaPartyPetFrames[i]:RegisterEvent("UNIT_HEALTH")
		LunaPartyPetFrames[i]:RegisterEvent("UNIT_MAXHEALTH")
		LunaPartyPetFrames[i]:RegisterEvent("UNIT_NAME_UPDATE")
		LunaPartyPetFrames[i].dropdown = CreateFrame("Frame", "LunaUnitDropDownMenuPartyPet"..i, UIParent, "UIDropDownMenuTemplate")
		LunaPartyPetFrames[i].DropDown_Initialize = function () UnitPopup_ShowMenu(LunaPartyPetFrames[i].dropdown, "RAID_TARGET_ICON", ("partypet"..i), RAID_TARGET_ICON) end
		UIDropDownMenu_Initialize(LunaPartyPetFrames[i].dropdown, LunaPartyPetFrames[i].DropDown_Initialize, "MENU")

		-- Healthbar
		LunaPartyPetFrames[i].HealthBar = CreateFrame("StatusBar", nil, LunaPartyPetFrames[i])
		LunaPartyPetFrames[i].HealthBar:SetAllPoints(LunaPartyPetFrames[i])
		LunaPartyPetFrames[i].HealthBar:SetStatusBarTexture(LunaOptions.statusbartexture)
		LunaPartyPetFrames[i].HealthBar:SetPoint("TOPLEFT", LunaPartyPetFrames[i], "TOPLEFT", 0, 0)
		LunaPartyPetFrames[i].HealthBar:SetStatusBarColor(LunaOptions.MiscColors["friendly"][1],LunaOptions.MiscColors["friendly"][2],LunaOptions.MiscColors["friendly"][3])
		

		-- Healthbar background
		LunaPartyPetFrames[i].HealthBar.hpbg = LunaPartyPetFrames[i].HealthBar:CreateTexture(nil, "BORDER")
		LunaPartyPetFrames[i].HealthBar.hpbg:SetAllPoints(LunaPartyPetFrames[i].HealthBar)
		LunaPartyPetFrames[i].HealthBar.hpbg:SetTexture(.25,.25,.25)
		LunaPartyPetFrames[i].HealthBar.hpbg:SetVertexColor(LunaOptions.MiscColors["friendly"][1],LunaOptions.MiscColors["friendly"][2],LunaOptions.MiscColors["friendly"][3], 0.25)

		-- Healthbar text
		LunaPartyPetFrames[i].HealthBar.hpp = LunaPartyPetFrames[i].HealthBar:CreateFontString(nil, "OVERLAY", LunaPartyPetFrames[i].HealthBar)
		LunaPartyPetFrames[i].HealthBar.hpp:SetPoint("RIGHT", -2, -1)
		LunaPartyPetFrames[i].HealthBar.hpp:SetFont(LunaOptions.font, LunaOptions.fontHeight)
		LunaPartyPetFrames[i].HealthBar.hpp:SetShadowColor(0, 0, 0)
		LunaPartyPetFrames[i].HealthBar.hpp:SetShadowOffset(0.8, -0.8)
		LunaPartyPetFrames[i].HealthBar.hpp:SetTextColor(1,1,1)
		
		LunaPartyPetFrames[i].name = LunaPartyPetFrames[i].HealthBar:CreateFontString(nil, "OVERLAY", LunaPartyPetFrames[i].HealthBar)
		LunaPartyPetFrames[i].name:SetPoint("LEFT", 2, -1)
		LunaPartyPetFrames[i].name:SetJustifyH("LEFT")
		LunaPartyPetFrames[i].name:SetFont(LunaOptions.font, LunaOptions.fontHeight)
		LunaPartyPetFrames[i].name:SetShadowColor(0, 0, 0)
		LunaPartyPetFrames[i].name:SetShadowOffset(0.8, -0.8)
		LunaPartyPetFrames[i].name:SetTextColor(1,1,1)
	end
	LunaUnitFrames:UpdatePartyPetFrames()
end

function LunaUnitFrames:UpdatePartyPetFrames()
	for i=1,4 do
		if UnitIsVisible(LunaPartyPetFrames[i].unit) and LunaOptions.frames["LunaPartyPetFrames"].enabled == 1 then
			LunaPartyPetFrames[i].HealthBar:SetMinMaxValues(0, UnitHealthMax(LunaPartyPetFrames[i].unit))
			LunaPartyPetFrames[i].HealthBar:SetValue(UnitHealth(LunaPartyPetFrames[i].unit))
			LunaPartyPetFrames[i].HealthBar.hpp:SetText(UnitHealth(LunaPartyPetFrames[i].unit).."/"..UnitHealthMax(LunaPartyPetFrames[i].unit))
			if UnitIsDead(LunaPartyPetFrames[i].unit) then			-- This prevents negative health
				LunaPartyPetFrames[i].HealthBar:SetValue(0)
			end
			LunaPartyPetFrames[i].name:SetText(UnitName(LunaPartyPetFrames[i].unit))
			LunaPartyPetFrames[i]:Show()
		else
			LunaPartyPetFrames[i]:Hide()
		end
	end
end

function Luna_PartyPet_Events:UNIT_HEALTH()
	if this.unit == arg1 then
		this.HealthBar:SetMinMaxValues(0, UnitHealthMax(this.unit))
		this.HealthBar:SetValue(UnitHealth(this.unit))
		this.HealthBar.hpp:SetText(UnitHealth(this.unit).."/"..UnitHealthMax(this.unit))
		if UnitIsDead(this.unit) then			-- This prevents negative health
			this.HealthBar:SetValue(0)
			this.HealthBar.hpp:SetText("0/"..UnitHealthMax(this.unit))
		end
	end
end
Luna_PartyPet_Events.UNIT_MAXHEALTH = Luna_PartyPet_Events.UNIT_HEALTH

function Luna_PartyPet_Events:UNIT_NAME_UPDATE()
	if this.unit == arg1 and UnitIsVisible(this.unit) then
		this.name:SetText(UnitName(this.unit))
	end
end