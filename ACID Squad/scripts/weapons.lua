local wt2 = {	
	narD_acid_Charge_Upgrade1 = "+ A.C.I.D.", 
	narD_acid_Charge_Upgrade2 = "+1 Max Damage", 

	narD_Shrapnel_Upgrade1 =  "Building Immune",--"- selfRepair ", --"+ A.C.I.D.", 
	narD_Shrapnel_Upgrade2 = "Ally Immune", --"+1 Max Damage", 

	narD_VATthrow_Upgrade1 =  "+ Timer",  --"- selfRepair ", --
	narD_VATthrow_Upgrade2 = "+Side A.C.I.D", --"+1 Max Damage",

	narD_PullBeam_Upgrade1 = "Ally Immune",--"- ACID repair", -- "+ A.C.I.D."
	narD_PullBeam_Upgrade2 = "+ A.C.I.D",-- "+1 Max Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local function isTipImage()
	return Board:GetSize() == Point(6,6)
end



----

narD_PullBeam = LaserDefault:new{
	Name = "Pull Beam",
	Class = "Prime",
	Description = "Pulls and damages all units in a line.",
	Icon = "weapons/acid_laser.png",
	LaserArt = "effects/laser_acid", --"effects/laser_push", -- --laser_fire
	Explosion = "",
	Sound = "",
	PowerCost = 1,
	
	ZoneTargeting = ZONE_DIR,

	LaunchSound = "/weapons/push_beam",
	Damage = 1,
	MinDamage = 0,
	FriendlyDamage = true,
	SelfDamage = 0,
	
	Acid_Damage = 1, 
	acid_repair = true,

	ACID = 0,

	Upgrades = 2,
	UpgradeCost = { 1, 2 },

	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0) 
	} 
}

			
-- function narD_PullBeam:GetTargetArea(point)
-- 	local ret = PointList()
	
-- 	for i = DIR_START, DIR_END do
-- 		for k = 1, 8 do
-- 			local curr = DIR_VECTORS[i]*k + point
-- 			if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) then
-- 			--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
-- 				ret:push_back(DIR_VECTORS[i]*k + point)
-- 			else
-- 				break
-- 			end
-- 		end
-- 	end
	
-- 	return ret
-- end

function narD_PullBeam:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	targets[#targets+1] = curr 
	
	local dam = SpaceDamage(curr, 0)
		
	local temp_dmg = self.Damage	
	local min_dmg = self.MinDamage

	local acid_Bonus = Board:GetPawn(p1):IsAcid()

	if acid_Bonus then 
		temp_dmg = temp_dmg + self.Acid_Damage  -- *2 
		
		ret:AddProjectile(dam,"effects/laser_acid")
	else
		ret:AddProjectile(dam,"effects/m_laser_acid") -- "effects/laser_acid"
				
	end
	
	
	
	for i = 1, #targets do
		local curr = targets[i]
		local damage = SpaceDamage(curr, 0, (dir-2)%4)
		damage.iDamage = temp_dmg

		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
			damage.iAcid = self.ACID
		end

		if not self.FriendlyDamage and Board:IsPawnTeam(curr,TEAM_PLAYER) then
			damage.iDamage = 0 
		end
		
		ret:AddDamage(damage)

		temp_dmg = temp_dmg - 1 
		if temp_dmg < min_dmg then temp_dmg = min_dmg end
	end


	if acid_Bonus and self.acid_repair then 
		local selfDamage = SpaceDamage( p1  ,self.SelfDamage) 
		selfDamage.iAcid =  EFFECT_REMOVE 
		ret:AddDamage(selfDamage)
	else
		local selfDamage = SpaceDamage( p1  ,self.SelfDamage) 
		selfDamage.iAcid =  1 
		ret:AddDamage(selfDamage)
	end

	return ret
end

narD_PullBeam_A = narD_PullBeam:new{ --
	UpgradeDescription = "Increases Damage by 1.",--"Deals no damage to allies.",
	--FriendlyDamage = false,
	--acid_repair = false, 
	FriendlyDamage = false, 
	--SelfDamage = -1,
}

narD_PullBeam_B = narD_PullBeam:new{ --
	UpgradeDescription = "Increases Damage by 1.",
	-- Damage = 2, 
	--Acid_Damage = 2,
	ACID = 1,
}

narD_PullBeam_AB = narD_PullBeam:new{ 
	--FriendlyDamage = false,
	--SelfDamage = -1,
	--acid_repair = false, 
	--Acid_Damage = 2,
	-- Damage = 3, 
	ACID = 1,
	FriendlyDamage = false, 
}
--

narD_ACIDVat = Pawn:new{
	Name = "A.C.I.D. Vat",
	Health = 2,--1,
	Neutral = true,
	MoveSpeed = 0,
	Image =  "narD_acdidVat" , --"barrel1",
	DefaultTeam = TEAM_ENEMY, --TEAM_NONE, -- TEAM_PLAYER,
	IsPortrait = false,
	Minor = true,
	--Mission = true,
	Tooltip = "Acid_Death_Tooltip",
	IsDeathEffect = true,
}
AddPawn("narD_ACIDVat") 

function narD_ACIDVat:GetDeathEffect(point)
	local ret = SkillEffect()
	
	local dam = SpaceDamage(point)

	dam.iTerrain = TERRAIN_WATER
	dam.iAcid = 1
	dam.sAnimation = "splash"--hack
	dam.sSound = "/props/acid_vat_break"
	ret:AddDamage(dam)

	-- for i = DIR_START, DIR_END do
	-- 	dam = SpaceDamage(point + DIR_VECTORS[i])
	-- 	dam.iAcid = 1
	-- 	dam.sAnimation = "splash"--hack
	-- 	dam.sSound = "/props/acid_vat_break"
	-- 	ret:AddDamage(dam)
	-- end

	return ret
end

Acid_Death_Tooltip = SelfTarget:new{
	Class = "Death",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "narD_ACIDVat"
	}
}

