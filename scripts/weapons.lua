local wt2 = {	
	narD_acid_Charge_Upgrade1 = "+ A.C.I.D.", 
	narD_acid_Charge_Upgrade2 = "+1 Damage", 

	narD_Shrapnel_Upgrade1 =  "Building Immune",--"- selfRepair ", --"+ A.C.I.D.", 
	narD_Shrapnel_Upgrade2 = "+1 Damage", 

	narD_VATthrow_Upgrade1 =  "+ Timer",  --"- selfRepair ", --
	narD_VATthrow_Upgrade2 = "+1 Damage",

	narD_PullBeam_Upgrade1 = "- 1 self Damage",
	narD_PullBeam_Upgrade2 = "+1 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local function isTipImage()
	return Board:GetSize() == Point(6,6)
end


narD_acid_Charge = Skill:new{
	Name = "A.C.I.D. charge",
	Class = "Brute", 
	Icon = "weapons/acid_sonic.png", --"weapons/brute_beetle.png",	
	Description = "Charge and leave A.C.I.D. on every tile in the path. ",
	Rarity = 3,
	--Explosion = "ExploAir1",
	Push = 1,--TOOLTIP HELPER
	Fly = 1,
	Damage = 1,
	
	SpeedLimiter = false, 
	Acid = 0,

	BackSmoke = 0,
	PathSize = INT_MAX,
	Cost = "med",
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {1,3},
	LaunchSound = "/weapons/charge",
	ImpactSound = "/weapons/charge_impact",
	ZoneTargeting = ZONE_DIR,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}

function narD_acid_Charge:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	

	local pathing = PATH_PROJECTILE
	if self.Fly == 0 then pathing = Pawn:GetPathProf() end

	local doDamage = true
	local target = GetProjectileEnd(p1,p2,pathing)

	if self.SpeedLimiter then
		target = p2
	end

	local distance = p1:Manhattan(target)
	local selfDamage
	
	if not Board:IsBlocked(target,pathing) then -- dont attack an empty edge square, just run to the edge
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	
	-- if self.BackSmoke == 1 then
	-- 	local smoke = SpaceDamage(p1 - DIR_VECTORS[direction], 0)
	-- 	smoke.iSmoke = 1
	-- 	ret:AddDamage(smoke)
	-- end
	
	local damage = SpaceDamage(target, self.Damage, direction ) --(direction-1)%4)
	damage.sAnimation = "ExploAir2"
	damage.iAcid = self.Acid
	damage.sSound = self.ImpactSound

	local acid_Bonus = Board:GetPawn(p1):IsAcid() 
	
	-- if acid_Bonus then -- or Board:IsPawnSpace(target) and Board:GetPawn(target):IsAcid() then
	-- 	damage.iDamage = self.Damage + 1
	-- end

	if distance == 1 and doDamage then
		--ret:AddMelee(p1,damage, NO_DELAY)
		
		--ret:AddDelay(0.1)
		--if doDamage then
			selfDamage = SpaceDamage( target - DIR_VECTORS[direction] , 0 , direction)--(direction+1)%4)
			--selfDamage.iAcid = 1
			--selfDamage.iFire = 1

			if acid_Bonus then
				selfDamage.iAcid =  EFFECT_REMOVE
				selfDamage.iDamage = -1  
			end

			ret:AddDamage(selfDamage)
			ret:AddDelay(0.2)
		--end

		ret:AddDamage(damage)
		
	else
		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), NO_DELAY)--FULL_DELAY)

		local temp = p1 
		local i = 0 
		local damageACID
		local damage2

		while temp ~= target  do 
			ret:AddBounce(temp,-3)
			--i = 0

			if temp ~= target - DIR_VECTORS[direction] then
				damageACID = SpaceDamage(temp,0)
				--if Board:GetPawn(p1):IsAcid() then
					damageACID.iAcid = 1
				--end
				--damage.fDelay = 0.1
				ret:AddDamage(damageACID)
				
				if false and acid_Bonus then ---self.SpeedLimiter  then -- and (i % 2) ~= 0 then

					damage2 = SpaceDamage(temp + DIR_VECTORS[(direction+1)%4], 0, (direction-1)%4)
					damage2.sAnimation = "exploout0_"..(direction-1)%4
					ret:AddDamage(damage2)
				end
				-- else
				-- --ret:AddDelay(0.05) 
				-- 	damage2 = SpaceDamage(temp + DIR_VECTORS[(direction-1)%4], 0, (direction+1)%4)
				-- 	damage2.sAnimation = "exploout0_"..(direction+1)%4
				-- 	ret:AddDamage(damage2)
				-- end
				

				-- damage2 = SpaceDamage(temp + DIR_VECTORS[(direction-1)%4], 0, (direction+1)%4)
				-- damage2.sAnimation = "exploout0_"..(direction+1)%4
				-- ret:AddDamage(damage2)
			end

			i = i + 1 
			temp = temp + DIR_VECTORS[direction]
			-- if temp ~= target then
			-- 	ret:AddDelay(0.06)
			-- end
		end
		
		
		if doDamage then
			
			selfDamage = SpaceDamage( target - DIR_VECTORS[direction]  ,0, direction) --(direction+1)%4)
			--selfDamage.iAcid = 1
			--selfDamage.iFire = 1
			if acid_Bonus then
				selfDamage.iAcid = EFFECT_REMOVE
				selfDamage.iFire = EFFECT_REMOVE
				selfDamage.iDamage = -1  
			end

			ret:AddDamage(selfDamage)
			ret:AddDelay(0.2)
			ret:AddDamage(damage)
		end
	
	end
	

	return ret
