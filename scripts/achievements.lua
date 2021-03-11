
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local achvApi = require(path .."scripts/achievements/api")

-- function tosx_windsquad_Chievo(id)
-- 	-- exit if not our squad
-- 	if GAME.squadTitles["TipTitle_"..GameData.ach_info.squad] ~= "Windriders" then return end
-- 	-- exit if current one is unlocked
-- 	if achvApi:GetChievoStatus(id) then	return end
-- 	achvApi:TriggerChievo(id)
-- 	if id == "narD_acid_falling" then
-- 		achvApi:TriggerChievo("narD_acid_secret", {aa = true})
-- 	elseif id == "narD_acid_crowded" then
-- 		achvApi:TriggerChievo("narD_acid_secret", {bb = true})
-- 	elseif id == "narD_acid_goride" then
-- 		achvApi:TriggerChievo("narD_acid_secret", {cc = true})
-- 	end
-- 	if achvApi:IsChievoProgress("narD_acid_secret", {reward = true }) then return end
-- 	if achvApi:IsChievoProgress("narD_acid_secret", {aa = true, bb = true, cc = true,}) then	
-- 		achvApi:TriggerChievo("narD_acid_secret", {reward = true })	
-- 		achvApi:ToastUnlock(tosx_windUnlock())
-- 	end
-- end

local imgs = {
	"ach_2clear",
	"ach_3clear",
	"ach_4clear",
	"ach_perfect",
	-- "falling",
	-- "crowded",
	-- "goride",
	-- "secret",
}

local achname = "narD_acid_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
	modApi:appendAsset("img/achievements/".. achname..img .."_gray.png", path .."img/achievements/".. img .."_gray.png")
end

-- achvApi:AddChievo{
-- 	id = "narD_acid_falling",
-- 	name = "Fear of Falling",
-- 	tip = "Toss an enemy into a Chasm using the Cyclone Launcher with the Windriders squad.",
-- 	img = "img/achievements/narD_acid_falling.png",
-- }

-- achvApi:AddChievo{
-- 	id = "narD_acid_crowded",
-- 	name = "Crowded Sky",
-- 	tip = "Move at least 8 units using the Microburst with the Windriders squad.",
-- 	img = "img/achievements/narD_acid_crowded.png",
-- }

-- achvApi:AddChievo{
-- 	id = "narD_acid_goride",
-- 	name = "Frequent Flyer",
-- 	tip = "Leap at least 4 tiles with 2 enemies using the Aero Thrusters with the Windriders squad.",
-- 	img = "img/achievements/narD_acid_goride.png",
-- }

-- achvApi:AddChievo{
-- 		id = "narD_acid_secret",
-- 		name = "Secret Reward",
-- 		tip = "Complete all 3 squad achievements.\n\nFear of Falling: $aa\nCrowded Sky: $bb\nGoing for a Ride: $cc\n\nReward: $reward",
-- 		img = "img/achievements/narD_acid_secret.png",
-- 		objective = {
-- 			aa = true,
-- 			bb = true,
-- 			cc = true,
-- 			reward = "?|Secret Structure"
-- 		}
-- }

achvApi:AddChievo{
		id = "narD_acid_2clear",
		name = "A.rtificial Mechs 2 Island Victory",
		tip = "Complete 2 corporate islands then win the game.\n\nEasy: $easy\nNormal: $normal\nHard: $hard",
		img = "img/achievements/narD_acid_ach_2clear.png",
		objective = {
			easy = true,
			normal = true,
			hard = true,
		}
}

achvApi:AddChievo{
		id = "narD_acid_3clear",
		name = "A.rtificial Mechs 3 Island Victory",
		tip = "Complete 3 corporate islands then win the game.\n\nEasy: $easy\nNormal: $normal\nHard: $hard",
		img = "img/achievements/narD_acid_ach_3clear.png",
		objective = {
			easy = true,
			normal = true,
			hard = true,
		}
}

achvApi:AddChievo{
		id = "narD_acid_4clear",
		name = "A.rtificial Mechs 4 Island Victory",
		tip = "Complete 4 corporate islands then win the game.\n\nEasy: $easy\nNormal: $normal\nHard: $hard",
		img = "img/achievements/narD_acid_ach_4clear.png",
		objective = {
			easy = true,
			normal = true,
			hard = true,
		}
}

achvApi:AddChievo{
		id = "narD_acid_perfect",
		name = "A.rtificial Mechs Perfect",
		tip = "Win the game and obtain the highest possible score.",
		img = "img/achievements/narD_acid_ach_perfect.png"
}

-- function tosx_windUnlock()
-- 	return {
-- 		unlockTitle = 'Structure Unlocked!',
-- 		name = 'Secret Aerodrome',
-- 		tip = 'Aerodrome unlocked. This structure can now appear in missions.',
-- 		img = 'img/achievements/'..achname..'secret.png',
-- 	}
-- end

return this