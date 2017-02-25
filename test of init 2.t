type blobBounds :
    record
	minX : int
	maxX : int
	minY : int
	maxY : int
	size : int
    end record
    
var debugWindow : int := 0
Window.SetActive(0)
var debugFile : int := -1

proc debug(text:string)
    %var temp : int := Window.GetSelect
    
    %if debugWindow = 0 then
    %    debugWindow := Window.Open("title:Debug Window")
    %end if
    
    if debugFile = -1 then
	open(debugFile, "DebugLogAux.txt", "w")
    end if
    
    %Window.SetActive(debugWindow)
    %put text ..
    put : debugFile, text ..
    
    %Window.SetActive(temp)
end debug

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var numBoxes := 46
var boundingBoxes : array 1 .. 45 of blobBounds := init (
    init (241,245,1,9,23),
    init (208,219,22,33,94),
    init (207,219,35,60,215),
    init (285,292,35,43,33),
    init (285,294,46,55,48),
    
    init (284,294,57,67,88),
    init (209,218,62,74,69),
    init (302,306,63,71,25),
    init (146,150,70,77,23),
    init (286,293,72,78,37),
    
    init (40,54,73,88,85),
    init (301,309,75,84,46),
    init (285,294,80,90,86),
    init (188,197,88,92,24),
    init (299,309,92,101,60),
    
    init (48,55,95,105,29),
    init (270,280,103,113,100),
    init (284,295,103,125,195),
    init (299,304,104,113,28),
    init (306,308,104,113,23),
    
    
    init (46,54,114,126,48),
    init (272,280,115,124,36),
    init (299,309,115,124,96),
    init (361,369,117,124,31),
    init (143,147,118,126,21),
    
    init (360,368,131,136,30),
    init (43,54,133,142,38),
    init (298,307,146,154,48),
    init (316,322,146,155,35),
    init (40,55,152,168,99),
    
    init (299,305,157,166,28),
    init (340,360,166,183,216),
    init (299,306,169,177,28),
    init (313,321,169,177,39),
    init (359,367,170,174,26),
    
    init (38,44,173,186,35),
    init (48,55,173,185,38),
    init (298,307,180,189,41),
    init (313,321,180,190,68),
    init (40,53,192,207,65),
    
    
    init (38,54,212,227,97),
    init (162,168,231,264,130),
    init (38,43,232,245,38),
    init (46,54,232,246,60),
    init (40,53,252,264,63) 
)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for num : 1 .. numBoxes-1
    debug("x:" + intstr(boundingBoxes(num).minX,3) + "-" + intstr(boundingBoxes(num).maxX,3) + "\ty:" + intstr(boundingBoxes(num).minY,3) + "-" + intstr(boundingBoxes(num).maxY,3) + "\tt:" + intstr(boundingBoxes(num).size) + chr(10))
end for
