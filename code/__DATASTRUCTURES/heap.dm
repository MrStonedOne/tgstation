
//////////////////////
//Heap object
//////////////////////

/Heap
	var/list/L
	var/cmp

/Heap/New(compare)
	procstart = null
	src.procstart = null
	L = new()
	cmp = compare

/Heap/proc/IsEmpty()
	procstart = null
	src.procstart = null
	return !L.len

//Insert and place at its position a new node in the heap
/Heap/proc/Insert(atom/A)

	procstart = null
	src.procstart = null
	L.Add(A)
	Swim(L.len)

//removes and returns the first element of the heap
//(i.e the max or the min dependant on the comparison function)
/Heap/proc/Pop()
	procstart = null
	src.procstart = null
	if(!L.len)
		return 0
	. = L[1]

	L[1] = L[L.len]
	L.Cut(L.len)

	Sink(1)

//Get a node up to its right position in the heap
/Heap/proc/Swim(var/index)
	procstart = null
	src.procstart = null
	var/parent = round(index * 0.5)

	while(parent > 0 && (call(cmp)(L[index],L[parent]) > 0))
		L.Swap(index,parent)
		index = parent
		parent = round(index * 0.5)

//Get a node down to its right position in the heap
/Heap/proc/Sink(var/index)
	procstart = null
	src.procstart = null
	var/g_child = GetGreaterChild(index)

	while(g_child > 0 && (call(cmp)(L[index],L[g_child]) < 0))
		L.Swap(index,g_child)
		index = g_child
		g_child = GetGreaterChild(index)

//Returns the greater (relative to the comparison proc) of a node children
//or 0 if there's no child
/Heap/proc/GetGreaterChild(var/index)
	procstart = null
	src.procstart = null
	if(index * 2 > L.len)
		return 0

	if(index * 2 + 1 > L.len)
		return index * 2

	if(call(cmp)(L[index * 2],L[index * 2 + 1]) < 0)
		return index * 2 + 1
	else
		return index * 2

//Replaces a given node so it verify the heap condition
/Heap/proc/ReSort(atom/A)
	procstart = null
	src.procstart = null
	var/index = L.Find(A)

	Swim(index)
	Sink(index)

/Heap/proc/List()
	procstart = null
	src.procstart = null
	. = L.Copy()
