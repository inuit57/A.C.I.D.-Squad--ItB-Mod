local function init(self)
	require(self.scriptPath.."FURL")(self, {

		{
			Type = "mech",
			Name = "InsectMech",
			Filename = "mech_bug",
			Path = "img/units", 
			ResourcePath = "units/player",

			Default =           {  PosX = -22, PosY = 4  },
			Animated =          {  PosX = -20, PosY = 4 , NumFrames = 4},  -- 이거가 행거에서 보이는 위치 
			Broken =            {  PosX = -22, PosY = 4, },
			Submerged =         { PosX = -22, PosY = 10 },
			SubmergedBroken =   { PosX = -20, PosY = 10 },
			Icon =              {},
		},

		{
			Type = "mech",
			Name = "BallMech",
			Filename = "boll",
			Path = "img/units", 
			ResourcePath = "units/player",

			Default =           {  PosX = -18, PosY = -6  },
			Animated =          {  PosX = -22, PosY = -3 , NumFrames = 4},  -- 이거가 행거에서 보이는 위치 
			Broken =            {  PosX = -20, PosY = -6, },
			Submerged =         { PosX = -26, PosY = 4},
			SubmergedBroken =   { PosX = -22, PosY = 4 },
			Icon =              {},
		},
		
		{
			Type = "mech",
			Name = "MangonelleMech",
			Filename = "Mangonelle",
			Path = "img/units", 
			ResourcePath = "units/player",

			Default =           {  PosX = -18, PosY = -6  },
			Animated =          {  PosX = -24, PosY = -6 , NumFrames = 4},  -- 이거가 행거에서 보이는 위치 
			Broken =            {  PosX = -24, PosY = -6, },
			Submerged =         { PosX = -26, PosY = 4},
			SubmergedBroken =   { PosX = -22, PosY = 4 },
			Icon =              {},
		},
		
	});

	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	--require(self.scriptPath.."animations")
	--modApi:addWeapon_Texts(require(self.scriptPath.."weapons_text"))


	-- add some effect? laser... or another things. 
	
	--modApi:appendAsset("img/units/Pilot_narD_CorruptedMech.png", self.resourcePath .."img/units/Pilot_narD_CorruptedMech.png")

	modApi:appendAsset("img/weapons/vat_throw.png",self.resourcePath.."img/weapons/vat_throw.png")
	modApi:appendAsset("img/weapons/acid_laser.png",self.resourcePath.."img/weapons/acid_laser.png")
	modApi:appendAsset("img/weapons/acid_bomb_throw.png",self.resourcePath.."img/weapons/acid_bomb_throw.png")
	modApi:appendAsset("img/weapons/acid_sonic.png",self.resourcePath.."img/weapons/acid_sonic.png")

	modApi:appendAsset("img/units/acidvat_img.png",self.resourcePath.."img/units/acidvat_img.png")
	modApi:appendAsset("img/units/acid_bomb.png",self.resourcePath.."img/units/acid_bomb.png")

	local a = ANIMS -- thank you, tosx. :D
	-- -- a.tosx_IceHulk = a.BaseUnit:new{Image = "units/enemy/tosx_icehulk.png", PosX = -37, PosY = -19}
	-- -- a.tosx_IceHulkd = a.tosx_IceHulk:new{Image = "units/enemy/tosx_icehulk_d.png", PosX = -22, PosY = -10, NumFrames = 11, Time = 0.14, Loop = false }
	
	a.narD_acdidVat = a.Animation:new{Image = "units/acidvat_img.png", PosX = -17, PosY = -5 , Loop = true, Time = 0.3 }
	a.narD_acdidVatd = a.narD_acdidVat:new{Loop = false, Time = 0.5}
	a.narD_acidVata = a.Animation:new{Image = "units/acidvat_img.png", PosX = -17, PosY = -5 , Loop = true, Time = 0.3 }
	-- barrel1 = 	BaseUnit:new{ Image = "units/mission/barrel.png", PosX = -17, PosY = -5 }
	-- barrel1d = 	barrel1:new
	
	modApi:appendAsset("img/effects/laser_acid_hit.png",self.resourcePath.."img/effects/laser_acid_hit.png")
	modApi:appendAsset("img/effects/laser_acid_R.png",self.resourcePath.."img/effects/laser_acid_R.png")
	modApi:appendAsset("img/effects/laser_acid_R1.png",self.resourcePath.."img/effects/laser_acid_R1.png")
	modApi:appendAsset("img/effects/laser_acid_R2.png",self.resourcePath.."img/effects/laser_acid_R2.png")
	modApi:appendAsset("img/effects/laser_acid_start.png",self.resourcePath.."img/effects/laser_acid_start.png")
	modApi:appendAsset("img/effects/laser_acid_U.png",self.resourcePath.."img/effects/laser_acid_U.png")
	modApi:appendAsset("img/effects/laser_acid_U1.png",self.resourcePath.."img/effects/laser_acid_U1.png")
	modApi:appendAsset("img/effects/laser_acid_U2.png",self.resourcePath.."img/effects/laser_acid_U2.png")

	local laser = {"laser_acid"}
	for i,v in pairs(laser) do
		Location["effects/"..v.."_U.png"] = Point(-12,3)
		Location["effects/"..v.."_U1.png"] = Point(-12,3)
		Location["effects/"..v.."_U2.png"] = Point(-12,3)
		Location["effects/"..v.."_R.png"] = Point(-12,3)
		Location["effects/"..v.."_R1.png"] = Point(-12,3)
		Location["effects/"..v.."_R2.png"] = Point(-12,3)
		Location["effects/"..v.."_hit.png"] = Point(-12,3)
		Location["effects/"..v.."_start.png"] = Point(-12,3)
	end

	modApi:appendAsset("img/effects/m_laser_acid_hit.png",self.resourcePath.."img/effects/m_laser_acid_hit.png")
	modApi:appendAsset("img/effects/m_laser_acid_R.png",self.resourcePath.."img/effects/m_laser_acid_R.png")
	modApi:appendAsset("img/effects/m_laser_acid_R1.png",self.resourcePath.."img/effects/m_laser_acid_R1.png")
	modApi:appendAsset("img/effects/m_laser_acid_R2.png",self.resourcePath.."img/effects/m_laser_acid_R2.png")
	modApi:appendAsset("img/effects/m_laser_acid_start.png",self.resourcePath.."img/effects/m_laser_acid_start.png")
	modApi:appendAsset("img/effects/m_laser_acid_U.png",self.resourcePath.."img/effects/m_laser_acid_U.png")
	modApi:appendAsset("img/effects/m_laser_acid_U1.png",self.resourcePath.."img/effects/m_laser_acid_U1.png")
	modApi:appendAsset("img/effects/m_laser_acid_U2.png",self.resourcePath.."img/effects/m_laser_acid_U2.png")

	local m_laser = {"m_laser_acid"}
	for i,v in pairs(m_laser) do
		Location["effects/"..v.."_U.png"] = Point(-12,3)
		Location["effects/"..v.."_U1.png"] = Point(-12,3)
		Location["effects/"..v.."_U2.png"] = Point(-12,3)
		Location["effects/"..v.."_R.png"] = Point(-12,3)
		Location["effects/"..v.."_R1.png"] = Point(-12,3)
		Location["effects/"..v.."_R2.png"] = Point(-12,3)
		Location["effects/"..v.."_hit.png"] = Point(-12,3)
		Location["effects/"..v.."_start.png"] = Point(-12,3)
	end


	require(self.scriptPath .."achievements/init")
	require(self.scriptPath .."achievements")
	require(self.scriptPath .."achievementTriggers"):init()
	local achvApi = require(self.scriptPath.."/achievements/api")

	local shop = require(self.scriptPath .."shop")
	shop:addWeapon({
		id = "narD_PullBeam",
		name = narD_PullBeam.Name,
		desc = "Adds Pull Beam to the store."
	})
	shop:addWeapon({
		id = "narD_VATthrow",
		name = narD_VATthrow.Name,
		desc = "Adds Vat Launcher to the store."
	})
	shop:addWeapon({
		id = "narD_Shrapnel",
		name = narD_Shrapnel.Name,
		desc = "Adds A.C.I.D. Shrapnel to the store."
	})
end


--GetSkillEffect() is called before it does stuff (often several times), so you will need to set variables that stores the queued state via ret:AddScript()



local function load(self,options,version)

	--assert(package.loadlib(self.resourcePath .."/lib/utils.dll", "luaopen_utils"))()
	modApi:addSquadTrue({"A.rtificial Mechs","narD_LaserMech","narD_CorruptedMech","narD_VatMech"},"A.rtificial Mechs","If the Mech is affected by A.C.I.D., cleanse it and deal double damage",self.resourcePath.."/icon.png")
	require(self.scriptPath .."shop"):load(options)



end



return {
	id = "narD_ACID_Squad", 
	name = "A.rtificial Mechs", 
	version = "1.0.3", 
	requirements = {},
	init = init,
	load = load,
	icon ="/icon.png" ,
	description = "If the Mech is affected by A.C.I.D., cleanse it and deal double damage"  
}
