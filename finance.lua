


finance={}


function finance.appraise()
	return math.floor(math.floor(math.pow(10*(#player.unlocked)/(#tiles),2.3)*1000)/50)*50
end


function finance.develop(developID,target)
	if tiles[developID].class == target then
		fade=255
	elseif target=="terrain" then
		if classData[tiles[developID].class].onDemo then
			classData[tiles[developID].class].onDemo()
		end
		player.yams=player.yams-classData.terrain.cost
		tiles[developID].class="terrain"
		love.keyreleased("escape")
	elseif tiles[developID].class ~= "terrain" then
		if player.yams-classData.terrain.cost-classData[target].cost>=0 then
			if classData[tiles[developID].class].onDemo then
				classData[tiles[developID].class].onDemo()
			end
			player.yams=player.yams-classData.terrain.cost-classData[target].cost
			tiles[developID].class = target
			if classData[target].onBuilt then
				classData[target].onBuilt()
			end
			love.keyreleased("escape")
		else
			fade=255
		end
	else
		if player.yams>=classData[target].cost then
			if classData[tiles[developID].class].onDemo then
				classData[tiles[developID].class].onDemo()
			end
			player.yams=player.yams-classData[target].cost
			tiles[developID].class=target
			love.keyreleased("escape")
			if classData[target].onBuilt then
				classData[target].onBuilt()
			end
		else
			fade=255
		end
	end
end
