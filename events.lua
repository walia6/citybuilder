--events

events={
	{
		formal = "Natural Disasters and Okonkwo",
		title = "Natural Disasters and Okonkwo",
		body = "    There have been many climate related natural disasters this past year: from the late and brief rains, to the heavy and intense heat coming from the sun; causing a loss of yams. On the other hand, the very skillfull Okonkwo acquires 800 seeds from Nwakibie and permanently increases the yam cultivation rate (23).\n\nEffects:\n    •Up to 1500 yams lost\n    •Multiplier increased 50%",
		onInstance = (
			function()
				player.yams=math.max(player.yams-1500,0)
				player.multiplier=player.multiplier*1.5
			end
		)
	}
}