function Acid_Death_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
	space_damage.bHide = true
	space_damage.sAnimation = "ExploAir2" 
	ret:AddDelay(1)
	ret:AddDamage(space_damage)
	ret:AddDelay(1)
	return ret
end

--[[
narD_ACIDVat_AB = Pawn:new{
	Name = "Little Acid Vat",
	Health = 1,
	Neutral = true,
	MoveSpeed = 0,
	--Image =  "narD_acdidVat" , --"barrel1",
	DefaultTeam = TEAM_NONE, -- TEAM_PLAYER,
	IsPortrait = false,
	--Minor = true,
	--Mission = true,
	--Tooltip = "Acid_Death_Tooltip",
	IsDeathEffect = true,
}
AddPawn("narD_ACIDVat_AB") 

function narD_ACIDVat_AB:GetDeathEffect(point)
	local ret = SkillEffect()
	
	-- 체력을 안 보이게 아예 투명 유닛으로 만드는 건 어려울까?
	-- Lemon에게 물어볼 것?? 
	-- 일단 막아놓자. 이런 방법을 찾은 것에 의의를 두도록 하자. 

	-- 특정 유닛의 위치 찾기가 되는가?
	local board_size = Board:GetSize()
	--local repaired_units = {}
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			if Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) then
				local pawn_id = Board:GetPawn(Point(i,j)):GetId()
				LOG(Board:GetPawn(Point(i,j)):GetId().."i :"..i.."j:"..j)
				LOG(Board:GetPawn(Point(i,j)):GetMechName())
				LOG()
			end
		end
	end

	local dir = 1 -- 임시...
		
	local damage2 = SpaceDamage(0)
	damage2.loc = point + DIR_VECTORS[(dir+1)%4] 
	ret:AddArtillery(damage2,"effects/shotup_acid.png",NO_DELAY) 

	
	damage2 = SpaceDamage(0)
	damage2.loc = point + DIR_VECTORS[(dir-1)%4]
	ret:AddArtillery(damage2,"effects/shotup_acid.png",NO_DELAY) 

	local dmg3 = SpaceDamage(point, 0)
	--dmg3.loc = point 
	dmg3.sPawn = "narD_ACIDVat"
	ret:AddDamage(dmg3)
	
	return ret
end

]]


narD_VATthrow = ArtilleryDefault:new{-- LineArtillery:new{
	Name = "Vat Launcher",
	Description = "Throws an A.C.I.D. vat that pushes adjacent tiles.", 

	Class = "Ranged",
	Icon =  "weapons/vat_throw.png", --"weapons/acid_bomb_throw.png",
	Sound = "",
	ArtilleryStart = 2,
	ArtillerySize = 8,
	Explosion = "",
	PowerCost = 1,
	BounceAmount = 1,
	Damage = 1,
	--MinDamage = 0,
	LaunchSound = "/weapons/boulder_throw",
	ImpactSound =  "/props/acid_vat_break", --"/impact/dynamic/rock",
	Upgrades = 2,
	Push = false,
	
	acid_repair = true, 

	VatFire = 0,
	VatPawn = "narD_ACIDVat", 


	Acid_Damage = 1,
	SideACID = 0, 
	
	UpgradeCost = {1, 2},

	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2,1),

		Second_Origin = Point(2,4),
		Second_Target = Point(2,2),
	}
}
					
