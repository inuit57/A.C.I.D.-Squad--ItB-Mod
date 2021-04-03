-- 매크들을 여기서 정의한다. 


narD_LaserMech = Pawn:new { 
	Name = "C.orrosive Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 4,
	Armor = true,
	--Flying = true,
	Image = "BallMech", 
	ImageOffset = 7,
	SkillList = { "narD_PullBeam" } ,
	SoundLocation = "/mech/prime/punch_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}

AddPawn("narD_LaserMech")


narD_CorruptedMech = Pawn:new  {
	Name = "I.nsect Mech",
	Class =  "Brute", 
	Health = 3,
	Image = "InsectMech", --"MechCharge", 
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
	Image = "MangonelleMech",
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

