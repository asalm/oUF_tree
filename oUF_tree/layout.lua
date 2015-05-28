local _, ns = ...
local config = ns.Config
--===============--
-- CONFIG        --
-- oUF_tree      --
-- made by naisz --
-- Thanks to: Musca, Haleth, Phanx --
--===============--

    local texture = "Interface\\AddOns\\oUF_tree\\media\\HalO.tga"
    local font = "Interface\\AddOns\\oUF_tree\\fonts\\pixelfont.ttf"
    local size = 8
    local color = {r = 0, g = 0, b = 0}
    local scale = 1
    local pos = 1 -- dieser Wert gibt den Abstand vom Frame an

local frameborder = {
    bgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
    edgeFile = 'Interface\\ChatFrame\\ChatFrameBackground',
    edgeSize = 1,
    insets = {top = 1, bottom = 1, left = 1, right = 1},
}

	local width = 220

    --Castbar Coordinates
    local cbx = 0;
    local cby = -200;

    local activeCastbar = true

--==================--
--      TAGS        --
--==================--

oUF.Tags.Events["level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"
oUF.Tags.Methods["level"] = function(unit)
    
    local c = UnitClassification(unit)
    local l = UnitLevel(unit)
    local d = GetQuestDifficultyColor(l)
    
    local str = l
        
    if l <= 0 then l = "??" end
    
    if c == "worldboss" then
        str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
    elseif c == "eliterare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
    elseif c == "elite" then
        str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
    elseif c == "rare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
    else
        if not UnitIsConnected(unit) then
            str = "??"
        else
            if UnitIsPlayer(unit) then
                str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
            elseif UnitPlayerControlled(unit) then
                str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
            else
                str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
            end
        end     
    end
    
    return str
end

oUF.Tags.Events['ns:pp'] = "UNIT_POWER"
oUF.Tags.Methods['ns:pp'] = function(unit)
    local pp = UnitPower(unit)

    if pp <= 9999 then return pp end
    if pp >= 1000000 then
        local value = string.format("%.1fm",pp/1000000)
        return value
    elseif pp >= 10000 then
        local value = string.format("%.1fk",pp/1000)
        return value
    end
end

oUF.Tags.Events['name:normal'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['name:normal'] = function(unit)
    local name = UnitName(unit)
    return string.sub(name,1,16)
end

oUF.Tags.Events["ns:hp"] = "UNIT_HEALTH"
oUF.Tags.Methods["ns:hp"] = function(unit)
        if not UnitIsDeadOrGhost(unit) then
            local hp = UnitHealth(unit)
            if hp <= 9999 then return hp end
            if hp >= 1000000 then
                local value = string.format("%.1fm",hp/1000000)
                return value
            elseif hp >= 10000 then
                local value = string.format("%.1fk",hp/1000)
                return value
        end
    end
end



--==================--
--     FUNCTIONS    --
--==================--

-- GCD-Timer-Func
classgcdspells ={
    ["DRUID"] = 5176,			-- Wrath
    ["PRIEST"] = 585, 			-- Smite
    ["PALADIN"] = 7328,			-- Redemption
    ["WARLOCK"] = 686,			-- Shadow Bolt
    ["WARRIOR"] = 5308,			-- Execute
    ["DEATHKNIGHT"] = 49892,	-- Death Coil
    ["SHAMAN"] = 403,			-- Lightning bolt
    ["HUNTER"] = 3044, 			-- Arcane Shot
    ["ROGUE"] = 1752,			-- Sinister Strike
    ["MAGE"] = 44614, 			-- Frostfire Bolt
	["MONK"] = 115178, 			-- Resuscitate
}

local GetTime = GetTime
local GetSpellCooldown = GetSpellCooldown
local gcdisshown

local _, class = UnitClass("player")
local spellid = classgcdspells[class]

local OnUpdateGCD = function(self)
	local perc = (GetTime() - self.starttime) / self.duration
	if perc > 1 then
		self:Hide()
	else
		self:Show()
		self:SetValue(perc)
	end
end

local OnHideGCD = function(self)
 	self:SetScript('OnUpdate', nil)
	gcdisshown = nil
end

local OnShowGCD = function(self)
	self:SetScript('OnUpdate', OnUpdateGCD)
	gcdisshown = 1
end

local Update = function(self, event, unit)
	
	if self.GCD then
		local start, dur = GetSpellCooldown(spellid)

		if (not start) then return end
		if (not dur) then dur = 0 end

		if dur == 0 then
			self.GCD:Hide() 
		else
			self.GCD.starttime = start
			self.GCD.duration = dur
			self.GCD:Show()
		end
	end
end

local Enable = function(self)
	if self.GCD then
		self.GCD:SetMinMaxValues(0, 1)
		self.GCD:SetValue(0)
		self.GCD:Hide()
		self.GCD.starttime = 0
		self.GCD.duration = 0

		self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', Update)
		self.GCD:SetScript('OnHide', OnHideGCD)
		self.GCD:SetScript('OnShow', OnShowGCD)
	end
end

local Disable = function(self)
	if (not self.GCD) then
		self:UnregisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
		self.GCD:Hide()  
	end
end

oUF:AddElement('GCD', Update, Enable, Disable)

-- create a 1px border around frames (on the outside)
local border = function(self)                
    local bd = CreateFrame('Frame', nil, self)
    bd:SetPoint('TOPLEFT', self, 'TOPLEFT', -1, 1)
    bd:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 1, -1)
    bd:SetBackdrop(frameborder)
    bd:SetBackdropColor(0, 0, 0, 0)
    bd:SetBackdropBorderColor(0, 0, 0)
    bd:SetFrameLevel(self:GetFrameLevel())
    return bd
end
-- create Aura's
local CreateAura = function(self, num)

    local size = width/7.96 --23
    local Auras = CreateFrame("Frame", nil, self)
    Auras:SetSize(num * (size + 4), size)

    Auras.num = num
    Auras.size = size
    Auras.spacing = 4

    Auras.PostCreateIcon = PostCreateIcon

    return Auras
end

local function PostCreateIcon(element, button)
	
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)


	local count = button.count
	count:ClearAllPoints()
	count:SetPoint('TOPRIGHT', 1, 1)
	count:SetFont(font, size, "OUTLINEMONOCHROME")
	count:SetVertexColor(0.93, 0.7, 0.39)

	local timer = button:CreateFontString(nil, 'OVERLAY')
	timer:SetPoint('BOTTOM', 0, -3)
	timer:SetFont(font, size, "OUTLINEMONOCHROME")
	timer:SetVertexColor(0.9, 0.9, 0.9)
	button.timer = timer
	
	button.border = border(button)

