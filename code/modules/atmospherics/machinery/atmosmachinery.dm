/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
#define PIPE_VISIBLE_LEVEL 2
#define PIPE_HIDDEN_LEVEL 1

/obj/machinery/atmospherics
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON
	on_blueprints = TRUE
	layer = GAS_PIPE_HIDDEN_LAYER //under wires
	resistance_flags = FIRE_PROOF
	max_integrity = 200
	var/nodealert = 0
	var/can_unwrench = 0
	var/initialize_directions = 0
	var/pipe_color
	var/piping_layer = PIPING_LAYER_DEFAULT
	var/pipe_flags = NONE

	var/global/list/iconsetids = list()
	var/global/list/pipeimages = list()

	var/image/pipe_vision_img = null

	var/device_type = 0
	var/list/obj/machinery/atmospherics/nodes

	var/construction_type
	var/pipe_state //icon_state as a pipe item

/obj/machinery/atmospherics/examine(mob/user)
	procstart = null
	src.procstart = null
	..()
	if(is_type_in_list(src, GLOB.ventcrawl_machinery) && isliving(user))
		var/mob/living/L = user
		if(L.ventcrawler)
			to_chat(L, "<span class='notice'>Alt-click to crawl through it.</span>")

/obj/machinery/atmospherics/New(loc, process = TRUE, setdir)
	procstart = null
	src.procstart = null
	if(!isnull(setdir))
		setDir(setdir)
	if(pipe_flags & PIPING_CARDINAL_AUTONORMALIZE)
		normalize_cardinal_directions()
	nodes = new(device_type)
	if (!armor)
		armor = list(melee = 25, bullet = 10, laser = 10, energy = 100, bomb = 0, bio = 100, rad = 100, fire = 100, acid = 70)
	..()
	if(process)
		SSair.atmos_machinery += src
	SetInitDirections()

/obj/machinery/atmospherics/Destroy()
	procstart = null
	src.procstart = null
	for(DEVICE_TYPE_LOOP)
		nullifyNode(I)

	SSair.atmos_machinery -= src

	dropContents()
	if(pipe_vision_img)
		qdel(pipe_vision_img)

	return ..()
	//return QDEL_HINT_FINDREFERENCE

/obj/machinery/atmospherics/proc/destroy_network()
	procstart = null
	src.procstart = null
	return

/obj/machinery/atmospherics/proc/build_network()
	procstart = null
	src.procstart = null
	// Called to build a network from this node
	return

/obj/machinery/atmospherics/proc/nullifyNode(I)
	procstart = null
	src.procstart = null
	if(NODE_I)
		var/obj/machinery/atmospherics/N = NODE_I
		N.disconnect(src)
		NODE_I = null

/obj/machinery/atmospherics/proc/getNodeConnects()
	procstart = null
	src.procstart = null
	var/list/node_connects = list()
	node_connects.len = device_type

	for(DEVICE_TYPE_LOOP)
		for(var/D in GLOB.cardinals)
			if(D & GetInitDirections())
				if(D in node_connects)
					continue
				node_connects[I] = D
				break
	return node_connects

/obj/machinery/atmospherics/proc/normalize_cardinal_directions()
	procstart = null
	src.procstart = null
	if(dir==SOUTH)
		setDir(NORTH)
	else if(dir==WEST)
		setDir(EAST)

//this is called just after the air controller sets up turfs
/obj/machinery/atmospherics/proc/atmosinit(var/list/node_connects)
	procstart = null
	src.procstart = null
	if(!node_connects) //for pipes where order of nodes doesn't matter
		node_connects = getNodeConnects()

	for(DEVICE_TYPE_LOOP)
		for(var/obj/machinery/atmospherics/target in get_step(src,node_connects[I]))
			if(can_be_node(target, I))
				NODE_I = target
				break
	update_icon()

