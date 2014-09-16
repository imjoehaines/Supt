----------------
-- Config ------
----------------
local x, y = 0, 150         -- x, y positioning (two numbers)
local displayDuration = 3   -- number of seconds to keep the display on screen (one number)
local fadeDuration = 1.5    -- number of seconds to fade the display (one number)
local fontSize = 12         -- size of the font (one number)
local fontFlag = "OUTLINE"  -- font details (OUTLINE, THICKOUTLINE or MONOCHROME)

local alsoPrint = false     -- also print to the chatlog - does NOT send to other players! (true/false)
local showMobName = true    -- show the mob name from the output (true/false)

----------------

local addon, ns = ...
local playerName, _ = UnitName("player")
local _, class = UnitClass("player")
local colour1 = RAID_CLASS_COLORS[class]
local fontFamily = "Interface\\AddOns\\Supt\\Roboto-Bold.ttf"

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local display = frame:CreateFontString(nil, "OVERLAY")
display:SetFont(fontFamily, fontSize, fontFlag)
display:SetPoint("CENTER", UIParent, "CENTER", x, y)
display:SetText("AAA")
frame:SetAlpha(0)

local animGroup = frame:CreateAnimationGroup()
local animation = animGroup:CreateAnimation("Alpha")
animation:SetStartDelay(displayDuration)
animation:SetDuration(fadeDuration)
animation:SetSmoothing("IN")
animation:SetChange(-1)

animGroup:SetScript("OnFinished", function(self, requested)
    frame:SetAlpha(0)
end)

local function eventHandler(self, event, ...)
  if event == "ADDON_LOADED" then
    if ... == addon then
      print("|c"..colour1.colorStr..addon.."|r loaded!")
    end
  else 
    local _, subEvent, _, _, sourceName, _, _, _, destName, _, _, _, _, _, spellID = ...
    if subEvent == "SPELL_INTERRUPT" and sourceName == playerName then
      if alsoPrint then print("You interrupted ".. (showMobName and destName.."'s " or "") ..GetSpellLink(spellID)) end
      frame:SetAlpha(1)
      display:SetText("You interrupted ".. (showMobName and destName.."'s " or "") ..GetSpellLink(spellID))
      animGroup:Play()
    end
  end
end

frame:SetScript("OnEvent", eventHandler)