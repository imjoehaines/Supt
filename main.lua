local addon, ns = ...
local playerName, _ = UnitName("player")
local _, class = UnitClass("player")
local colour1 = RAID_CLASS_COLORS[class]
local fontFamily = "Interface\\AddOns\\tekticles\\CalibriBold.ttf"
local lastShown = 0 

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local display = frame:CreateFontString(nil, "OVERLAY")
display:SetFont(fontFamily, 14, "OUTLINE")
display:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
display:SetText("AAA")
display:SetAlpha(0)

local function eventHandler(self, event, ...)
  if event == "ADDON_LOADED" then
    if ... == addon then
      print("|c"..colour1.colorStr..addon.."|r loaded!")
    end
  else 
    local _, subEvent, _, _, sourceName, _, _, _, destName, _, _, _, _, _, spellID = ...
    if subEvent == "SPELL_INTERRUPT" and sourceName == playerName then
      --print("You interrupted "..destName.."'s "..GetSpellLink(spellID))
      display:SetAlpha(1)
      display:SetText("You interrupted "..destName.."'s "..GetSpellLink(spellID))
      lastShown = GetTime()
    end
  end
end

local function update(...)
  if (lastShown < GetTime() - 3) then
    local alpha = display:GetAlpha()
    if alpha ~= 0 then
      display:SetAlpha(alpha - .01)
    end
  end
end
frame:SetScript("OnUpdate", update)
frame:SetScript("OnEvent", eventHandler)
