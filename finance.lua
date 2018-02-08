--filler


finance={}


function finance.appraise()
	return math.floor(math.pow(10*(#player.unlocked)/(#tiles),1.3)*1000)
end