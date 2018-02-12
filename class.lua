classTypes={"terrain","farm","house","commons"}
classData={
	terrain = {
		fill = config.colors.green,
		text = config.colors.white,
		displayName = "Terrain",
		cost = -500
	},
	farm = {
		fill = config.colors.paleyellow,
		text = config.colors.darkgray,
		displayName = "Farm",
		cost = 750,
		onTick = (
			function()
				player.yams=player.yams+math.floor(1000*player.multiplier)/1000
			end
		)
	},
	house = {
		fill = config.colors.brick,
		text = config.colors.paleyellow,
		displayName = "Home",
		cost = 1000
	},
	commons = {
		fill = config.colors.purple,
		text = config.colors.lightgray,
		displayName = "Common Area",
		cost = 4500,
		onBuilt = (
			function()
				player.multiplier=player.multiplier*1.5
			end
		),
		onDemo = (
			function()
				player.multiplier=player.multiplier/1.5
			end
		)
	}
}