local wt2 = {	

	narD_Shrapnel_Upgrade1 =  "+1 Dmaage", --"+1 Tile",
	narD_Shrapnel_Upgrade2 =  "Building Immune",  --"Ally Immune", 

	narD_VATthrow_Upgrade1 = "+1 Damage",--"+Back A.C.I.D", 
	--narD_VATthrow_Upgrade2 = "+Side A.C.I.D", 

	narD_PullBeam_Upgrade1 = "+A.C.I.D Tip",
	narD_PullBeam_Upgrade2 = "+1 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local function isTipImage()
	return Board:GetSize() == Point(6,6)
end





----

narD_PullBeam = LaserDefault:new{
	Name = "Pull Beam",
	Class = "Prime",
	Description = "Pull all units in a line, damaging last target.\nIf the Mech is affected by A.C.I.D., cleanse it and deal double damage",
	-- Description = "Pull all units in a line, damaging adjacent.\nIf the Mech is affected by A.C.I.D., cleanse it and deal double damage",
	Icon = "weapons/acid_laser.png",
	LaserArt = "effects/laser_acid", --"effects/laser_push", -- --laser_fire
	Explosion = "", -- "ExploFirefly2",
	Sound = "",
	PowerCost = 1,
	
	ZoneTargeting = ZONE_DIR,

	LaunchSound = "/weapons/push_beam",
	Damage = 2,
	MinDamage = 1, -- for tooltip
	FriendlyDamage = true,
	SelfDamage = 0,
	
	--Acid_Damage = 1, 
	self_acid = false,
	BackACID = false,

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



function narD_PullBeam:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	-- 내가 원하는 것은 마지막이 유닛이었으면 한다는 것이고. 
	-- targets[#targets+1] = curr --마지막 지점을 넣어주는구나 이게 . 
	
	-- 마지막 pawn의 위치를 curr에 저장한다. 
	while not Board:IsPawnSpace(curr) do
		curr = curr - DIR_VECTORS[dir]
	end

	if(curr == p1) then
		curr = p2
	end

	local dam = SpaceDamage(curr, 0 ) -- for effect 
	dam.iAcid = 1
		
	local temp_dmg = self.MinDamage	
	--local min_dmg = self.MinDamage

	local acid_Bonus = Board:GetPawn(p1):IsAcid()

	if acid_Bonus then 
		temp_dmg = self.Damage 

		dam.iDamage = self.Damage
		ret:AddProjectile(dam,"effects/laser_acid")
	else
		dam.iDamage = self.MinDamage
		ret:AddProjectile(dam,"effects/m_laser_acid") -- "effects/laser_acid"
				
	end
	
	
	--local curr = targets[1]
	local damage 
	local flag = false
	local check_damage = temp_dmg 

	-- if (Board:IsPawnSpace(curr) ) and (Board:GetPawn(curr):IsAcid()) then
	-- 	-- if self.Damage > 2 then
	-- 		temp_dmg = self.MinDamage
	-- 	--end
		
	-- 	check_damage = temp_dmg * 2  
		
	-- end
	
	-- if Board:IsPawnSpace(curr) then

	-- 	if (Board:GetPawn(curr):GetHealth() <= (check_damage + 1) )  and 
	-- 	 	(Board:GetPawn(curr):GetType() ~= "narD_ACIDVat" ) and  -- intended bug.  
	-- 	 	(Board:GetPawn(curr):GetType() ~= "AcidVat" ) then --
	-- 		flag = true
	-- 	end
				
	-- end

	-- if not flag then
	-- 	damage = SpaceDamage(curr, temp_dmg, (dir-2)%4)
	-- 	if Board:IsPawnSpace(curr) then
	-- 		ret:AddDelay(0.1)
	-- 		damage.iAcid = self.ACID
	-- 	end
	-- 	--damage.iAcid = self.ACID
	-- 	ret:AddDamage(damage)
	-- end

	--if #targets >= 2 then
	local curr2 
	for i = 1, #targets do
		curr2 = targets[i]
		if(curr2  == curr + DIR_VECTORS[dir]) then 
			 break 
		end
		damage = SpaceDamage(curr2, 0, (dir-2)%4)
		
		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
			
			damage.iAcid = self.ACID
		end
		
		--damage.iAcid = self.ACID
		ret:AddDamage(damage)
	end
	--end

	-- if flag then
	-- 	curr = targets[1] 
	-- 	damage = SpaceDamage(curr, temp_dmg, (dir-2)%4)
	-- 	ret:AddDelay(0.3)
	-- 	damage.iAcid = self.ACID
	-- 	ret:AddDamage(damage)
	-- end 

	if acid_Bonus  then 
		local selfDamage = SpaceDamage( p1  ,self.SelfDamage) 
		selfDamage.iAcid =  EFFECT_REMOVE 
		selfDamage.sAnimation = "ExploFirefly2"
		ret:AddDamage(selfDamage)
	end

	

	return ret
end

narD_PullBeam_A = narD_PullBeam:new{ --
	UpgradeDescription =  "Applying A.C.I.D. to the hit targets.",
	ACID = 1,
}

narD_PullBeam_B = narD_PullBeam:new{ --
	UpgradeDescription = "Increases damage by 1.",
	MinDamage = 2,
	Damage = 4, 
}

narD_PullBeam_AB = narD_PullBeam:new{ 

	ACID = 1,
	MinDamage = 2,
	Damage = 4, 

}
--

narD_ACIDVat = Pawn:new{
	Name = "A.C.I.D. Vat",  -- "A.C.I.D. Barrel"
	Health = 1, --2
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
	Description = "Throw an A.C.I.D. vat at a chosen target. A.C.I.D. vat remains as an obstacle. \nIf the Mech is affected by A.C.I.D., cleanse it and deal double damage", 
	--"Throws an A.C.I.D. vat that pushes adjacent tiles.", 

	Class = "Ranged",
	Icon =  "weapons/vat_throw.png", --"weapons/acid_bomb_throw.png",
	Sound = "",
	ArtilleryStart = 2,
	ArtillerySize = 8,
	Explosion = "", 
	-- Explosion = "ExploFirefly2",
	PowerCost = 1,
	BounceAmount = 1,
	Damage = 2,
	MinDamage = 1, -- for tooltip
	LaunchSound = "/weapons/boulder_throw",
	ImpactSound =  "/props/acid_vat_break", --"/impact/dynamic/rock",
	Upgrades = 1, --2
	--Push = false,
	
	self_acid = false, 

	VatFire = 0,
	VatPawn = "narD_ACIDVat", 
	BackACID = false,
	acid_repair = true,

	Acid_Damage = 1,
	SideACID = 0, 
	
	UpgradeCost = {2 },-- 2},

	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2,1),

	}
}
					
