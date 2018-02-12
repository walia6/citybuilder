


finance={}


function finance.appraise()
	return math.floor(math.pow(10*(#player.unlocked)/(#tiles),1.3)*1000)
end


function finance.develop(developID,target)
	if tiles[developID].class == target then
		fade=255
	elseif target=="terrain" then
		player.yams=player.yams-classData.terrain.cost
		tiles[developID].class="terrain"
		love.keyreleased("escape")
	elseif tiles[developID].class ~= "terrain" then
		if player.yams-classData.terrain.cost-classData[target].cost>=0 then
			player.yams=player.yams-classData.terrain.cost-classData[target].cost
			tiles[developID].class = target
			love.keyreleased("escape")
		else
			fade=255
		end
	else
		if player.yams>=classData[target].cost then
			player.yams=player.yams-classData[target].cost
			tiles[developID].class=target
			love.keyreleased("escape")
		else
			fade=255
		end
	end
end