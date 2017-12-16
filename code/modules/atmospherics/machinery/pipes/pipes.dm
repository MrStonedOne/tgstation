/obj/machinery/atmospherics/pipe
	var/datum/gas_mixture/air_temporary //used when reconstructing a pipeline that broke
	var/volume = 0

	level = 1

	use_power = NO_POWER_USE
	can_unwrench = 1
	var/datum/pipeline/parent = null

	//Buckling
	can_buckle = 1
	buckle_requires_restraints = 1
	buckle_lying = -1

/obj/machinery/atmospherics/pipe/New()
	procstart = null
	src.procstart = null
	add_atom_colour(pipe_color, FIXED_COLOUR_PRIORITY)
	volume = 35 * device_type
	..()

/obj/machinery/atmospherics/pipe/nullifyNode(I)
	procstart = null
	src.procstart = null
	var/obj/machinery/atmospherics/oldN = NODE_I
	..()
	if(oldN)
		oldN.build_network()

/obj/machinery/atmospherics/pipe/destroy_network()
	procstart = null
	src.procstart = null
	QDEL_NULL(parent)

/obj/machinery/atmospherics/pipe/build_network()
	procstart = null
	src.procstart = null
	if(QDELETED(parent))
		parent = new
		parent.build_pipeline(src)

/obj/machinery/atmospherics/pipe/update_icon() //overridden by manifolds
	if(NODE1&&NODE2)
		icon_state = "intact[invisibility ? "-f" : "" ]"
	else
		var/have_node1 = NODE1?1:0
		var/have_node2 = NODE2?1:0
		icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"

/obj/machinery/atmospherics/pipe/atmosinit()
	procstart = null
	src.procstart = null
	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	..()

/obj/machinery/atmospherics/pipe/hide(i)
	procstart = null
	src.procstart = null
	if(level == 1 && isturf(loc))
		invisibility = i ? INVISIBILITY_MAXIMUM : 0
	update_icon()

/obj/machinery/atmospherics/pipe/proc/releaseAirToTurf()
	procstart = null
	src.procstart = null
	if(air_temporary)
		var/turf/T = loc
		T.assume_air(air_temporary)
		air_update_turf()

/obj/machinery/atmospherics/pipe/return_air()
	procstart = null
	src.procstart = null
	return parent.air

/obj/machinery/atmospherics/pipe/attackby(obj/item/W, mob/user, params)
	procstart = null
	src.procstart = null
	if(istype(W, /obj/item/device/analyzer))
		atmosanalyzer_scan(parent.air, user)
	if(istype(W, /obj/item/pipe_meter))
		var/obj/item/pipe_meter/meter = W
		user.dropItemToGround(meter)
		meter.setAttachLayer(piping_layer)
	else
		return ..()

/obj/machinery/atmospherics/pipe/returnPipenet()
	procstart = null
	src.procstart = null
	return parent

/obj/machinery/atmospherics/pipe/setPipenet(datum/pipeline/P)
	procstart = null
	src.procstart = null
	parent = P

/obj/machinery/atmospherics/pipe/Destroy()
	procstart = null
	src.procstart = null
	releaseAirToTurf()
	qdel(air_temporary)
	air_temporary = null

	var/turf/T = loc
	for(var/obj/machinery/meter/meter in T)
		if(meter.target == src)
			var/obj/item/pipe_meter/PM = new (T)
			meter.transfer_fingerprints_to(PM)
			qdel(meter)
	. = ..()

	QDEL_NULL(parent)

/obj/machinery/atmospherics/pipe/proc/update_node_icon()
	procstart = null
	src.procstart = null
	for(DEVICE_TYPE_LOOP)
		if(NODE_I)
			var/obj/machinery/atmospherics/N = NODE_I
			N.update_icon()

/obj/machinery/atmospherics/pipe/returnPipenets()
	procstart = null
	src.procstart = null
	. = list(parent)

/obj/machinery/atmospherics/pipe/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	procstart = null
	src.procstart = null
	if(damage_flag == "melee" && damage_amount < 12)
		return 0
	. = ..()

/obj/machinery/atmospherics/pipe/proc/paint(paint_color)
	procstart = null
	src.procstart = null
	add_atom_colour(paint_color, FIXED_COLOUR_PRIORITY)
	pipe_color = paint_color
	update_node_icon()
	return TRUE