/obj/machinery/atmospherics/proc/setPipingLayer(new_layer)
	procstart = null
	src.procstart = null
	if(pipe_flags & PIPING_DEFAULT_LAYER_ONLY)
		new_layer = PIPING_LAYER_DEFAULT
	piping_layer = new_layer
	pixel_x = (piping_layer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X
	pixel_y = (piping_layer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y
	layer = initial(layer) + ((piping_layer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_LCHANGE)

/obj/machinery/atmospherics/proc/can_be_node(obj/machinery/atmospherics/target)
	procstart = null
	src.procstart = null
	return connection_check(target, piping_layer)

//Find a connecting /obj/machinery/atmospherics in specified direction
/obj/machinery/atmospherics/proc/findConnecting(direction, prompted_layer)
	procstart = null
	src.procstart = null
	for(var/obj/machinery/atmospherics/target in get_step(src, direction))
		if(target.initialize_directions & get_dir(target,src))
			if(connection_check(target, prompted_layer))
				return target

/obj/machinery/atmospherics/proc/connection_check(obj/machinery/atmospherics/target, given_layer)
	procstart = null
	src.procstart = null
	if(isConnectable(target, given_layer) && target.isConnectable(src, given_layer) && (target.initialize_directions & get_dir(target,src)))
		return TRUE
	return FALSE

/obj/machinery/atmospherics/proc/isConnectable(obj/machinery/atmospherics/target, given_layer)
	procstart = null
	src.procstart = null
	if(isnull(given_layer))
		given_layer = piping_layer
	if((target.piping_layer == given_layer) || (target.pipe_flags & PIPING_ALL_LAYER))
		return TRUE
	return FALSE

/obj/machinery/atmospherics/proc/pipeline_expansion()
	procstart = null
	src.procstart = null
	return nodes

/obj/machinery/atmospherics/proc/SetInitDirections()
	procstart = null
	src.procstart = null
	return

/obj/machinery/atmospherics/proc/GetInitDirections()
	procstart = null
	src.procstart = null
	return initialize_directions

/obj/machinery/atmospherics/proc/returnPipenet()
	procstart = null
	src.procstart = null
	return

/obj/machinery/atmospherics/proc/returnPipenetAir()
	procstart = null
	src.procstart = null
	return

/obj/machinery/atmospherics/proc/setPipenet()
	procstart = null
	src.procstart = null
	return

/obj/machinery/atmospherics/proc/replacePipenet()
	procstart = null
	src.procstart = null
	return

/obj/machinery/atmospherics/proc/disconnect(obj/machinery/atmospherics/reference)
	procstart = null
	src.procstart = null
	if(istype(reference, /obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/P = reference
		P.destroy_network()
	var/I = nodes.Find(reference)
	NODE_I = null
	update_icon()

/obj/machinery/atmospherics/update_icon()
	procstart = null
	src.procstart = null
	return

/obj/machinery/atmospherics/attackby(obj/item/W, mob/user, params)
	procstart = null
	src.procstart = null
	if(istype(W, /obj/item/pipe)) //lets you autodrop
		var/obj/item/pipe/pipe = W
		if(user.dropItemToGround(pipe))
			pipe.setPipingLayer(piping_layer) //align it with us
			return TRUE
	if(istype(W, /obj/item/wrench))
		if(can_unwrench(user))
			var/turf/T = get_turf(src)
			if (level==1 && isturf(T) && T.intact)
				to_chat(user, "<span class='warning'>You must remove the plating first!</span>")
				return TRUE
			var/datum/gas_mixture/int_air = return_air()
			var/datum/gas_mixture/env_air = loc.return_air()
			add_fingerprint(user)

			var/unsafe_wrenching = FALSE
			var/internal_pressure = int_air.return_pressure()-env_air.return_pressure()

			playsound(src, W.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
			if (internal_pressure > 2*ONE_ATMOSPHERE)
				to_chat(user, "<span class='warning'>As you begin unwrenching \the [src] a gush of air blows in your face... maybe you should reconsider?</span>")
				unsafe_wrenching = TRUE //Oh dear oh dear

			if (do_after(user, 20*W.toolspeed, target = src) && !QDELETED(src))
				user.visible_message( \
					"[user] unfastens \the [src].", \
					"<span class='notice'>You unfasten \the [src].</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				investigate_log("was <span class='warning'>REMOVED</span> by [key_name(usr)]", INVESTIGATE_ATMOS)

				//You unwrenched a pipe full of pressure? Let's splat you into the wall, silly.
				if(unsafe_wrenching)
					unsafe_pressure_release(user, internal_pressure)
				deconstruct(TRUE)
	else
		return ..()

/obj/machinery/atmospherics/proc/can_unwrench(mob/user)
	procstart = null
	src.procstart = null
	return can_unwrench

// Throws the user when they unwrench a pipe with a major difference between the internal and environmental pressure.
/obj/machinery/atmospherics/proc/unsafe_pressure_release(mob/user, pressures = null)
	procstart = null
	src.procstart = null
	if(!user)
		return
	if(!pressures)
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		pressures = int_air.return_pressure() - env_air.return_pressure()

	var/fuck_you_dir = get_dir(src, user) // Because fuck you...
	if(!fuck_you_dir)
		fuck_you_dir = pick(GLOB.cardinals)
	var/turf/target = get_edge_target_turf(user, fuck_you_dir)
	var/range = pressures/250
	var/speed = range/5

	user.visible_message("<span class='danger'>[user] is sent flying by pressure!</span>","<span class='userdanger'>The pressure sends you flying!</span>")
	user.throw_at(target, range, speed)

/obj/machinery/atmospherics/deconstruct(disassembled = TRUE)
	procstart = null
	src.procstart = null
	if(!(flags_1 & NODECONSTRUCT_1))
		if(can_unwrench)
			var/obj/item/pipe/stored = new construction_type(loc, null, dir, src)
			stored.setPipingLayer(piping_layer)
			if(!disassembled)
				stored.obj_integrity = stored.max_integrity * 0.5
			transfer_fingerprints_to(stored)
	..()

/obj/machinery/atmospherics/proc/getpipeimage(iconset, iconstate, direction, col=rgb(255,255,255))

	procstart = null
	src.procstart = null
	//Add identifiers for the iconset
	if(iconsetids[iconset] == null)
		iconsetids[iconset] = num2text(iconsetids.len + 1)

	//Generate a unique identifier for this image combination
	var/identifier = iconsetids[iconset] + "_[iconstate]_[direction]_[col]"

	if((!(. = pipeimages[identifier])))
		var/image/pipe_overlay
		pipe_overlay = . = pipeimages[identifier] = image(iconset, iconstate, dir = direction)
		pipe_overlay.color = col

/obj/machinery/atmospherics/proc/icon_addintact(var/obj/machinery/atmospherics/node)
	procstart = null
	src.procstart = null
	var/image/img = getpipeimage('icons/obj/atmospherics/components/binary_devices.dmi', "pipe_intact", get_dir(src,node), node.pipe_color)
	underlays += img
	return img.dir

/obj/machinery/atmospherics/proc/icon_addbroken(var/connected = FALSE)
	procstart = null
	src.procstart = null
	var/unconnected = (~connected) & initialize_directions
	for(var/direction in GLOB.cardinals)
		if(unconnected & direction)
			underlays += getpipeimage('icons/obj/atmospherics/components/binary_devices.dmi', "pipe_exposed", direction)

/obj/machinery/atmospherics/on_construction(obj_color, set_layer)
	procstart = null
	src.procstart = null
	if(can_unwrench)
		add_atom_colour(obj_color, FIXED_COLOUR_PRIORITY)
		pipe_color = obj_color
	setPipingLayer(set_layer)
	var/turf/T = get_turf(src)
	level = T.intact ? 2 : 1
	atmosinit()
	var/list/nodes = pipeline_expansion()
	for(var/obj/machinery/atmospherics/A in nodes)
		A.atmosinit()
		A.addMember(src)
	build_network()

/obj/machinery/atmospherics/Entered(atom/movable/AM)
	procstart = null
	src.procstart = null
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.ventcrawl_layer = piping_layer
	return ..()

/obj/machinery/atmospherics/singularity_pull(S, current_size)
	procstart = null
	src.procstart = null
	if(current_size >= STAGE_FIVE)
		deconstruct(FALSE)
	return ..()

#define VENT_SOUND_DELAY 30

/obj/machinery/atmospherics/relaymove(mob/living/user, direction)
	procstart = null
	src.procstart = null
	if(!(direction & initialize_directions)) //cant go this way.
		return

	if(user in buckled_mobs)// fixes buckle ventcrawl edgecase fuck bug
		return

	var/obj/machinery/atmospherics/target_move = findConnecting(direction, user.ventcrawl_layer)
	if(target_move)
		if(target_move.can_crawl_through())
			if(is_type_in_typecache(target_move, GLOB.ventcrawl_machinery))
				user.forceMove(target_move.loc) //handle entering and so on.
				user.visible_message("<span class='notice'>You hear something squeezing through the ducts...</span>","<span class='notice'>You climb out the ventilation system.")
			else
				var/list/pipenetdiff = returnPipenets() ^ target_move.returnPipenets()
				if(pipenetdiff.len)
					user.update_pipe_vision(target_move)
				user.forceMove(target_move)
				user.client.eye = target_move  //Byond only updates the eye every tick, This smooths out the movement
				if(world.time - user.last_played_vent > VENT_SOUND_DELAY)
					user.last_played_vent = world.time
					playsound(src, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	else
		if((direction & initialize_directions) || is_type_in_typecache(src, GLOB.ventcrawl_machinery) && can_crawl_through()) //if we move in a way the pipe can connect, but doesn't - or we're in a vent
			user.forceMove(loc)
			user.visible_message("<span class='notice'>You hear something squeezing through the ducts...</span>","<span class='notice'>You climb out the ventilation system.")
	user.canmove = 0
	spawn(1)
		user.canmove = 1


/obj/machinery/atmospherics/AltClick(mob/living/L)
	procstart = null
	src.procstart = null
	if(is_type_in_list(src, GLOB.ventcrawl_machinery))
		L.handle_ventcrawl(src)
		return
	..()


/obj/machinery/atmospherics/proc/can_crawl_through()
	procstart = null
	src.procstart = null
	return TRUE

/obj/machinery/atmospherics/proc/returnPipenets()
	procstart = null
	src.procstart = null
	return list()

/obj/machinery/atmospherics/update_remote_sight(mob/user)
	procstart = null
	src.procstart = null
	user.sight |= (SEE_TURFS|BLIND)

//Used for certain children of obj/machinery/atmospherics to not show pipe vision when mob is inside it.
/obj/machinery/atmospherics/proc/can_see_pipes()
	procstart = null
	src.procstart = null
	return TRUE
