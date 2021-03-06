--events

events={
	{
		title = "Natural Disasters and Okonkwo",
		body = "    There have been many climate related natural disasters this past year; from the late and brief rains, to the heavy and intense heat coming from the sun; causing a loss of yams. On the other hand, a very skillful Okonkwo acquires 800 seeds from Nwakibie and permanently increases the yam cultivation rate (23).\n\nEffects:\n    •Up to 1500 yams lost\n    •Multiplier increased 50%",
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
	},
	{
		title = "Death of Ikemefuna",
		body = "    In Umofia, the Oracle declares that Ikemefuna must be sacrificed. While not forced to, Okonkwo chooses to participate in the killing. In a final moment of hesitation, Okonkwo kills Ikemefuna. This puts Okonkwo into a depression and affects his efficiency in yam cultivation (61).\n\nEffects:\n    •Efficiency reduced by a third for 500 turns.",
		onInstance = (
			function()
				player.multiplier=player.multiplier*2/3

				timedFunctions[#timedFunctions+1] = {
					time = player.turn+500,
					caller = 3,
					toCall = (
						function()
							player.multiplier=player.multiplier*3/2
						end
					)
				}
			end
		)
	},
	{
		title = "Exilation of Okonkwo",
		body = "    During the funeral of Ezedu, the oldest person in Umofia, the people are very sorrowful. In a final act of honor, drums are sounded and guns are fired into the air. While honoring their father, Ezedu's 16 year old is found dead with a bullet wound. It is found out that the gun responsible for the death is Okonkwo's. For this, Okonkwo is exiled for 7 years to Mbanta (124).\n\nEffects:\n    •Population reduced by 1\n    •Multiplier reduced by 50% indefinitely",
		onInstance = (
			function()
				player.multiplier=player.multiplier*2/3
				player.people=player.people-1
			end
		)
	},
	{
		title = "Return of Okonkwo",
		body = "    Upon the return of Okonkwo, we learn the Umofia has been 'invaded' by Christianity, and white men. The white men attempt to set up a government and a court of law. The population of Umofia greatly increases, but people are forced to give up large portions of their yams to the government (177).\n\nEffects:\n    •Population tripled\n    •Yam output reduced by 66%\n    •Yam storages quadrupled",
		onInstance = (
			function()
				player.multiplier=player.multiplier*1/3
				player.people=player.people*3
				player.yams=player.yams*4
			end
		)
	},
	{
		title = "Death of Okonkwo",
		body = "    Okonkwo realizes that he is no longer relevant to Umofia. Okonkwo hangs himself, marking the end of Umofia as he knew it (207).",
		onInstance = (
			function()
				startEnd=love.timer.getTime()
				gamestate="end"
			end
		)
	}
}