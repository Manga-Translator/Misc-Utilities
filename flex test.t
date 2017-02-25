var boundingBoxs : flexible array 0 .. -1 of int
var numBoxes : int := 0

put "initial: " + intstr(upper(boundingBoxs))

for i : 10 .. 200 by 10
    numBoxes := numBoxes +1
    new boundingBoxs, numBoxes
    put upper(boundingBoxs)
    boundingBoxs(numBoxes) := i
end for

put "final: " + intstr(upper(boundingBoxs))

/*
for num : 0 .. numBoxes -1
    put boundingBoxs(num+1)
end for
*/
