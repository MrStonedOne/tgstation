/obj/machinery/bluespace_beacon

	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "bluespace gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	level = 1		// underfloor
	layer = LOW_OBJ_LAYER
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 0
	var/obj/item/device/radio/beacon/Beacon

/obj/machinery/bluespace_beacon/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	var/turf/T = loc
	Beacon = new(T)
	Beacon.invisibility = INVISIBILITY_MAXIMUM

	hide(T.intact)

/obj/machinery/bluespace_beacon/Destroy()
	procstart = null
	src.procstart = null
	QDEL_NULL(Beacon)
	return ..()

// update the invisibility and icon
/obj/machinery/bluespace_beacon/hide(intact)
	procstart = null
	src.procstart = null
	invisibility = intact ? INVISIBILITY_MAXIMUM : 0
	updateicon()

// update the icon_state
/obj/machinery/bluespace_beacon/proc/updateicon()
	procstart = null
	src.procstart = null
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"

	else
		icon_state = "[state]"

/obj/machinery/bluespace_beacon/process()
	procstart = null
	src.procstart = null
	if(!Beacon)
		var/turf/T = loc
		Beacon = new(T)
		Beacon.invisibility = INVISIBILITY_MAXIMUM
	else if (Beacon.loc != loc)
		Beacon.forceMove(loc)

	updateicon()
