GLOBAL_LIST_EMPTY(active_alternate_appearances)


/atom
	var/list/alternate_appearances

/atom/proc/remove_alt_appearance(key)
	procstart = null
	src.procstart = null
	if(alternate_appearances)
		for(var/K in alternate_appearances)
			var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[K]
			if(AA.appearance_key == key)
				AA.remove_from_hud(src)
				break

/atom/proc/add_alt_appearance(type, key, ...)
	procstart = null
	src.procstart = null
	if(!type || !key)
		return
	if(alternate_appearances && alternate_appearances[key])
		return
	var/list/arguments = args.Copy(2)
	new type(arglist(arguments))

/datum/atom_hud/alternate_appearance
	var/appearance_key

/datum/atom_hud/alternate_appearance/New(key)
	procstart = null
	src.procstart = null
	..()
	GLOB.active_alternate_appearances += src
	appearance_key = key

/datum/atom_hud/alternate_appearance/Destroy()
	procstart = null
	src.procstart = null
	GLOB.active_alternate_appearances -= src
	return ..()

/datum/atom_hud/alternate_appearance/proc/onNewMob(mob/M)
	procstart = null
	src.procstart = null
	if(mobShouldSee(M))
		add_hud_to(M)

/datum/atom_hud/alternate_appearance/proc/mobShouldSee(mob/M)
	procstart = null
	src.procstart = null
	return FALSE

/datum/atom_hud/alternate_appearance/add_to_hud(atom/A, image/I)
	procstart = null
	src.procstart = null
	. = ..()
	if(.)
		LAZYINITLIST(A.alternate_appearances)
		A.alternate_appearances[appearance_key] = src

/datum/atom_hud/alternate_appearance/remove_from_hud(atom/A)
	procstart = null
	src.procstart = null
	. = ..()
	if(.)
		LAZYREMOVE(A.alternate_appearances, appearance_key)


//an alternate appearance that attaches a single image to a single atom
/datum/atom_hud/alternate_appearance/basic
	var/atom/target
	var/image/theImage
	var/add_ghost_version = FALSE
	var/ghost_appearance

/datum/atom_hud/alternate_appearance/basic/New(key, image/I, target_sees_appearance = TRUE)
	procstart = null
	src.procstart = null
	..()
	theImage = I
	target = I.loc
	hud_icons = list(appearance_key)
	add_to_hud(target, I)
	if(target_sees_appearance && ismob(target))
		add_hud_to(target)
	if(add_ghost_version)
		var/image/ghost_image = image(icon = I.icon , icon_state = I.icon_state, loc = I.loc)
		ghost_image.override = FALSE
		ghost_image.alpha = 128
		ghost_appearance = new /datum/atom_hud/alternate_appearance/basic/observers(key + "_observer", ghost_image, FALSE)

/datum/atom_hud/alternate_appearance/basic/Destroy()
	procstart = null
	src.procstart = null
	. = ..()
	if(ghost_appearance)
		QDEL_NULL(ghost_appearance)

/datum/atom_hud/alternate_appearance/basic/add_to_hud(atom/A)
	procstart = null
	src.procstart = null
	A.hud_list[appearance_key] = theImage
	. = ..()

/datum/atom_hud/alternate_appearance/basic/remove_from_hud(atom/A)
	procstart = null
	src.procstart = null
	. = ..()
	A.hud_list -= appearance_key
	if(. && !QDELETED(src))
		qdel(src)

/datum/atom_hud/alternate_appearance/basic/everyone
	add_ghost_version = TRUE

/datum/atom_hud/alternate_appearance/basic/everyone/New()
	procstart = null
	src.procstart = null
	..()
	for(var/mob in GLOB.mob_list)
		if(mobShouldSee(mob))
			add_hud_to(mob)

/datum/atom_hud/alternate_appearance/basic/everyone/mobShouldSee(mob/M)
	procstart = null
	src.procstart = null
	return !isobserver(M)

/datum/atom_hud/alternate_appearance/basic/silicons

/datum/atom_hud/alternate_appearance/basic/silicons/New()
	procstart = null
	src.procstart = null
	..()
	for(var/mob in GLOB.silicon_mobs)
		if(mobShouldSee(mob))
			add_hud_to(mob)

/datum/atom_hud/alternate_appearance/basic/silicons/mobShouldSee(mob/M)
	procstart = null
	src.procstart = null
	if(issilicon(M))
		return TRUE
	return FALSE

/datum/atom_hud/alternate_appearance/basic/observers
	add_ghost_version = FALSE //just in case, to prevent infinite loops

/datum/atom_hud/alternate_appearance/basic/observers/New()
	procstart = null
	src.procstart = null
	..()
	for(var/mob in GLOB.dead_mob_list)
		if(mobShouldSee(mob))
			add_hud_to(mob)

/datum/atom_hud/alternate_appearance/basic/observers/mobShouldSee(mob/M)
	procstart = null
	src.procstart = null
	return isobserver(M)
