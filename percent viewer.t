var width := 370
var height := 352
var area := width*height
put area

var percentage := 1

Draw.FillBox(0,0,width,height,black)

var newArea := (percentage/100)*area
put newArea
var newWidth := ceil(sqrt(newArea))
var newHeight := newWidth

Draw.FillBox(0,0,newWidth,newHeight,white)