function narD_VATthrow:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.Damage)
	
	--local sub_damage = self.Damage -- 0 


	if Board:IsValid(p2) and not Board:IsBlocked(p2,PATH_PROJECTILE) then
		damage.sPawn = "narD_ACIDVat" 
		
		damage.iDamage = 0
		damage.iFire = self.VatFire
	else 
		damage.sAnimation = "splash" 
		damage.iAcid = 1
	end
	
	ret:AddBounce(p1, 1)

	local acid_Bonus = Board:GetPawn(p1):IsAcid()  
	
	if acid_Bonus then 
		damage.iDamage = self.Damage + self.Acid_Damage --*2  
		
		if self.acid_repair then 
			local selfDamage = SpaceDamage( p1  ,0) 
			selfDamage.iAcid =  EFFECT_REMOVE 
			ret:AddDamage(selfDamage)
		end
	else
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  1 
		ret:AddDamage(selfDamage)
	end

	ret:AddArtillery(damage,"effects/shotup_acid.png")
	-- shotup_acid

	ret:AddBounce(p2, self.BounceAmount)
	ret:AddBoardShake(0.15)


	
	--if sub_damage ~= 0 then  -- 일단, sub_damage를 0으로 놓자. 
		local temp_point = p2 + DIR_VECTORS[(dir+1)%4]
		local damagepush = SpaceDamage(temp_point, 0, (dir+1)%4)

		
		damagepush.sAnimation = "airpush_"..((dir+1)%4)
		damagepush.iAcid = self.SideACID
		ret:AddDamage(damagepush) 
		
		
		temp_point = p2 + DIR_VECTORS[(dir-1)%4]
		damagepush = SpaceDamage(temp_point, 0, (dir-1)%4)
		damagepush.iAcid = self.SideACID

		damagepush.sAnimation = "airpush_"..((dir-1)%4)
		ret:AddDamage(damagepush)
		

	return ret
end

narD_VATthrow_A = narD_VATthrow:new{
	UpgradeDescription = "Add Time bomb to Vat.", --"Increases Vat's HP by two.",
	VatFire = 1, 

	--acid_repair = false,
	--VatPawn = "narD_ACIDVat_AB",
} 

narD_VATthrow_B = narD_VATthrow:new{
	UpgradeDescription = "Increases Damage by 2.", --"Increases Vat's HP by double.",

	SideACID = 1, 
	-- Damage = 2,
	--Acid_Damage = 2,
} 

narD_VATthrow_AB = narD_VATthrow:new{
	VatFire = 1,
	SideACID = 1, 
	-- Damage = 2,
	-- Acid_Damage = 2,
	--VatPawn = "narD_ACIDVat_AB", 
} 



narD_Shrapnel = TankDefault:new	{

	Name = "A.C.I.D. Shrapnel",
	Description = "needs description ", 

	Class = "Brute", 
	Icon = "weapons/enemy_firefly2.png", -- need change?.
	Explosion = "ExploFirefly2",
	Sound = "/general/combat/explode_small",
	Damage = 1,--1,
	
	Push = 1,
	PowerCost = 2,
	Acid = 1, 
	
	Acid_Damage = 1,
	FriendlyDamage = true, 

	acid_repair = true, 
	LaunchSound = "/weapons/shrapnel",
	ImpactSound = "/impact/generic/explosion",
	ZoneTargeting = ZONE_DIR,

	BuildingImmune = false,
	Upgrades = 2,
	UpgradeCost = {2, 2},

	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Enemy2 = Point(2,1),
		Target = Point(2,1)
	}
}
			
function narD_Shrapnel:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = GetProjectileEnd(p1,p2)  
	
	local damage = SpaceDamage(target, self.Damage)
	damage.iAcid = self.Acid 

	if Board:GetPawn(p1):IsAcid() then
		damage.iDamage = self.Damage + self.Acid_Damage --*2 
	else
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  1 
		ret:AddDamage(selfDamage)
	end

	if (self.BuildingImmune) and (Board:IsBuilding(target)) then 
		damage.iDamage = 0
	end

	ret:AddProjectile(damage, "effects/shot_firefly")


--	ret.path = Board:GetSimplePath(p1, target)

	for dir = 0, 3 do
		damage = SpaceDamage(target + DIR_VECTORS[dir], self.Damage , dir)
		damage.iAcid = self.Acid 

		if Board:GetPawn(p1):IsAcid() then
			damage.iDamage = self.Damage + self.Acid_Damage --*2 
		end

		if (self.BuildingImmune) and (Board:IsBuilding(target + DIR_VECTORS[dir])) then 
			damage.iDamage = 0
		end

		if not self.FriendlyDamage and Board:IsPawnTeam(target + DIR_VECTORS[dir],TEAM_PLAYER) then
			damage.iDamage = 0 
		end

		damage.sAnimation = "airpush_"..dir
		if (dir ~= GetDirection(p1 - p2)) and (dir ~= GetDirection(p2 - p1)) then
			ret:AddDamage(damage)
		end
	end
	
	if (self.acid_repair) and (Board:GetPawn(p1):IsAcid()) then
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  EFFECT_REMOVE 
		ret:AddDamage(selfDamage)
	end

	return ret
end

narD_Shrapnel_A = narD_Shrapnel:new{
	UpgradeDescription = "+ Building Immune", --"Increases Vat's HP by two.",
	BuildingImmune = true,

} 

narD_Shrapnel_B = narD_Shrapnel:new{
	UpgradeDescription = "Increases Damage by 2.", --"Increases Vat's HP by double.",
	FriendlyDamage = false,
} 

narD_Shrapnel_AB = narD_Shrapnel:new{
	BuildingImmune = true,
	FriendlyDamage = false,

} 