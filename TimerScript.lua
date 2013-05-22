--(c) Nvirjskly 2013
--

local t = 0.6
local s = redstone.getSides()

function saveT()
	file = fs.open("timerTime","w")
	file.write(tostring(t))
	file.close()
end

function printTimer()
	tStr = tostring(t);
	if tStr:sub(#tStr-1,#tStr-1) == "." then tStr=tStr.."0" end
	timerString = "Timer: " .. tStr .. " seconds"
	if not term.isColor() then
		term.clear()
		term.setCursorPos(1,1)
		term.write("Timer: " .. timerString .. " seconds")
		term.setCursorPos(1,2)
		term.write("Up arrow +0.05")
		term.setCursorPos(1,3)
		term.write("Down arrow -0.05")
		term.setCursorPos(1,4)
		term.write("Right arrow +1.0")
		term.setCursorPos(1,5)
		term.write("Left arrow -1.0")
	else
		fullBgStr = "                                  "
	
	
		term.setBackgroundColor(colors.black)
		term.clear()
		
		term.setCursorPos(9,7)
		term.setBackgroundColor(colors.gray)
		term.write(fullBgStr)
		term.setCursorPos(9,8)
		term.setBackgroundColor(colors.gray)
		term.write(fullBgStr)
		
		term.setTextColor(colors.black)
		term.setCursorPos(27-(#timerString/2),8)
		term.setBackgroundColor(colors.cyan)
		term.write(timerString)
		
		
		
		term.setCursorPos(9,9)
		term.setBackgroundColor(colors.gray)
		term.write(fullBgStr)
		
		
		term.setCursorPos(9,10)
		term.setBackgroundColor(colors.gray)
		term.write("  ")
		term.setBackgroundColor(colors.cyan)
		term.setTextColor(colors.black)
		
		term.write("-10")
		term.setBackgroundColor(colors.gray)
		term.write("  ")
		term.setBackgroundColor(colors.cyan)
		term.write("-1")
		term.setBackgroundColor(colors.gray)
		term.write("  ")
		term.setBackgroundColor(colors.cyan)
		term.write("-0.05")
		term.setBackgroundColor(colors.gray)
		term.write("  ")
		term.setBackgroundColor(colors.cyan)
		term.write("+0.05")
		term.setBackgroundColor(colors.gray)
		term.write("  ")
		term.setBackgroundColor(colors.cyan)
		term.write("+1")
		term.setBackgroundColor(colors.gray)
		term.write("  ")
		term.setBackgroundColor(colors.cyan)
		term.write("+10")	
		term.setBackgroundColor(colors.gray)
		term.write("  ")
		
		term.setCursorPos(9,11)
		term.setBackgroundColor(colors.gray)
		term.write(fullBgStr)
		
	end
end

function timer()
	if not redstone.getInput("front") then
		for i = 1, #s do
			if not (s[i] == "front") then
				redstone.setOutput(s[i],true)
			end
		end
		keyPress(0.2)
		for i = 1, #s do
			if not (s[i] == "front") then
				redstone.setOutput(s[i],false)
			end
		end
		keyPress(t-0.3)
	end
	keyPress(0.1)
	printTimer()
end

function keyPress(r)
	os.startTimer(r)
	evt = false;
	while not evt do
		ev,key,x,y = os.pullEvent()
		if ev == "key" then changeTKey(key) end
		if ev == "mouse_click" then changeTScreen(x,y) end
		if ev == "timer" then evt=true end
	end
end



function changeTScreen(x,y)
	pt = t
	if y == 10 then
		if x>=11 and x<=13 then
			t=t-10
		elseif x>=16 and x<=17 then
			t=t-1
		elseif x>=19 and x<=24 then
			t=t-0.05
		elseif x>=27 and x<=31 then
			t=t+0.05
		elseif x>=34 and x<=35 then
			t=t+1
		elseif x>=38 and x<=40 then
			t=t+10
		end
	end
	if t < 0.3 then
		t = 0.3
	end
	if not (pt == t) then saveT() end
	printTimer()
end

function changeTKey(key)
	pt = t
	if key == 200 then
		t = t+0.05
	elseif key == 208 then
		t = t-0.05
	elseif key == 205 then
		t = t+1.0
	elseif key == 203 then
		t = t-1.0
	end
	if t < 0.3 then
		t = 0.3
	end
	if not (pt == t) then saveT() end
	printTimer()
end

if fs.exists("timerTime") then
	file = fs.open("timerTime","r")
	t = tonumber(file.readAll())
	file.close()
else
	saveT()
end

printTimer()
while 1 do
	timer()
end