end

--=================--
-- STYLE           --
--=================--
local function Style(self, unit, isSingle)
--SIZE! depending on Unit

  if unit == "player" or unit =="target" or (unit and unit:find("boss%d"))then
    self:SetSize(210,20)
  elseif unit =="targettarget" or unit == "pet" or unit == "focus" then
    self:SetSize(60,20)
  end
--DROPDOWN
    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
 
    -- create a background for the frame
    local frameBG = self:CreateTexture(nil, "BACKGROUND")
    frameBG:SetAllPoints()
    frameBG:SetTexture(0, 0, 0, 0)
 
--==================--
--      HEALTH      --
--==================--

    local health = CreateFrame("StatusBar", nil, self)
    if unit == "player" or unit == "target" then
    health:SetSize(width, 20)
	elseif (unit and unit:find("boss%d")) then
	health:SetSize(width-50, 20)
    elseif unit == "targettarget" or unit == "focus" or unit == "pet" then
    health:SetSize(width/2, 24)
    end
    health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)

    health:SetStatusBarTexture(texture)
    health:SetStatusBarColor(0.25, 0.25, 0.25) -- foreground


    health.colorReaction = true
    health.colorClass = true
 
    -- create a background for the health bar
    local healthBG = health:CreateTexture(nil, "BACKGROUND")
    healthBG:SetAllPoints()
    healthBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

    healthBG.multiplier = 0.3
    health.bg = healthBG

    self.Health = health
    self.Health.border = border(health)
 
    local healthText = health:CreateFontString(nil, "OVERLAY")
    healthText:SetPoint("RIGHT", health, "RIGHT", -5, 0)
    healthText:SetFont(font,size,"OUTLINEMONOCHROME")
    if unit == "player" or unit == "target" or (unit and unit:find("boss%d")) then
    self:Tag(healthText, "[dead][ns:hp]")
    elseif unit == "targettarget" or unit == "focus" or unit == "pet" then
    self:Tag(healthText, "[ns:hp]")
    end

    if unit == "targettarget" or unit == "focus" or unit == "pet" then
    	local nameText = health:CreateFontString(nil,"OVERLAY")
    	nameText:SetPoint("LEFT", health, "LEFT", 2,0)
    	nameText:SetFont(font,size, "OUTLINEMONOCHROME")
    	self:Tag(nameText, "[name:raid]")
    end
