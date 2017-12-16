/obj/machinery/door/unpowered

/obj/machinery/door/unpowered/CollidedWith(atom/movable/AM)
	procstart = null
	src.procstart = null
	if(src.locked)
		return
	..()
	return


/obj/machinery/door/unpowered/attackby(obj/item/I, mob/user, params)
	procstart = null
	src.procstart = null
	if(locked)
		return
	else
		return ..()

/obj/machinery/door/unpowered/emag_act()
	procstart = null
	src.procstart = null
	return

/obj/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = TRUE
	explosion_block = 1