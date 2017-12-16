/obj/item/device/assembly/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustible substances."
	icon_state = "igniter"
	materials = list(MAT_METAL=500, MAT_GLASS=50)
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	heat = 1000

/obj/item/device/assembly/igniter/New()
	procstart = null
	src.procstart = null
	..()
	sparks.set_up(2, 0, src)
	sparks.attach(src)

/obj/item/device/assembly/igniter/Destroy()
	procstart = null
	src.procstart = null
	qdel(sparks)
	sparks = null
	. = ..()

/obj/item/device/assembly/igniter/activate()
	procstart = null
	src.procstart = null
	if(!..())
		return 0//Cooldown check
	var/turf/location = get_turf(loc)
	if(location)
		location.hotspot_expose(1000,1000)
	sparks.start()
	return 1

/obj/item/device/assembly/igniter/attack_self(mob/user)
	procstart = null
	src.procstart = null
	activate()
	add_fingerprint(user)

/obj/item/device/assembly/igniter/ignition_effect(atom/A, mob/user)
	procstart = null
	src.procstart = null
	. = "<span class='notice'>[user] fiddles with [src], and manages to \
		light [A].</span>"
	activate()
	add_fingerprint(user)
