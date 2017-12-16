/obj/machinery/atmospherics/pipe/heat_exchanging/simple
	icon_state = "intact"

	name = "pipe"
	desc = "A one meter section of heat-exchanging pipe."

	dir = SOUTH
	initialize_directions_he = SOUTH|NORTH

	device_type = BINARY

	construction_type = /obj/item/pipe/binary/bendable
	pipe_state = "he"

/obj/machinery/atmospherics/pipe/heat_exchanging/simple/SetInitDirections()
	procstart = null
	src.procstart = null
	if(dir in GLOB.diagonals)
		initialize_directions_he = dir
	switch(dir)
		if(NORTH,SOUTH)
			initialize_directions_he = SOUTH|NORTH
		if(EAST,WEST)
			initialize_directions_he = WEST|EAST

/obj/machinery/atmospherics/pipe/heat_exchanging/simple/proc/normalize_dir()
	procstart = null
	src.procstart = null
	if(dir==SOUTH)
		setDir(NORTH)
	else if(dir==WEST)
		setDir(EAST)

/obj/machinery/atmospherics/pipe/heat_exchanging/simple/atmosinit()
	procstart = null
	src.procstart = null
	normalize_dir()
	..()

/obj/machinery/atmospherics/pipe/heat_exchanging/simple/update_icon()
	procstart = null
	src.procstart = null
	normalize_dir()
	..()