--==============--
-- Power Bar    --
--==============--
if unit == "player" or unit == "target" or (unit and unit:find("boss%d")) then
    local power = CreateFrame("StatusBar", nil, self)
    if unit == "player" or unit == "target" then
      power:SetSize(width , 4)
      power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0 , -5)
    elseif (unit and unit:find("boss%d")) then
      power:SetSize(width-50, 4)
      power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0 , -5)
    end



      self.Power = power
      self.Power.border = border(power)
      power.frequentUpdates = true
      power.colorTapping = true
      power.colorDisconnected = true
      power.colorHappiness = true
      power.colorPower = true
      power.colorClass = true
      power.colorReaction = true

    local powerBG = power:CreateTexture(nil, "BACKGROUND")
      powerBG:SetAllPoints()
      powerBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

      powerBG.multiplier = 0.3
      power.bg = powerBG

-- Text depending on Unit
      local powerText = power:CreateFontString(nil, "OVERLAY")
      powerText:SetFont(font, size, "OUTLINEMONOCHROME")

      if unit == "player" then
       powerText:SetPoint("LEFT", health, 5, 0)
       self:Tag(powerText, "[ns:pp]")

      elseif unit == "target" or (unit and unit:find("boss%d")) then
      powerText:SetPoint("LEFT", health, 5, 0)
      self:Tag(powerText, "[level] |cffffffff[name:normal]|r")

      elseif unit == "targettarget" or unit == "pet" or unit == "focus" then
        powerText:SetPoint("LEFT", health, 2, 0)
        self:Tag(powerText, "[name:raid]")

    end
    if (unit and unit:find("boss%d")) then
    	local bossperc = power:CreateFontString(nil,"OVERLAY")
    	bossperc:SetFont(font, size, "OUTLINEMONOCHROME")
    	bossperc:SetPoint("RIGHT", power, -5,-4)
    	self:Tag(bossperc, "[perpp]")
    end

end
 
--===================--
-- Raid Icons        --
--===================--
-- Position and size
local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
RaidIcon:SetSize(17, 17)
if unit == "target" or unit == "player" then
RaidIcon:SetPoint("CENTER", health,"CENTER",-8,0)
elseif unit == "targettarget" or unit == "focus" then
RaidIcon:SetPoint("CENTER", health, "CENTER",0,12)
elseif (unit and unit:find("boss%d")) then
RaidIcon:SetPoint("RIGHT", health, "RIGHT",-24,0)
end

-- Register it with oUF
self.RaidIcon = RaidIcon
--===================--
-- Aggro Indicator   --
--===================--
if unit == "target" then
-- Position and size
local Threat = health:CreateFontString(nil, 'OVERLAY')
Threat:SetSize(17, 17)
Threat:SetPoint("CENTER", health, "CENTER", 8, 0)
Threat:SetFont(font,size,"OUTLINEMONOCHROME")
Threat:SetText("A!")
Threat:SetTextColor(1, 0, 0)

-- Register it with oUF
self.Threat = Threat
end
--===================--
-- COMBAT INDICATOR  --
--===================--
local statusIndicator = CreateFrame("Frame")
    statusIndicator:SetFrameLevel(self.Health:GetFrameLevel()+1)
    local statusText = health:CreateFontString(nil,"OVERLAY")
    statusText:SetPoint("CENTER", health, "CENTER", 8, 0)
    statusText:SetFont(font,size,"OUTLINEMONOCHROME")



        local function updateStatus()
            if UnitAffectingCombat("player") and unit == "player" then
                statusText:SetText("C!")
                statusText:SetTextColor(1, 0, 0)
            elseif IsResting() and unit == "player" then
                statusText:SetText("R!")
                statusText:SetTextColor(.8, .8, .8)
            else
                statusText:SetText("")
            end
        end

        local function checkEvents()

            statusText:Show()
            statusIndicator:RegisterEvent("PLAYER_ENTERING_WORLD")
            statusIndicator:RegisterEvent("PLAYER_UPDATE_RESTING")

            statusIndicator:RegisterEvent("PLAYER_REGEN_ENABLED")
            statusIndicator:RegisterEvent("PLAYER_REGEN_DISABLED")


            updateStatus()
        end
            checkEvents()

            statusIndicator:SetScript("OnEvent", updateStatus)

