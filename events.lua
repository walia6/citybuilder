--events

events={
	{
		title = "Natural Disasters and Okonkwo",
		body = "    There have been many climate related natural disasters this past year; from the late and brief rains, to the heavy and intense heat coming from the sun; causing a loss of yams. On the other hand, a very skillfull Okonkwo acquires 800 seeds from Nwakibie and permanently increases the yam cultivation rate (23).\n\nEffects:\n    •Up to 1500 yams lost\n    •Multiplier increased 50%",
		onInstance = (
			function()
				player.yams=math.max(player.yams-1500,0)
				player.multiplier=player.multiplier*1.5
			end
		)
	},
	{
		title = "Violation of 'Week of Peace'!",
		body = "    Every year, the week before yams are planted is called the 'Week of Peace'. To please the goddess, Ani, during this week it is prohibited to be violent towards one another. To do otherwise would upset Ani and threaten the yields of yams for the reast of the season. During the 'Week of Peace', Okonkwo beats his youngest wife, Ojiugo and upsets Ani and threatens the yields for the rest of the season (30).\n\nEffects:\n     •Multiplier temporarily halved for 300 turns",
		onInstance = (
			function()
				player.multiplier=player.multiplier/2
				timedFunctions[#timedFunctions+1] = {
					time = player.turn+300,
					caller = 2,
					toCall = (
						function()
							player.multiplier=player.multiplier*2
						end
					)
				}
			end
		)
	}
}