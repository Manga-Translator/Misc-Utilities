type testType : 
    record
	x : int
	y : int
	z : int
    end record

var stringArray : array 1 .. 5 of string := init (" ", " ", " ", " ", " ")
var testVar : testType := init (1,2,3)

var testArray : array 1 .. 3 of testType := init (init(1,2,3),init(4,5,6),init(7,8,9))
