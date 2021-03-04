local wt2 = {	
	-- not used
	-- narD_acid_Charge_Upgrade1 = "+ A.C.I.D.", 
	-- narD_acid_Charge_Upgrade2 = "+1 Max Damage", 

	narD_Shrapnel_Upgrade1 =  "Building Immune", 
	narD_Shrapnel_Upgrade2 =  "Ally Immune", 

	narD_VATthrow_Upgrade1 =  "back A.C.I.D", --"+ self A.C.I.D",--"+ Timer",  
	narD_VATthrow_Upgrade2 = "+Side A.C.I.D", --"+1 Max Damage",

	narD_PullBeam_Upgrade1 = "back A.C.I.D", --"+ self A.C.I.D", --"Ally Immune",
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
	Description = "Pulls all units in a line. and damages first units.",
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
	self_acid = false,
	BackACID = false,

	ACID = 0,

	Upgrades = 2,
	UpgradeCost = { 2, 2 },

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
	
	if self.BackACID then
		local backDamage = SpaceDamage(p1 - DIR_VECTORS[dir] , 0)
		backDamage.iAcid = 1
		ret:AddDamage(backDamage) 
	end
	
	-- 앞에서부터 끌어당기는 거. 
	-- 문제점 : 맨 앞 놈이 데미지로 죽을 경우 뒤에 충돌피해 없이 그냥 다 땡겨와짐.
	-- (툴팁에서 보여지는 거랑 달라보일 수가 있음)

	
	local curr = targets[1]
	local damage 
	local flag = false
	if Board:IsPawnSpace(curr) then
		--LOG(Board:GetPawn(curr):GetType())
		if (Board:GetPawn(curr):GetHealth() <= (temp_dmg + 1) )  and 
		 	(Board:GetPawn(curr):GetType() ~= "narD_ACIDVat" ) and  -- intended bug.  
		 	(Board:GetPawn(curr):GetType() ~= "AcidVat" ) then --
			flag = true
		-- else
		-- 	damage = SpaceDamage(curr, temp_dmg, (dir-2)%4)
		-- 	ret:AddDamage(damage)
		end
	
	--else
		-- damage = SpaceDamage(curr, temp_dmg, (dir-2)%4)
		-- ret:AddDamage(damage)
	end
	
	if not flag then
		damage = SpaceDamage(curr, temp_dmg, (dir-2)%4)
		ret:AddDamage(damage)
	end

	if #targets >= 2 then
		for i = 2, #targets do
			curr = targets[i]
			damage = SpaceDamage(curr, 0, (dir-2)%4)
			
			--damage.iDamage = temp_dmg
			
			if Board:IsPawnSpace(curr) then
				ret:AddDelay(0.1)
				
				damage.iAcid = self.ACID
			end

			if not self.FriendlyDamage and Board:IsPawnTeam(curr,TEAM_PLAYER) then
				damage.iDamage = 0 
			end
			
			ret:AddDamage(damage)

			-- temp_dmg = temp_dmg - 1 
			-- if temp_dmg < min_dmg then temp_dmg = min_dmg end
		end
	end

	if flag then
		-- LOG("2") 
		-- LOG(curr)
		-- LOG(flag)
		curr = targets[1] 
		damage = SpaceDamage(curr, temp_dmg, (dir-2)%4)
		ret:AddDelay(0.2)
		ret:AddDamage(damage)
	end 


	--맨 뒷놈부터 끌어오는 거. 충돌피해가 생기긴 한다. 
	-- 문제점 : 맨 앞놈이 죽었을 경우. 두번째 놈만 앞으로 한칸 끌려온다. 막을 수 있을까? 
--[[	for i = 0, #targets-1  do
		local curr = targets[#targets - i]
		local damage = SpaceDamage(curr, 0, (dir-2)%4)
		
		if curr == p1 + DIR_VECTORS[dir] then   -- hard coding. :( 
			damage.iDamage  = temp_dmg 
		end
		if (curr == p1 + (DIR_VECTORS[dir]*2)) and temp_dmg > 1  then
			damage.iDamage = temp_dmg - 1
		end 

		--damage.iDamage = temp_dmg

		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
			damage.iAcid = self.ACID
		end

		if not self.FriendlyDamage and Board:IsPawnTeam(curr,TEAM_PLAYER) then
			damage.iDamage = 0 
		end
		
		ret:AddDamage(damage)

		-- temp_dmg = temp_dmg - 1 
		-- if temp_dmg < min_dmg then temp_dmg = min_dmg end
	end
]]

	if acid_Bonus  then 
		local selfDamage = SpaceDamage( p1  ,self.SelfDamage) 
		selfDamage.iAcid =  EFFECT_REMOVE 
		ret:AddDamage(selfDamage)
	elseif self.self_acid then
		local selfDamage = SpaceDamage( p1  ,self.SelfDamage) 
		selfDamage.iAcid =  1 
		ret:AddDamage(selfDamage)
	end

	

	return ret
end

narD_PullBeam_A = narD_PullBeam:new{ --
	UpgradeDescription = "Increases Damage by 1.",--"Deals no damage to allies.",
	--FriendlyDamage = false,
	--self_acid = true, 
	--FriendlyDamage = false, 
	BackACID = true,
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
	BackACID = true,
	-- self_acid = true, 
	--FriendlyDamage = false, 
}
--

narD_ACIDVat = Pawn:new{
	Name = "A.C.I.D. Vat",  -- "A.C.I.D. Barrel"
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

	if not Board:IsSpawning(point) then
		dam.iTerrain = TERRAIN_WATER	
	end
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
	
	self_acid = false, 

	VatFire = 0,
	VatPawn = "narD_ACIDVat", 
	BackACID = false,
	acid_repair = true,

	Acid_Damage = 1,
	SideACID = 0, 
	
	UpgradeCost = {2, 2},

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
	elseif self.self_acid then
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  1 
		ret:AddDamage(selfDamage)
	end

	if self.BackACID then
		local backDamage = SpaceDamage(p1 - DIR_VECTORS[dir] , 0)
		backDamage.iAcid = 1
		ret:AddDamage(backDamage) 
	end

	ret:AddArtillery(damage,"effects/shotup_acid.png")
	-- shotup_acid

	ret:AddBounce(p2, self.BounceAmount)
	ret:AddBoardShake(0.15)


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
	--VatFire = 1, 
	--self_acid = true,

	BackACID = true,
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
	--VatFire = 1,
	-- self_acid = true,
	BackACID = true,
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

	self_acid = false, 
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
	elseif self.self_acid then 
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  1 
		ret:AddDamage(selfDamage)
	end

	if (self.BuildingImmune) and (Board:IsBuilding(target)) then 
		damage.iDamage = 0
	end

	if (not self.FriendlyDamage) and (Board:IsPawnTeam(target ,TEAM_PLAYER)) then
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

		if (not self.FriendlyDamage) and (Board:IsPawnTeam(target + DIR_VECTORS[dir],TEAM_PLAYER)) then
			damage.iDamage = 0 
			
		end

		damage.sAnimation = "airpush_"..dir
		if (dir ~= GetDirection(p1 - p2)) and (dir ~= GetDirection(p2 - p1)) then
			ret:AddDamage(damage)
		end
	end
	
	if (Board:GetPawn(p1):IsAcid()) then
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  EFFECT_REMOVE 
		ret:AddDamage(selfDamage)
	end

	return ret
end

narD_Shrapnel_A = narD_Shrapnel:new{
	UpgradeDescription = "+ Building Immune", --"+ self A.C.I.D.", 
	-- self_acid = true, 
	BuildingImmune = true,
} 

narD_Shrapnel_B = narD_Shrapnel:new{
	UpgradeDescription = "+ Alley Immune", 
	FriendlyDamage = false,
	
} 

narD_Shrapnel_AB = narD_Shrapnel:new{
	BuildingImmune = true,
	FriendlyDamage = false,
	-- self_acid = true, 
} 