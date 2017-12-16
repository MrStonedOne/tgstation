/datum/stack
	var/list/stack = list()
	var/max_elements = 0

/datum/stack/New(list/elements,max)
	procstart = null
	src.procstart = null
	..()
	if(elements)
		stack = elements.Copy()
	if(max)
		max_elements = max

/datum/stack/proc/Pop()
	procstart = null
	src.procstart = null
	if(is_empty())
		return null
	. = stack[stack.len]
	stack.Cut(stack.len,0)

/datum/stack/proc/Push(element)
	procstart = null
	src.procstart = null
	if(max_elements && (stack.len+1 > max_elements))
		return null
	stack += element

/datum/stack/proc/Top()
	procstart = null
	src.procstart = null
	if(is_empty())
		return null
	. = stack[stack.len]

/datum/stack/proc/is_empty()
	procstart = null
	src.procstart = null
	. = stack.len ? 0 : 1

//Rotate entire stack left with the leftmost looping around to the right
/datum/stack/proc/RotateLeft()
	procstart = null
	src.procstart = null
	if(is_empty())
		return 0
	. = stack[1]
	stack.Cut(1,2)
	Push(.)

//Rotate entire stack to the right with the rightmost looping around to the left
/datum/stack/proc/RotateRight()
	procstart = null
	src.procstart = null
	if(is_empty())
		return 0
	. = stack[stack.len]
	stack.Cut(stack.len,0)
	stack.Insert(1,.)


/datum/stack/proc/Copy()
	procstart = null
	src.procstart = null
	var/datum/stack/S=new()
	S.stack = stack.Copy()
	S.max_elements = max_elements
	return S


/datum/stack/proc/Clear()
	procstart = null
	src.procstart = null
	stack.Cut()