end


narD_acid_Charge_A = narD_acid_Charge:new{
	--UpgradeDescription = " pulling units from the left, and can stop wanted point.",
	--SpeedLimiter = true,
	Acid = 1,	
}

narD_acid_Charge_B = narD_acid_Charge:new{
	UpgradeDescription = "Increases Damage by 1.",
	Damage = 2,
}

narD_acid_Charge_AB = narD_acid_Charge:new{
	--SpeedLimiter = true,
	Acid = 1,
	Damage = 2,
}

----

narD_PullBeam = LaserDefault:new{
	Name = "Pull Beam",
	Class = "Prime",
	Description = "Pulls (and damages) all units in a line.",
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
	
	acid_repair = true,

	Upgrades = 2,
	UpgradeCost = { 1, 3 },

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
		temp_dmg = temp_dmg*2 
		min_dmg = min_dmg*2 

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
	SelfDamage = -1,
}

narD_PullBeam_B = narD_PullBeam:new{ --
	UpgradeDescription = "Increases Damage by 1.",
	Damage = 2, 
}

narD_PullBeam_AB = narD_PullBeam:new{ 
	--FriendlyDamage = false,
	SelfDamage = -1,
	Damage = 3, 
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

	UpgradeCost = {1, 3},

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
		damage.iDamage = self.Damage *2  
		
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

		if Board:IsValid(p2) and not Board:IsBlocked(p2,PATH_PROJECTILE)  then
			
			--damagepush.iAcid = 1
			--damagepush.iDamage = self.MinDamage
			
			-- if acid_Bonus and (Board:IsPawnTeam(temp_point, TEAM_PLAYER) or Board:IsBuilding(temp_point)) then
			-- 	damagepush.iDamage = 0
			-- end
		end
		
		damagepush.sAnimation = "airpush_"..((dir+1)%4)
		ret:AddDamage(damagepush) 
		
		
		temp_point = p2 + DIR_VECTORS[(dir-1)%4]
		damagepush = SpaceDamage(temp_point, 0, (dir-1)%4)
		if Board:IsValid(p2) and not Board:IsBlocked(p2,PATH_PROJECTILE)  then
			--damagepush.iAcid = 1
			--damagepush.iDamage = self.MinDamage

			-- if acid_Bonus and (Board:IsPawnTeam(temp_point, TEAM_PLAYER) or Board:IsBuilding(temp_point) )then
			-- 	damagepush.iDamage = 0
			-- end			
		end

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
	Damage = 2,
} 

narD_VATthrow_AB = narD_VATthrow:new{
	VatFire = 1,
	Damage = 2,
	--VatPawn = "narD_ACIDVat_AB", 
} 



narD_Shrapnel = TankDefault:new	{

	Name = "A.C.I.D. Shrapnel",
	Description = "needs description ", 

	Class = "Brute",
	Damage = 0,
	Icon = "weapons/brute_shrapnel.png",
	Explosion = "",
	Sound = "/general/combat/explode_small",
	Damage = 1,
	Push = 1,
	PowerCost = 0,
	Acid = 1, 
	acid_repair = true, 
	LaunchSound = "/weapons/shrapnel",
	ImpactSound = "/impact/generic/explosion",
	ZoneTargeting = ZONE_DIR,

	BuildingImmune = false,
	Upgrades = 2,
	UpgradeCost = {2, 3},

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
		damage.iDamage = self.Damage *2 
	else
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  1 
		ret:AddDamage(selfDamage)
	end

	ret:AddProjectile(damage, "effects/shot_shrapnel")

	if (self.BuildingImmune) and Board:IsBuilding(p2) then 
		damage.iDamage = 0
	end
--	ret.path = Board:GetSimplePath(p1, target)
	



	for dir = 0, 3 do
		damage = SpaceDamage(target + DIR_VECTORS[dir], self.Damage , dir)
		damage.iAcid = self.Acid 

		if Board:GetPawn(p1):IsAcid() then
			damage.iDamage = self.Damage *2 
		end

		if (self.BuildingImmune) and (Board:IsBuilding(target + DIR_VECTORS[dir])) then 
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
	--Acid = 1, 
	--acid_repair = false,
	BuildingImmune = true,
	--VatPawn = "narD_ACIDVat_AB",
} 

narD_Shrapnel_B = narD_Shrapnel:new{
	UpgradeDescription = "Increases Damage by 2.", --"Increases Vat's HP by double.",
	Damage = 2,
} 

narD_Shrapnel_AB = narD_Shrapnel:new{
	--Acid = 1,
	--acid_repair = false,
	BuildingImmune = true,
	Damage = 2,
	--VatPawn = "narD_ACIDVat_AB", 
} 