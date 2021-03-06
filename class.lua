classTypes={"terrain","farm","house","commons"}
classAmounts={}
classData={
	terrain = {
		fill = config.colors.green,
		text = config.colors.white,
		displayName = "Undeveloped",
		cost = -500
	},
	farm = {
		fill = config.colors.paleyellow,
		text = config.colors.darkgray,
		displayName = "Yam Farm",
		cost = 750,
		onTick = (
			function(myID)
				farmMult = 1.5
				adjMult=1

				if (myID-1)>(0) then
					if tiles[myID-1].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end

				if (myID+1)<=(config.plots.width*config.plots.height) then
					if tiles[myID+1].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end


				if (myID-config.plots.width)>(0) then
					if tiles[myID-config.plots.width].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end

				if (myID-config.plots.width-1)>(0) then
					if tiles[myID-config.plots.width-1].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end

				if (myID-config.plots.width+1)>(0) then
					if tiles[myID-config.plots.width+1].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end

				if (myID+config.plots.width)<=(config.plots.width*config.plots.height) then
					if tiles[myID+config.plots.width].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end

				if (myID+config.plots.width-1)<=(config.plots.width*config.plots.height) then
					if tiles[myID+config.plots.width-1].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end

				if (myID+config.plots.width+1)<=(config.plots.width*config.plots.height) then
					if tiles[myID+config.plots.width+1].class=="commons" then
						adjMult=adjMult*farmMult
					end
				end

				player.yams=player.yams+adjMult*1.5*math.floor(1000*player.multiplier)/1000*(math.min(player.people,4*classAmounts.farm)/4/classAmounts.farm)
			end
		),
		onBuilt = (
			function()
				if not classAmounts.farm then
					classAmounts.farm=1
				else
					classAmounts.farm=classAmounts.farm+1
				end
			end
		),
		onDemo = (
			function()
				classAmounts.farm=classAmounts.farm-1
			end
		)
	},
	house = {
		fill = config.colors.brick,
		text = config.colors.paleyellow,
		displayName = "Obi",
		cost = 1000,
		onBuilt = (
			function()
				if not classAmounts.house then
					classAmounts.house=1
				else
					classAmounts.house=classAmounts.house+1
				end
				player.people=player.people+6
			end
		),
		onDemo = (
			function()
				classAmounts.house=classAmounts.house-1
				player.people=player.people-6
			end
		)
	},
	commons = {
		fill = config.colors.purple,
		text = config.colors.lightgray,
		displayName = "Ilo",
		cost = 4500,
		onBuilt = (
			function()
				if not classAmounts.commons then
					classAmounts.commons=1
				else
					classAmounts.commons=classAmounts.commons+1
				end
				--player.multiplier=player.multiplier*1.5
			end
		),
		onDemo = (
			function()
				--player.multiplier=player.multiplier/1.5
				classAmounts.commons=classAmounts.commons-1
			end
		)
	}
}