function narD_VATthrow:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.MinDamage)


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
		damage.iDamage = self.Damage --self.MinDamage + self.Acid_Damage --*2 
		--if self.Damage > 2 and  
		if (Board:IsPawnSpace(p2) ) and Board:GetPawn(p2):IsAcid() then
			damage.iDamage = self.MinDamage
		end

		if self.acid_repair then 
			local selfDamage = SpaceDamage( p1  ,0) 
			selfDamage.iAcid =  EFFECT_REMOVE 
			-- selfDamage.Explosion = "ExploFirefly2"
			selfDamage.sAnimation = "ExploFirefly2"
			ret:AddDamage(selfDamage)
		end

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




	for dir2 = 0,3 do 
		local temp_point = p2 + DIR_VECTORS[dir2] 
		local damagepush = SpaceDamage(temp_point, 0 , dir2)
		damagepush.sAnimation = "airpush_"..(dir2)
		ret:AddDamage(damagepush)
	end

	-- local temp_point = p2 + DIR_VECTORS[(dir+1)%4]
	-- local damagepush = SpaceDamage(temp_point, 0, (dir+1)%4)

	
	-- damagepush.sAnimation = "airpush_"..((dir+1)%4)
	-- damagepush.iAcid = self.SideACID
	-- ret:AddDamage(damagepush) 
	
	
	-- temp_point = p2 + DIR_VECTORS[(dir-1)%4]
	-- damagepush = SpaceDamage(temp_point, 0, (dir-1)%4)
	-- damagepush.iAcid = self.SideACID

	-- damagepush.sAnimation = "airpush_"..((dir-1)%4)
	-- ret:AddDamage(damagepush)
	

	return ret
