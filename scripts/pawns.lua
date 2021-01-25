-- 매크들을 여기서 정의한다. 


narD_LaserMech = Pawn:new { 
	Name = "C.orrosive Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Armor = true,
	Flying = true,
	Image = "MechLaser", 
	ImageOffset = 7,
	SkillList = { "narD_PullBeam"  } ,
	SoundLocation = "/mech/prime/punch_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}

AddPawn("narD_LaserMech")

narD_CorruptedMech = Pawn:new  {
	Name = "I.nsect Mech",
	Class = "Brute", --Brute
	Health = 3,
	Image = "MechBeetle", --"MechCharge", 
	ImageOffset = 7,
	MoveSpeed = 3,
	SkillList = { "narD_Shrapnel" }, -- "narD_acid_Charge"  }, 
	Flying = false,
	SoundLocation = "/mech/brute/charge_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}
	
AddPawn("narD_CorruptedMech") 

narD_VatMech = Pawn:new {
	Name = "D.issolver Mech",
	Class = "Ranged",
	Health = 2,
	Image = "MechRockart",
	ImageOffset = 7,
	Flying = true,
	MoveSpeed = 3,
	Flying = false,
	SkillList = { "narD_VATthrow" },-- "narD_Acid_Repair"  },
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}

AddPawn("narD_VatMech") 


-- narD_ACIDVat = Pawn:new{
-- 	Name = "Little Acid Vat",
-- 	Health = 2,--1,
-- 	Neutral = true,
-- 	MoveSpeed = 0,
-- 	Image = "barrel1", --"narD_acdidVat" , --
-- 	DefaultTeam = TEAM_NONE, -- TEAM_PLAYER,
-- 	IsPortrait = false,
-- 	--Minor = true,
-- 	--Mission = true,
-- 	Tooltip = "Acid_Death_Tooltip",
-- 	IsDeathEffect = true,
-- }
-- AddPawn("narD_ACIDVat") 

-- function narD_ACIDVat:GetDeathEffect(point)
-- 	local ret = SkillEffect()
	
-- 	local dam = SpaceDamage(point)

-- 	--dam.iTerrain = TERRAIN_WATER
-- 	dam.iAcid = 1
-- 	dam.sAnimation = "splash"--hack
-- 	dam.sSound = "/props/acid_vat_break"
-- 	ret:AddDamage(dam)

-- 	for i = DIR_START, DIR_END do
-- 		dam = SpaceDamage(point + DIR_VECTORS[i])
-- 		dam.iAcid = 1
-- 		dam.sAnimation = "splash"--hack
-- 		dam.sSound = "/props/acid_vat_break"
-- 		ret:AddDamage(dam)
-- 	end

-- 	return ret
-- end

-- Acid_Death_Tooltip = SelfTarget:new{
-- 	Class = "Death",
-- 	TipImage = {
-- 		Unit = Point(2,2),
-- 		Target = Point(2,2),
-- 		CustomPawn = "narD_ACIDVat"
-- 	}
-- }

-- function Acid_Death_Tooltip:GetSkillEffect(p1,p2)
-- 	local ret = SkillEffect()
-- 	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
-- 	space_damage.bHide = true
-- 	space_damage.sAnimation = "ExploAir2" 
-- 	ret:AddDelay(1)
-- 	ret:AddDamage(space_damage)
-- 	ret:AddDelay(1)
-- 	return ret
-- end



--[[
narD_ACIDVat_A = narD_ACIDVat:new{
	Health = 4, 
}

narD_ACIDVat_AB = narD_ACIDVat:new{
	Health = 2,
	--Image = "pawns/acid_bomb.png" ,--"barrel1",
}

function narD_ACIDVat_AB:GetDeathEffect(point)
	local ret = SkillEffect()
	
	local dam = SpaceDamage(point)

	dam.iTerrain = TERRAIN_WATER
	dam.iAcid = 1
	dam.sAnimation = "splash"--hack
	dam.sSound = "/props/acid_vat_break"
	ret:AddDamage(dam)

	for i = DIR_START, DIR_END do
		dam = SpaceDamage(point + DIR_VECTORS[i])
		dam.iAcid = 1
		dam.sAnimation = "splash"--hack
		dam.sSound = "/props/acid_vat_break"
		ret:AddDamage(dam)
	end

	return ret
end
]]
--AddPawn("narD_ACIDVat_A") 