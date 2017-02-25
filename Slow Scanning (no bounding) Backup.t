/*
% NOTES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 next steps:
 bounding boxes for each blob
   -bounding boxes enable faster search for new pixels (only search negbouring pixels to current bounds)
       -faster searching for pixels would alow elimination of noise filtering, which corrodes text
   -Note: be careful about bounds extending beond border (might have to start clamping and checking during scans)
       -non issue if scans are only to bounds+1
       
 possible specific class/treatment for very small blobs to separate [...]
   -they can still be included if near a character (larger blob, but can otherwise be ignored)

 extend level differentiation to anti-noise (possible redesign/repeated passes)
 take neghbours into account when determing level
 return to min/max blob level
 
 when doing blob area scanning, either ----what's a chracter and what isn't?
    use a grid based on the bounding box to find whitespace
    extend bounds until they hit a too-large blob, then retract 1/2 way to characters
    
 remember to add minimum whitespace to extracted text for tesseract
 
 write a bitmap color analyser
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
%init
var picID, width, height : int
var fileName, settings : string
fileName := "test1.jpg"
%fileName := "savepoint.bmp"
picID := Pic.FileNew (fileName)

var debugWindow : int := 0
Window.SetActive(0)
var debugFile : int := -1

/*
proc putWin(text:string,window:int)
    var temp : int := Window.GetSelect
    
    Window.SetActive(window)
    put text
    
    Window.SetActive(temp)
end putWin
*/

proc debug(text:string)
    var temp : int := Window.GetSelect
    
    if debugWindow = 0 then
	debugWindow := Window.Open("title:Debug Window")
    end if
    
    if debugFile = -1 then
	open(debugFile, "DebugLog.txt", "w")
    end if
    
    Window.SetActive(debugWindow)
    put text ..
    put : debugFile, text ..
    
    Window.SetActive(temp)
end debug

/*
%b/w-ization-ifyer
function checkLevel(x, y, thresh : int) : int
    if View.WhatDotColor(x,y) = white then
	result white
    else
	result black
    end if
end checkLevel
*/

%b/w-ization-ifyer V2
function checkLevel2(x, y, thresh : int) : int
    var pixel : int := View.WhatDotColor(x,y)
    var level : int
    
    if pixel = 7 then
	level := 0
    elsif pixel = 15 then
	level := 9
    elsif pixel = 8 then
	level := 14
    elsif pixel = 0 then
	level := 17
    elsif pixel >= 16 and pixel <= 24 then
	level := pixel - 16
    elsif pixel >= 25 and pixel <= 28 then
	level := pixel - 15
    elsif pixel >= 29 and pixel <= 31 then
	level := pixel - 14
    else
	debug(chr(10) + "Unrecognised color detected (" + intstr(pixel) + ") at (" + intstr(x) + "," + intstr(y) + ")" + chr(10))
	break
	level := 17 %default white (questionable but sometimes nessisary in testing)
    end if
    
    var threshold : int := 15
    
    if level >= threshold then
	result white
    else
	result black
    end if 
end checkLevel2

/*
function checkNoise(x, y, thresh : int) : int
    var thisDot : int
    var score : int := 0
    thisDot := View.WhatDotColor(x,y)
    
    if View.WhatDotColor(x+1,y) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x,y+1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x,y-1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x+1,y+1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y-1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x+1,y-1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y+1) = thisDot then
	score := score +1
    end if
    if not (score <= thresh) then
	result thisDot
    else
	if thisDot = black then
	    result white
	else
	    result black
	end if
    end if
end checkNoise
*/

/*
function checkNoise2(x, y : int) : int
    %version 2 ignores white noise, prefering black noise as seen around text
    var thisDot : int
    var score : int := 0
    
    var threshold : int := 3
    
    thisDot := View.WhatDotColor(x,y)
    if thisDot = white then
	result white
    end if
    
    if View.WhatDotColor(x+1,y) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x,y+1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x,y-1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x+1,y+1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y-1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x+1,y-1) = thisDot then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y+1) = thisDot then
	score := score +1
    end if
    if not (score <= threshold) then
	result black
    else
	result white
    end if
end checkNoise2
*/

function checkNoise3(x, y : int) : int
    %version 2 ignores white noise, prefering black noise as seen around text
    var score : int := 0
    
    var threshold : int := 6

    if View.WhatDotColor(x,y) = white then
	result white
    end if
    
    if View.WhatDotColor(x+1,y) = white then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y) = white then
	score := score +1
    end if
    if View.WhatDotColor(x,y+1) = white then
	score := score +1
    end if
    if View.WhatDotColor(x,y-1) = white then
	score := score +1
    end if
    if View.WhatDotColor(x+1,y+1) = white then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y-1) = white then
	score := score +1
    end if
    if View.WhatDotColor(x+1,y-1) = white then
	score := score +1
    end if
    if View.WhatDotColor(x-1,y+1) = white then
	score := score +1
    end if
    if (score >= threshold) then
	result white
    else
	result black
    end if
end checkNoise3