end

narD_VATthrow_A = narD_VATthrow:new{
	UpgradeDescription = "Increate Damage by 1, But no longer additional damage when both unit in acid state",--"Spill the A.C.I.D. behind the Mech.",

	--BackACID = true,
	MinDamage = 2, 
	Damage = 4, 

} 

-- narD_VATthrow_B = narD_VATthrow:new{
-- 	UpgradeDescription = "Spray additional A.C.I.D. on adjacent tiles.",

-- 	SideACID = 1, 
-- } 

-- narD_VATthrow_AB = narD_VATthrow:new{
-- 	--BackACID = true,
-- 	MinDamage = 2, 
-- 	Damage = 4, 

-- 	SideACID = 1, 
-- } 

narD_Shrapnel = TankDefault:new	{

	Name = "A.C.I.D. Shrapnel",
	Description = "Launch a volatile mass of goo, applying A.C.I.D. on nearby units and pushing them aside.\nIf the Mech is affected by A.C.I.D., cleanse it and deal double damage", 

	Class = "Brute", 
	Icon = "weapons/enemy_firefly2.png", -- need change?.
	Explosion = "ExploFirefly2",
	Sound = "/general/combat/explode_small",
	Damage = 2,
	MinDamage = 1, 
	Push = 1,
	PowerCost = 2,
	Acid = 1, 
	
	BigSize = 0 , 
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
	
	local damage = SpaceDamage(target, self.MinDamage)
	damage.iAcid = self.Acid 

	if Board:GetPawn(p1):IsAcid() then
		damage.iDamage = self.Damage --self.MinDamage + self.Acid_Damage --*2 
		--if self.Damage > 2 and 
		if (Board:IsPawnSpace(target) ) and  Board:GetPawn(target):IsAcid() then
			damage.iDamage = self.MinDamage
		end
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
		local target2 = target + DIR_VECTORS[dir]
		damage = SpaceDamage(target2, self.MinDamage , dir)
		damage.iAcid = self.Acid 

		if Board:GetPawn(p1):IsAcid() then
			damage.iDamage = self.Damage --self.MinDamage + self.Acid_Damage --*2 
			--if self.Damage > 2 and 
			if (Board:IsPawnSpace(target2) ) and  Board:GetPawn(target2):IsAcid() then
				damage.iDamage = self.MinDamage
			end
		end

		if (self.BuildingImmune) and (Board:IsBuilding(target2)) then 
			damage.iDamage = 0
			
		end

		if (not self.FriendlyDamage) and (Board:IsPawnTeam(target2,TEAM_PLAYER)) then
			damage.iDamage = 0 
			
		end

		damage.sAnimation = "airpush_"..dir
		if (dir ~= GetDirection(p2 - p1)) and (dir ~= GetDirection(p1 - p2)) then -- and ((self.BigSize ~= 0) or (dir ~= GetDirection(p2 - p1))) then
		--if (dir ~= GetDirection(p1- p2)) then
			ret:AddDamage(damage)
		end

		-- if (self.BigSize ~= 0) and (dir == GetDirection(p2 - p1)) then
		-- 	ret:AddDamage(damage)
		-- end
	end
	
	if (Board:GetPawn(p1):IsAcid()) then
		local selfDamage = SpaceDamage( p1  ,0) 
		selfDamage.iAcid =  EFFECT_REMOVE 
		ret:AddDamage(selfDamage)
	end

	return ret
end

narD_Shrapnel_A = narD_Shrapnel:new{
	UpgradeDescription = "Increate Damage by 1, But no longer additional damage when both unit in acid state", --"Push and Damage to additional tile",--"Deals no damage to allies.",
	-- self_acid = true, 
	--BigSize = 1, 
	MinDamage = 2, 
	Damage = 4, 
} 

narD_Shrapnel_B = narD_Shrapnel:new{
	UpgradeDescription = "This attack will no longer damage Grid Buildings.",
	--FriendlyDamage = false,
	BuildingImmune = true,
	
}

narD_Shrapnel_AB = narD_Shrapnel:new{
	BuildingImmune = true,
	MinDamage = 2, 
	Damage = 4, 
	--BigSize = 1, 
	--FriendlyDamage = false,
	-- self_acid = true, 
} 