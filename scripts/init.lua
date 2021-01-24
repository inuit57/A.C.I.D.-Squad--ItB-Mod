local function init(self)

	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	--require(self.scriptPath.."animations")
	--modApi:addWeapon_Texts(require(self.scriptPath.."weapons_text"))


	-- add some effect? laser... or another things. 
	
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

end


--GetSkillEffect() is called before it does stuff (often several times), so you will need to set variables that stores the queued state via ret:AddScript()



local function load(self,options,version)

	--assert(package.loadlib(self.resourcePath .."/lib/utils.dll", "luaopen_utils"))()
	modApi:addSquadTrue({"A.rtificial Mechs","narD_LaserMech","narD_CorruptedMech","narD_VatMech"},"A.rtificial Mechs","A.C.I.D. Bonus : ??? ",self.resourcePath.."/icon.png")
-- Name Brainstorming.
-- {Corrupted Plague, Living Plague, Corrupted Blodd, ... }

--modApi:addNextTurnHook(function()
	--DelayHeal:DelayRepair()
--end)

end



return {
	id = "narD_ACID_Squad", 
	name = "A.rtificial Mechs", 
	version = "1.0.0", 
	requirements = {},
	init = init,
	load = load,
	description = "Team A.C.I.D. "  
}
