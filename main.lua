

function tableContains(_CHECK,_TOINDEX)
	for _i=1,#_TOINDEX do
		if _CHECK==_TOINDEX[_i] then
			return true
		end
	end
end


function table_print (tt, indent, done)
	done = done or {}
	indent = indent or 0
	if type(tt) == "table" then
		local sb = {}
		for key, value in pairs (tt) do -- indent it
			sb[#sb+1]=(string.rep (" ", indent))
			if type(value) == "table" and not done [value] then
				done[value] = true
				sb[#sb+1]=("{\n")
				sb[#sb+1]=(table_print(value,indent+2,done))
				sb[#sb+1]=(string.rep(" ", indent)) -- indent it
				sb[#sb+1]=("}\n")
			elseif "number" == type(key) then
				sb[#sb+1]=(string.format("\"%s\"\n",tostring(value)))
			else
				sb[#sb+1]=(string.format("%s = \"%s\"\n",tostring(key),tostring(value)))
			end
		end
		return table.concat(sb)
	else
		return tt.."\n"
	end
end

function to_string(tbl)
    if "nil" == type(tbl) then
        return tostring(nil)
    elseif "table" == type(tbl) then
        return table_print(tbl)
    elseif "string" == type(tbl) then
        return tbl
    else
        return tostring(tbl)
    end
end

--END COPIED CODE
-- this is a 

--test

function pack(...)
	return {...}
end

function love.load()
	eventFreq=750
	curEvent=1

	timedFunctions={}
	lastYams=0.0000001
	rates={0}
	toDraw=true
	fade=0
	tot=0
	output="Begin Output Console:\n"
	require("config")
	require("class")
	require("events")
	require("finance")
	require("player")
	pointer=1
	tiles={}
	lastKey="n/a"
	lastClick = {x = 0, y = 0}
	startTime=love.timer.getTime()
	frames=0
	menu="none"
	x,y=nil,nil
	rate=60
	--on load
	love.window.maximize()
	love.window.setFullscreen(true)
	gamestate="game"
	txt=""
	width, height = love.graphics.getDimensions()
	toDraw=true
	colorIn=false
	exitThick=3
	exitHeight=138
	exitWidth=246
	textHeight=12
	textWidth=6
	modifying=0
	debugAmount=0
	mouseSpeed=300
	bounds={
		upper =  height/2-(exitHeight/2)+exitThick,
		left =   width/2-(exitWidth/2)+exitThick,
		right =  (width/2-(exitWidth/2)+exitThick)+exitWidth-2*exitThick,
		lower =  (height/2-(exitHeight/2)+exitThick)+exitHeight-2*exitThick,
		height = ((height/2-(exitHeight/2)+exitThick)+exitHeight-2*exitThick)-(height/2-(exitHeight/2)+exitThick),
		width =  ((width/2-(exitWidth/2)+exitThick)+exitWidth-2*exitThick)-(width/2-(exitWidth/2)+exitThick)
	}
end

function checkTile(tileX,tileY)
	res=false
	for i=1,#tiles do
		if ((isBetween(tileX,tiles[i][1][1],tiles[i][2][1]) and isBetween(tileY,tiles[i][1][2],tiles[i][2][2])) and (not res)) then
			res=i
		end
	end
	return res
end

function isBetween(numb, boundDown, boundUp)
	return ((boundDown<=numb) and (numb<=boundUp))
end

function love.update(dt)


	if menu=="none" then
		yamrate=dt*(player.yams-lastYams)
		lastYams=player.yams
		if not toDraw then

			if math.max(yamrate,rates[#rates])~=rates[#rates] then
				rates[#rates+1]=yamrate
			end
		end
		--called every frame
		tot=tot+dt
		if not toDraw then
			if math.floor(tot*config.turnLength)>player.turn then
				for h=1,config.plots.width*config.plots.height do
					if classData[tiles[h].class].onTick then
						classData[tiles[h].class].onTick()
					end
				end
				player.turn=player.turn+1
				
				for b=1,#timedFunctions do
					if timedFunctions[b].time == player.turn then
						timedFunctions[b].toCall()
						output=output.."Called "..(timedFunctions[b].caller).."'s timed function.\n"
					end
				end

				if player.turn%eventFreq==0 and events[curEvent] then
					--EVENTS CODE
					menu="event"
				end
			end
		end
	end


	if fade>0 then
		fade=fade-4*(dt/(1/60)) --FADE RATE
	end

	if fade<0 then
		fade=0
	end





	mouseSpeed=300
	if frames%15==0 then
		rate=1/dt
	end
	frames=frames+1
	if menu=="none" then

		if ((love.keyboard.isDown("w") or love.keyboard.isDown("s")) and (love.keyboard.isDown("a") or love.keyboard.isDown("d"))) then
			mouseSpeed=mouseSpeed/math.sqrt(2)
		end
		if love.keyboard.isDown("w") then
			love.mouse.setY(love.mouse.getY()-mouseSpeed*dt)
		elseif love.keyboard.isDown("s") then
			love.mouse.setY(love.mouse.getY()+mouseSpeed*dt)
		end
	
		if love.keyboard.isDown("a") then
			love.mouse.setX(love.mouse.getX()-mouseSpeed*dt)
		elseif love.keyboard.isDown("d") then
			love.mouse.setX(love.mouse.getX()+mouseSpeed*dt)
		end
	end
end

function debugText(denom,dTXT)
	if type(dTXT)==type(false) then
		
		if dTXT then
			dTXT="true"
		else
			dTXT="false"
		end
	end

	if not(dTXT==nil) then
		dTXT=denom..": "..dTXT
		denom=nil
	else
		dTXT=denom
		denom=nil
	end
	love.graphics.printf(dTXT,width-1000,15*debugAmount,1000,"right")
	debugAmount=debugAmount+1
end

function love.draw()
	debugAmount=0
	love.graphics.setColor(unpack(config.colors.white))

	

    if gamestate=="game" then
    	num=1
    	posY=math.floor(height/2-0.5*config.plots.pxlength*config.plots.height-0.5)
   		for curY = 1, config.plots.height do
   		 	posX=math.floor(width/2-0.5*config.plots.pxlength*config.plots.width-0.5)
   		 	for curX = 1, config.plots.width do
   		 		if toDraw then
  		  			tiles[num] = {
  		  				{
  		  					posX,
  		  					posY
	  					},

  		  				{
  		  					posX+config.plots.pxlength,
  		  					posY+config.plots.pxlength
		  				},
		  				state=1,
		  				class=config.defaultClass,
		  				id=num,
		  				unlocked=tableContains(num,player.unlocked)
  		  			}
  	 	 		end
    			love.graphics.setColor(unpack(config.colors.white))
    			if num==modifying then
    				love.graphics.setColor(unpack(config.colors.gold))
    			end
    			if tiles[num].unlocked then
   		 			love.graphics.rectangle("line",posX ,posY ,config.plots.pxlength, config.plots.pxlength) -- OUTLINE
  	 	 			love.graphics.setColor(unpack(classData[tiles[num].class].fill))
  	 	 			love.graphics.rectangle("fill", posX+1, posY+1, config.plots.pxlength-2, config.plots.pxlength-2)
    				love.graphics.setColor(unpack(classData[tiles[num].class].text))
	    			love.graphics.print(num,posX+5,posY+5)
	    			love.graphics.printf(classData[tiles[num].class].displayName,posX+1,posY-6+0.5*(config.plots.pxlength),config.plots.pxlength-2,"center")
  		  		else
  		  			love.graphics.rectangle("line",posX ,posY ,config.plots.pxlength, config.plots.pxlength) -- OUTLINE
  	 	 			love.graphics.setColor(unpack(config.colors.black))
  	 	 			love.graphics.rectangle("fill", posX+1, posY+1, config.plots.pxlength-2, config.plots.pxlength-2)
    				love.graphics.setColor(unpack(config.colors.white))
	    			love.graphics.print(num,posX+5,posY+5)
	    			love.graphics.printf(finance.appraise(),posX+1,posY-6+0.5*(config.plots.pxlength),config.plots.pxlength-2,"center")
  		  		end
  		  		--debugText(num,classData[tiles[num].class].displayName)
  		  		num=num+1
   		 		posX=posX+config.plots.pxlength
			end
			posY=posY+config.plots.pxlength
    	end

    	

    	priceLeftBound=9
    	priceRightBound=249
    	priceUpperBound=12
    	priceLowerBound=332

    	priceTextLeft=""
    	priceTextRight=""
    	for k=1,#classTypes do
    		priceTextLeft=priceTextLeft..(classData[classTypes[k]].displayName)..":\n\n"
    		priceTextRight=priceTextRight..(classData[classTypes[k]].cost).."\n\n"
    	end


    	

    	love.graphics.setColor(unpack(config.colors.midgray))
    	love.graphics.rectangle("fill", priceLeftBound+4, priceUpperBound+4, priceRightBound-priceLeftBound, priceLowerBound-priceUpperBound)
    	love.graphics.setColor(unpack(config.colors.lightgray))
    	love.graphics.rectangle("fill", priceLeftBound, priceUpperBound, priceRightBound-priceLeftBound, priceLowerBound-priceUpperBound)
    	love.graphics.setColor(unpack(config.colors.black))
    	love.graphics.printf("Pricing Info", priceLeftBound/2, priceUpperBound+15, priceRightBound/2, "center", 0,2,2.25)
    	love.graphics.printf("_", priceLeftBound/25+25, priceUpperBound+14, priceRightBound/25, "center", 0,25,2)
    	love.graphics.printf(priceTextLeft, priceLeftBound+10, priceUpperBound+60, priceRightBound-priceLeftBound-10, "left")
    	love.graphics.printf(priceTextRight, priceLeftBound+10, priceUpperBound+60, priceRightBound-priceLeftBound-20, "right")



	    toDraw=false
	end


	if menu=="exit" then

		--DRAW WINDOW START
		love.graphics.setColor(unpack(config.colors.darkgray))
		love.graphics.rectangle("fill", width/2-(exitWidth/2), height/2-(exitHeight/2), exitWidth, exitHeight)
		for i=1,(exitThick-1) do
			love.graphics.rectangle("fill", width/2-(exitWidth/2)+i, height/2-(exitHeight/2)+i, exitWidth-2*i, exitHeight-2*i)
		end
		love.graphics.setColor(unpack(config.colors.lightgray))
		love.graphics.rectangle("fill", width/2-(exitWidth/2)+exitThick, height/2-(exitHeight/2)+exitThick, exitWidth-2*exitThick, exitHeight-2*exitThick)
		love.graphics.setColor(config.colors.black)
		--DRAW WINDOW END

		exitMsg="Are you sure you would like to exit?"
		exitMsgWidth=#exitMsg*textWidth

		love.graphics.printf(exitMsg, math.floor(width/2-(exitWidth/2)+exitThick+0.5), math.floor(height/2-0.5*1/2*exitHeight+0.5)-20, 0.5*(exitWidth-2*exitThick), "center", 0, 2, 2)
		love.graphics.printf("Y/N"  , math.floor(width/2-(exitWidth/2)+exitThick+0.5), math.floor(height/2-0.5*1/2*exitHeight+textHeight*3.5+0.5), (exitWidth-2*exitThick)*0.5, "center", 0, 2, 2)

	elseif menu=="properties" then

		love.graphics.setColor(unpack(config.colors.darkgray))
		love.graphics.rectangle("fill", width/2-(exitWidth/2), height/2-(exitHeight/2), exitWidth, exitHeight)
		for i=1,(exitThick-1) do
			love.graphics.rectangle("fill", width/2-(exitWidth/2)+i, height/2-(exitHeight/2)+i, exitWidth-2*i, exitHeight-2*i)
		end
		love.graphics.setColor(unpack(config.colors.lightgray))
		love.graphics.rectangle("fill", width/2-(exitWidth/2)+exitThick, height/2-(exitHeight/2)+exitThick, exitWidth-2*exitThick, exitHeight-2*exitThick)
		love.graphics.setColor(config.colors.red)
		for p=1,#classTypes do
			love.graphics.setColor(unpack(config.colors.black))
			_TODISP = classData[classTypes[p]].displayName
			if p==pointer then
				love.graphics.setColor(unpack(config.colors.brick)) --select color
				_TODISP=">".._TODISP.."<"
			end
			love.graphics.printf(_TODISP,bounds.left,bounds.upper-10+20*p,bounds.width/2,"center",0,2,2)
			love.graphics.setColor(unpack(config.colors.black))
		end
		--love.graphics.printf(, x, bounds., limit, align, r, sx, sy, ox, oy, kx, ky)

	elseif menu=="event" then

		eventThick=3
		eventHeight=138*2
		eventWidth=246*2
		textHeight=12

		love.graphics.setColor(unpack(config.colors.darkgray))
		love.graphics.rectangle("fill", width/2-(eventWidth/2), height/2-(eventHeight/2), eventWidth, eventHeight)
		for i=1,(eventThick-1) do
			love.graphics.rectangle("fill", width/2-(eventWidth/2)+i, height/2-(eventHeight/2)+i, eventWidth-2*i, eventHeight-2*i)
		end
		love.graphics.setColor(unpack(config.colors.lightgray))
		love.graphics.rectangle("fill", width/2-(eventWidth/2)+eventThick, height/2-(eventHeight/2)+eventThick, eventWidth-2*eventThick, eventHeight-2*eventThick)
		love.graphics.setColor(config.colors.black)
		--DRAW WINDOW END
		tmpSCALE=1.5
		love.graphics.printf(events[curEvent].title, math.floor((width/2-eventWidth/2+eventThick)+0.5), math.floor((height/2-eventHeight/2+eventThick)+0.5), (eventWidth-2*eventThick)/tmpSCALE, "center", 0, tmpSCALE, tmpSCALE) --TITLE

		tmpSCALE=1
		love.graphics.printf(events[curEvent].body, math.floor((width/2-eventWidth/2+eventThick)+0.5)+5, math.floor((height/2-eventHeight/2+eventThick)+0.5)+30, (eventWidth-2*eventThick-10)/tmpSCALE, "left", 0, tmpSCALE, tmpSCALE)

		tmpSCALE=1.5
		love.graphics.printf("Press Any Key to Acknowledge...", math.floor((width/2-eventWidth/2+eventThick)+0.5), math.floor((height/2-eventHeight/2+eventThick)+eventHeight-45+0.5), (eventWidth-2*eventThick)/tmpSCALE, "center", 0, tmpSCALE, tmpSCALE) --TITLE

		--love.graphics.printf(events[curEvent].title, math.floor(width/2-(eventWidth/2)+eventThick+0.5), math.floor(height/2-0.5*1/2*eventHeight+0.5-eventHeight/2), 0.5*(eventWidth-2*eventThick), "center", 0, 2, 2)
		--love.graphics.printf("Y/N"  , math.floor(width/2-(eventWidth/2)+eventThick+0.5), math.floor(height/2-0.5*1/2*eventHeight+textHeight*3.5+0.5), (eventWidth-2*eventThick)*0.5, "center", 0, 2, 2)


	end
	--[[ debugging
	love.graphics.setColor(config.colors.white)
	love.graphics.printf("left", 500, 500, 800, "left")
	love.graphics.printf("center", 500, 500, 800, "center")
	love.graphics.printf("right", 500, 500, 800, "right")
	love.graphics.rectangle("fill", 500, 500, 10, 10)
	]]
	--*******DEBUG********--
	love.graphics.setColor(unpack(config.colors.white))
	debugText("FPS",string.sub(rate,1,2))--fps
	debugText("MENU",menu)
	debugText("MOD",modifying)
	debugText("RESOLUTION",width.."x"..height)
	debugText("FRAME",frames)
	debugText("TIMEINIT",string.sub(startTime,1,8))
	debugText("RUNTIME",string.sub(love.timer.getTime()-startTime,1,5))
	debugText("LASTKEY",lastKey)
	debugText("POINTER",pointer)
	debugText("LASTCLICK","("..(lastClick.x)..","..(lastClick.y)..")")
	debugText("CURSORPOS","("..(love.mouse.getX())..","..(love.mouse.getY())..")")
	debugText("MOUSESPEED",mouseSpeed)
	debugText(({love.system.getPowerInfo()})[1],({love.system.getPowerInfo()})[3])
	debugText("YAMS",math.floor(player.yams))
	debugText("PEOPLE",player.people)
	debugText("MULT",player.multiplier)
	debugText("RATELENGTH",#rates)
	if classAmounts.farm then
		debugText("OUTPUTPERFARM",math.floor(1000*player.multiplier)/1000*(math.min(player.people,4*classAmounts.farm)/4/classAmounts.farm))
		debugText("TOTALOUTPUT",math.floor(1000*player.multiplier)/1000*(math.min(player.people,4*classAmounts.farm)/4/classAmounts.farm)*classAmounts.farm)
	end
	debugText("toDraw",toDraw)
	debugText("TURN",player.turn)
	debugText("output",output)
    --*******DEBUG********--


    love.graphics.setColor(config.colors.blood[1],config.colors.blood[2],config.colors.blood[3],fade)
    love.graphics.rectangle("fill", 1, 1, width, height)

end --end draw


function authUnlock(targ2)

	ovrAuth=false

	if (targ2-1)>(0) then
		if tiles[targ2-1].unlocked then
			ovrAuth=true
		end
	end

	if (targ2+1)<=(config.plots.width*config.plots.height) then
		if tiles[targ2+1].unlocked then
			ovrAuth=true
		end
	end


	if (targ2-config.plots.width)>(0) then
		if tiles[targ2-config.plots.width].unlocked then
			ovrAuth=true
		end
	end

	if (targ2+config.plots.width)<=(config.plots.width*config.plots.height) then
		if tiles[targ2+config.plots.width].unlocked then
			ovrAuth=true
		end
	end

	return ovrAuth
end


function love.mousepressed(x, y, button, istouch)
	lastClick.x,lastClick.y=x,y
	if button==1 then
		if gamestate=="game" then
			if menu=="none" then
				_TEMP=checkTile(x,y)
				if _TEMP then
					modifying=_TEMP
					for j=1,#classTypes do
						if tiles[_TEMP].class==classTypes[j] then
							pointer=j
						end
					end
					if tiles[_TEMP].unlocked then
						menu="properties"
					else
						if player.yams>=finance.appraise() then
							if authUnlock(_TEMP) then
								player.yams=player.yams-finance.appraise()
								tiles[_TEMP].unlocked=true --TEMPORARY
								player.unlocked[#player.unlocked+1]=_TEMP
								output=output.."called appraise\n"
							else
								fade=255
							end
						else
							fade=255
						end
						modifying=0
					end
				end
			end
		end
 	end
end

function love.keyreleased(key)
	lastKey=key

	if key=="l" then --DEBUG
		tot=tot+5
	end

	if menu=="exit" then
		if key=="y" then
			love.quit()
		elseif key=="n" or key=="escape" then
			menu="none"
		end
	elseif menu=="properties" then
		if key=="escape" then
			modifying = 0
			menu="none"
		elseif key=="space" then
			love.keyreleased("return")
		elseif key=="up" or key=="w" then
			if pointer==1 then
				pointer=#classTypes
			else
				pointer=pointer-1
			end
		elseif key=="down" or key=="s" then
			if pointer==#classTypes then
				pointer=1
			else
				pointer=pointer+1
			end
		elseif key=="return" then
			finance.develop(modifying,classTypes[pointer])
		elseif key=="1" or key=="2" or key=="3" or key=="4" or key=="5" or key=="6" or key=="7" or key=="8" or key=="9" then
			if tonumber(key)<=#classTypes then
				pointer=tonumber(key)
			end
		end
	elseif menu=="event" then
		menu="none"
		events[curEvent].onInstance()
		curEvent=curEvent+1
	elseif menu=="none" then
	    if key=="escape" then
	    	menu="exit"
	    elseif key=="space" then
	    	love.mousepressed(love.mouse.getX(),love.mouse.getY(),1,false)
	    end
	end
end

function love.quit()
	--love.system.setClipboardText(table_print(tiles))
	love.window.close()
end