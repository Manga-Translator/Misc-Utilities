var picID, width, height : int
var fileName, settings : string
fileName := "test1.jpg"
picID := Pic.FileNew (fileName)

if picID = 0 then
    put "error opening file"
else
    %prep for picture
    width := Pic.Width(picID)
    height := Pic.Height(picID)
    
    settings := "graphics:"
    %settings := "graphics:" + intstr(width) + ";" + intstr(height)
    View.Set (settings)
    
    %Draw.Fill (0, 0, white, yellow)
    
    %draw picture
    Pic.Draw(picID, 0, 0, picCopy)
    
    var tally : array 0 .. 40 of int
    
    for x : 0 .. 40
	tally(x) := 0
    end for
    
    var pos : int
    
    for i : 0 .. width
	for j : 0 .. height
	    pos := View.WhatDotColor(i,j)
	    
	    tally(pos) := tally(pos) +1
	    
	end for
    end for
    
    cls
    
    for z : 0 .. 40
	if tally(z) not = 0 then
	    put intstr(z) + " " + intstr(tally(z))
	end if
    end for
    
end if
