--tocite
--[[

]]

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
	fade=0
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
	--called every frame
	if fade>0 then
		fade=fade-4 --FADE RATE
	end

	if fade<0 then
		fade=0
	end



	if menu=="exit" then love.window.close() end -- DEBUGGING



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

    	love.graphics.setColor(unpack(config.colors.midgray))
    	love.graphics.rectangle("fill", priceLeftBound+4, priceUpperBound+4, priceRightBound-priceLeftBound, priceLowerBound-priceUpperBound)
    	love.graphics.setColor(unpack(config.colors.lightgray))
    	love.graphics.rectangle("fill", priceLeftBound, priceUpperBound, priceRightBound-priceLeftBound, priceLowerBound-priceUpperBound)
    	love.graphics.setColor(unpack(config.colors.black))
    	love.graphics.printf("Pricing Info", priceLeftBound/2, priceUpperBound+15, priceRightBound/2, "center", 0,2,2.25)
    	love.graphics.printf("_", priceLeftBound/25+25, priceUpperBound+14, priceRightBound/25, "center", 0,25,2)


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
	debugText("YAMS",player.yams)
    --*******DEBUG********--


    love.graphics.setColor(config.colors.blood[1],config.colors.blood[2],config.colors.blood[3],fade)
    love.graphics.rectangle("fill", 1, 1, width, height)

end --end draw

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
							player.yams=player.yams-finance.appraise()
							tiles[_TEMP].unlocked=true --TEMPORARY
							player.unlocked[#player.unlocked+1]=_TEMP
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