--==================--
-- AURAS       WIP  --
--==================--
if unit == "target" then
local Buffs = CreateAura(self, 7)

        Buffs:SetPoint("BOTTOM", self, "BOTTOM", 3, -36)

		Buffs.disableCooldown = false
        Buffs.initialAnchor = "BOTTOMRIGHT"
        Buffs["growth-x"] = "LEFT"


        self.Buffs = Buffs
    	self.Buffs.PostCreateIcon = PostCreateIcon
end

	if unit == "target" then
		local Debuffs = CreateAura(self, 7)
        Debuffs:SetPoint("BOTTOM", self, "BOTTOM", 197, -69)


        Debuffs.showDebuffType = false
        Debuffs.disableCooldown = true


        Debuffs.initalAnchor = "BOTTOMRIGHT"
        Debuffs["growth-x"] = "LEFT"
        self.Debuffs = Debuffs
        self.Debuffs.PostCreateIcon = PostCreateIcon
	elseif unit == "targettarget" or unit == "focus" then
		local Debuffs = CreateAura(self, 3)
		Debuffs.showDebuffType = false
        Debuffs.disableCooldown = true
        self.Debuffs = Debuffs
        self.Debuffs.PostCreateIcon = PostCreateIcon
		Debuffs:SetPoint("RIGHT", self, "RIGHT", 106, 0)
	end


-- CASTBAR OPTION

if activeCastbar == true then
--==================--
-- GCD TIMER        --
--==================--
local gcd = CreateFrame('StatusBar', nil, self)
	gcd:SetSize(200, 4)
	gcd:SetStatusBarTexture(texture)
	gcd:SetStatusBarColor(0.9, 0.9, 0.9, 1)
	gcd:SetPoint('Center', UIParent, 'Center', cbx, cby - 15)
			
local gcdbg = gcd:CreateTexture(nil, 'BACKGROUND')
	gcdbg:SetAllPoints(gcd)
	gcdbg:SetTexture(0, 0, 0, 0.6)
			
self.GCD = gcd
self.GCD.border = border(gcd)

