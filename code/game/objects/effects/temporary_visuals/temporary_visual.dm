//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE
	var/timerid

/obj/effect/temp_visual/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	if(randomdir)
		setDir(pick(GLOB.cardinals))

	timerid = QDEL_IN(src, duration)

/obj/effect/temp_visual/Destroy()
	procstart = null
	src.procstart = null
	. = ..()
	deltimer(timerid)

/obj/effect/temp_visual/singularity_act()
	procstart = null
	src.procstart = null
	return

/obj/effect/temp_visual/singularity_pull()
	procstart = null
	src.procstart = null
	return

/obj/effect/temp_visual/ex_act()
	procstart = null
	src.procstart = null
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	procstart = null
	src.procstart = null
	if(set_dir)
		setDir(set_dir)
	. = ..()


