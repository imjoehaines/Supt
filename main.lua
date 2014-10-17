----------------
-- Config ------
----------------
local x, y = 0, 150         -- x & y positioning from the centre of the screen
local displayDuration = 3   -- how long to keep the display on screen (seconds)
local fadeDuration = 1.5    -- how long for the display to fadeout (seconds)
local fontSize = 14         -- size of the font
local fontFlag = "OUTLINE"  -- font decoration ("OUTLINE", "THICKOUTLINE" or "MONOCHROME")

local alsoPrint = false     -- also print to the chatlog - does NOT send to other players! (true/false)
local showMobName = true    -- show the mob name in the output (true/false)

----------------

local addon, ns = ...
local playerName, _ = UnitName("player")
local _, class = UnitClass("player")
local colour1 = RAID_CLASS_COLORS[class].colorStr
local fontFamily = "Interface\\AddOns\\Supt\\Roboto-Bold.ttf"

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local display = frame:CreateFontString(nil, "OVERLAY")
display:SetFont(fontFamily, fontSize, fontFlag)
display:SetPoint("CENTER", UIParent, "CENTER", x, y)
display:SetText("")
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
      print("|c"..colour1..addon.."|r loaded!")
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
