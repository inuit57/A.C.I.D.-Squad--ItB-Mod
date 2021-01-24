--local a = ANIMS -- thank you, tosx. :D
-- a.tosx_IceHulk = a.BaseUnit:new{Image = "units/enemy/tosx_icehulk.png", PosX = -37, PosY = -19}
-- a.tosx_IceHulkd = a.tosx_IceHulk:new{Image = "units/enemy/tosx_icehulk_d.png", PosX = -22, PosY = -10, NumFrames = 11, Time = 0.14, Loop = false }

ANIMS.narD_acdidVat = Animation:new{Image = "pawns/acid_barrel.png", PosX = -17, PosY = -5 , Loop = true, Time = 0.3 }
ANIMS.narD_acdidVatd = Animation:new{Image = "pawns/acid_barrel.png", PosX = -17, PosY = -5 , Loop = false, Time = 0.5}


--[[ANIMS.gaia_zeta_iceblast_U = Animation:new{
	Image = "effects/gaia_zeta_iceblast_U.png",
	NumFrames = 8,
	Time = 0.06,
	PosX = -10,
	PosY = -4
}

ANIMS.gaia_zeta_iceblast_D = Animation:new{
	Image = "effects/gaia_zeta_iceblast_D.png",
	NumFrames = 8,
	Time = 0.0,
	PosX = -30,
	PosY = 11
}

ANIMS.gaia_zeta_iceblast_L = Animation:new{
	Image = "effects/gaia_zeta_iceblast_L.png",
	NumFrames = 8,
	Time = 0.06,
	PosX = -30,
	PosY = -4
}

ANIMS.gaia_zeta_iceblast_R = Animation:new{
	Image = "effects/gaia_zeta_iceblast_R.png",
	NumFrames = 8,
	Time = 0.06,
	PosX = -10,
	PosY = 11
}
]]

-- ANIMS.gaia_zeta_iceblast_0 = Animation:new{
-- 	Image = "effects/gaia_zeta_iceblast_U.png",
-- 	NumFrames = 9,
-- 	Time = 0.06,
-- 	PosX = -10,
-- 	PosY = -4
-- }
-- ANIMS.gaia_zeta_iceblast_1 = ANIMS.gaia_zeta_iceblast_0:new{
-- 	Image = "effects/gaia_zeta_iceblast_R.png",
-- 		PosX = -10,
-- 	PosY = 11
-- }
-- ANIMS.gaia_zeta_iceblast_2 = ANIMS.gaia_zeta_iceblast_0:new{
-- 	Image = "effects/gaia_zeta_iceblast_D.png",
-- 	PosX = -30,
-- 	PosY = 11
-- }
-- ANIMS.gaia_zeta_iceblast_3 = ANIMS.gaia_zeta_iceblast_0:new{
-- 	Image = "effects/gaia_zeta_iceblast_L.png",
-- 	PosX = -30,
-- 	PosY = -4
-- }

--[[
ANIMS.AmmoDrop1 = Animation:new{
	Image = "effects/misc_ammo1.png",
	NumFrames = 7,
	Time = 0.04,
	PosX = -33,
	PosY = -7
}
]]