--==================--
--   Eclipse Bar    --
--==================--
--[[
        if (playerClass == 'Druid') then
            local EclipseBar = CreateFrame('Frame', nil, self)
            EclipseBar:SetPoint('CENTER' UIParent, 'CENTER', cbx, cby+15)
            EclipseBar:SetSize(200, 4)
            

            local LunarBar = CreateFrame('StatusBar', nil, EclipseBar)
            LunarBar:SetPoint('LEFT', EclipseBar, 'LEFT', 0, 0)
            LunarBar:SetSize(200, 4
            LunarBar:SetStatusBarTexture(texture)
            LunarBar:SetStatusBarColor(1, 1, 1)
            EclipseBar.LunarBar = LunarBar

            local SolarBar = CreateFrame('StatusBar', nil, EclipseBar)
            SolarBar:SetPoint('LEFT', LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
            SolarBar:SetSize(200, 4
            SolarBar:SetStatusBarTexture(texture)
            SolarBar:SetStatusBarColor(1, 3/5, 0)
            EclipseBar.SolarBar = SolarBar
            local EclipseBarText = EclipseBarBorder:CreateFontString(nil, 'OVERLAY')
            EclipseBarText:SetPoint('CENTER', EclipseBarBorder, 'CENTER', 0, 0)
            EclipseBarText:SetFont(Settings.Media.Font, Settings.Media.FontSize, 'OUTLINE')
            self:Tag(EclipseBarText, '[pereclipse]%')

            self.EclipseBar.border = border(EclipseBar)
            self.EclipseBar = EclipseBar
        end
            -]]


--==================--
--      Castbar     --
--==================--
if unit == "player" or unit == "target" then
    local Castbar = CreateFrame("StatusBar", nil, self)

    if unit == "player" then
        Castbar:SetHeight(17)
        Castbar:SetWidth(200)
        Castbar:SetPoint("CENTER",UIParent,"CENTER",cbx,cby)
   	elseif unit == "target" then
        Castbar:SetHeight(24)
        Castbar:SetWidth(144)
        Castbar:SetPoint("CENTER",UIParent,"CENTER",cbx, cby-30)
     end   
        -- Add spell text
        local CastText = Castbar:CreateFontString(nil, "OVERLAY")
        CastText:SetPoint("LEFT", Castbar,5,-1)
        CastText:SetFont(font, size, "OUTLINEMONOCHROME")

        -- Add spell icon
        local CastIcon = Castbar:CreateTexture(nil, "OVERLAY")
        if unit == "target" then
            CastIcon:SetSize(24,24)
            CastIcon:SetPoint("TOPLEFT", Castbar, "TOPLEFT", -26, 0)
        else
            CastIcon:SetSize(25, 25)
            CastIcon:SetPoint("TOPLEFT", Castbar, "TOPLEFT",-28,0)

        end
        CastIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)


        -- Add Shield
        local CastShield = Castbar:CreateTexture(nil, "OVERLAY")
        CastShield:SetSize(40, 40)
        CastShield:SetPoint("CENTER", CastIcon, "CENTER")

    local Background = Castbar:CreateTexture(nil,"BACKGROUND")
    Background:SetVertexColor(0,0,0,.4)
    Background.multiplier = 0.3
    Background.Alpha = 0.5
    Background:SetAllPoints(Castbar)
    Background:SetTexture(texture)
    Castbar:SetStatusBarTexture(texture)
    Castbar:SetStatusBarColor(0.9, 0.9, 0.9, 1)
    -- Add a timer
    local CastTime = Castbar:CreateFontString(nil, "OVERLAY")
    CastTime:SetPoint("RIGHT", Castbar, -5, -1)
    CastTime:SetFont(font, size, "OUTLINEMONOCHROME")

    -- Add safezone
    local SafeZone = Castbar:CreateTexture(nil, "OVERLAY")

    self.Castbar = Castbar
    self.Castbar.bg = Background
    self.Castbar.Time = CastTime
    self.Castbar.Text = CastText
    self.Castbar.Icon = CastIcon
    self.Castbar.SafeZone = SafeZone
    self.Castbar.border = border(Castbar)
end
end
--==================--
-- ComboPoints      --
--==================
--[[
if unit == "player" then
   local CPoints = {}
   for index = 1, MAX_COMBO_POINTS do
      local CPoint = self:CreateTexture(nil, 'BACKGROUND')
   
      -- Position and size of the combo point.
      CPoint:SetSize(12, 16)
      CPoint:SetPoint('TOPLEFT', health, 'BOTTOMLEFT', index * CPoint:GetWidth(), 40)
   
      CPoints[index] = CPoint
   end
end
   -- Register with oUF
   self.CPoints = CPoints
]]
--=================--
-- Range Fader     --
--=================--
local range = {
    insideAlpha = 1,
    outsideAlpha = 1/2,
}
self.Range = range
-- END OF FUNCTION
end
--============================--
--register and activate style --
--============================--
    oUF:RegisterStyle("oUF_tree", Style)  
    oUF:SetActiveStyle("oUF_tree")
 
    --spawn player
    local player = oUF:Spawn("player")
    player:SetPoint("CENTER",-260,-100)
 
    --spawn target
    local target = oUF:Spawn("target")
    target:SetPoint("CENTER",260,-100)

    local tot = oUF:Spawn("targettarget")
    tot:SetPoint("BOTTOM",target,"RIGHT",-30, 20)

    local pet = oUF:Spawn("pet")
    pet:SetPoint("LEFT",player,"LEFT",-83,0)

    local focus = oUF:Spawn("focus")
    focus:SetPoint("BOTTOM",player,"RIGHT",-30,20)

    --Spawn bossframes

    local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
        boss[i] = oUF:Spawn("boss"..i, "TreeBoss"..i)
            if i == 1 then
                boss[i]:SetPoint("TOPLEFT", UIParent, 205, -20)
            else
                boss[i]:SetPoint('BOTTOM', boss[i-1], 'BOTTOM', 0, -30)             
            end
        boss[i]:SetSize(width, 20)
    end