/*
proc drawText(text : string, x,y : int)
    var font : int := Font.New ("serif:12")
    var width := length(text)*8
    Draw.FillBox(x,y,x+width,y+16,white)
    Draw.Text(text,x,y,font,black)
end drawText
*/

%start of program
if picID = 0 then
    put "error opening file"
else
    %prep for picture
    width := Pic.Width(picID)
    height := Pic.Height(picID)

    settings := "graphics:" + intstr(width) + ";" + intstr(height)
    View.Set (settings)
    
    %Draw.Fill (0, 0, white, yellow)
    
    %draw picture
    Pic.Draw(picID, 0, 0, picCopy)

    %b/w-ize picture (we don't care beyond white and not-white pixels)
    for j : 0 .. height
	for i : 0 .. width
	    Draw.Dot(i, j, checkLevel2(i, j, 0))
	end for
    end for
    
    %remove noise
    for j : 0 .. height
	for i : 0 .. width
	    Draw.Dot(i, j, checkNoise3(i, j))
	end for
    end for

    %test for blobs
    var total : int
    var found : boolean
    for j : 0 .. height
	for i : 0 .. width
	    %new canidate start pixel
	    
	    %pixel is black (undiscovered)
	    if View.WhatDotColor(i,j) = black then
		%start of new blob
		total := 1
		%new seed blue pixel
		Draw.Dot(i,j,brightblue)
		%put "S" .. 
	    
		%series of scans to add to blob
		loop
		    found := false
		
		    %scan for new black pixels to add
		    for m : 0 .. height
			for n : 0 .. width
			    %if black and a neghbour of blue
			    if View.WhatDotColor(n,m) = black then
				if (
				    View.WhatDotColor(n+1,m) = brightblue or
				    View.WhatDotColor(n,m+1) = brightblue or
				    View.WhatDotColor(n-1,m) = brightblue or
				    View.WhatDotColor(n,m-1) = brightblue
				) then
				    Draw.Dot(n,m,brightblue)
				    total := total +1
				    found := true
				end if
			    end if
			end for
		    end for
		    
		    if found = true then
			for decreasing m : height .. 0
			    for n : 0 .. width
				%if black and a neghbour of blue
				if View.WhatDotColor(n,m) = black then
				    if (
					View.WhatDotColor(n+1,m) = brightblue or
					View.WhatDotColor(n,m+1) = brightblue or
					View.WhatDotColor(n-1,m) = brightblue or
					View.WhatDotColor(n,m-1) = brightblue
				    ) then
					Draw.Dot(n,m,brightblue)
					total := total +1
					found := true
				    end if
				end if
			    end for
			end for
		    
			for m : 0 .. height
			    for decreasing n : width .. 0
				%if black and a neghbour of blue
				if View.WhatDotColor(n,m) = black then
				    if (
					View.WhatDotColor(n+1,m) = brightblue or
					View.WhatDotColor(n,m+1) = brightblue or
					View.WhatDotColor(n-1,m) = brightblue or
					View.WhatDotColor(n,m-1) = brightblue
				    ) then
					Draw.Dot(n,m,brightblue)
					total := total +1
					found := true
				    end if
				end if
			    end for
			end for
		    
			for decreasing m : height .. 0
			    for decreasing n : width .. 0
				%if black and a neghbour of blue
				if View.WhatDotColor(n,m) = black then
				    if (
					View.WhatDotColor(n+1,m) = brightblue or
					View.WhatDotColor(n,m+1) = brightblue or
					View.WhatDotColor(n-1,m) = brightblue or
					View.WhatDotColor(n,m-1) = brightblue
				    ) then
					Draw.Dot(n,m,brightblue)
					total := total +1
					found := true
				    end if
				end if
			    end for
			end for
			
		    end if
		
		    if found = false then
			exit
		    end if
		end loop
		%have found all of this blob
		
		
		%recolor depending on type
		if total > 20000 then
		    %recolor from blue to appropriate color
		    for m : 0 .. height
			for n : 0 .. width
			    if View.WhatDotColor(n,m) = brightblue then
				Draw.Dot(n,m,red)
			    end if
			end for
		    end for
		else
		    if total < 20 and total not = 0 then
			%recolor from blue to appropriate color
			for m : 0 .. height
			    for n : 0 .. width
				if View.WhatDotColor(n,m) = brightblue then
				    Draw.Dot(n,m,brightred)
				end if
			    end for
			end for
		    else
			%recolor from blue to appropriate color
			if total not = 0 then
			    for m : 0 .. height
				for n : 0 .. width
				    if View.WhatDotColor(n,m) = brightblue then
					Draw.Dot(n,m,brightgreen)
				    end if
				end for
			    end for
			end if
		    end if
		end if
		
		
		/*
		%recolor blob to avoid redetection
		for m : 0 .. height
		    for n : 0 .. width
			if View.WhatDotColor(n,m) = brightblue then
			    Draw.Dot(n,m,green)
			end if
		    end for
		end for
		*/
		
		%debug("Blob total: " + intstr(total) + chr(10))
		debug(intstr(total) + " ")
		
	    end if
	end for
    end for
    
    Draw.Fill(0,0,black,brightgreen)
    
end if
