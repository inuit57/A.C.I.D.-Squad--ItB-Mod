
local path = mod_loader.mods[modApi.currentMod].scriptPath
local achvApi = require(path .."achievements/api")
local narD_squadname = "A.rtificial Mechs"
local narD_achvname = "narD_acid_"

local this = {}

function this:init()
	local oldMissionEnd = Mission_Final_Cave.MissionEnd
	
	function Mission_Final_Cave:MissionEnd()
		oldMissionEnd()		
		--Win the Game Achievements
		if GAME.squadTitles["TipTitle_"..GameData.ach_info.squad] ~= narD_squadname then return end
		this:narD_achv_Victory()
		this:narD_achv_Highscore()
	end	
end

function this:load(_modApiExt)
end

function this:narD_achv_Victory()
	local difficulty = GetRealDifficulty()
	local islands = 0
	for i = 0, 3 do
		if RegionData["island" .. i]["secured"] then
			islands = islands +1
		end
	end
	if islands < 2 then return end
	for i = 0, difficulty do
		if i == 0 then
			if islands == 2 then
				achvApi:TriggerChievo(narD_achvname.."2clear", {easy = true})				
			elseif islands == 3 then
				achvApi:TriggerChievo(narD_achvname.."3clear", {easy = true})				
			elseif islands == 4 then
				achvApi:TriggerChievo(narD_achvname.."4clear", {easy = true})
			end
		elseif i == 1 then
			if islands == 2 then
				achvApi:TriggerChievo(narD_achvname.."2clear", {normal = true})				
			elseif islands == 3 then
				achvApi:TriggerChievo(narD_achvname.."3clear", {normal = true})				
			elseif islands == 4 then
				achvApi:TriggerChievo(narD_achvname.."4clear", {normal = true})
			end
		elseif i == 2 then
			if islands == 2 then
				achvApi:TriggerChievo(narD_achvname.."2clear", {hard = true})				
			elseif islands == 3 then
				achvApi:TriggerChievo(narD_achvname.."3clear", {hard = true})				
			elseif islands == 4 then
				achvApi:TriggerChievo(narD_achvname.."4clear", {hard = true})
			end
		end
	end
end

function this:narD_achv_Highscore()
	local highscore = GameData["current"]["score"]
	if highscore == 30000 then
		achvApi:TriggerChievo(narD_achvname.."perfect")
	end	
end

return this