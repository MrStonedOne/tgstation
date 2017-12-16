// See _DEFINES/is_helpers.dm for type helpers

/*
Name:	IsSpecialAssembly
Desc:	If true is an object that can be attached to an assembly holder but is a special thing like a plasma can or door
*/

/obj/proc/IsSpecialAssembly()
	procstart = null
	src.procstart = null
	return 0

/*
Name:	IsAssemblyHolder
Desc:	If true is an object that can hold an assemblyholder object
*/
/obj/proc/IsAssemblyHolder()
	procstart = null
	src.procstart = null
	return 0