
/mob/living/silicon/robot/gib_animation()
	procstart = null
	src.procstart = null
	new /obj/effect/temp_visual/gib_animation(loc, "gibbed-r")

/mob/living/silicon/robot/dust()
	procstart = null
	src.procstart = null
	if(mmi)
		qdel(mmi)
	..()

/mob/living/silicon/robot/spawn_dust()
	procstart = null
	src.procstart = null
	new /obj/effect/decal/remains/robot(loc)

/mob/living/silicon/robot/dust_animation()
	procstart = null
	src.procstart = null
	new /obj/effect/temp_visual/dust_animation(loc, "dust-r")

/mob/living/silicon/robot/death(gibbed)
	procstart = null
	src.procstart = null
	if(stat == DEAD)
		return

	. = ..()

	locked = FALSE //unlock cover

	update_canmove()
	if(!QDELETED(builtInCamera) && builtInCamera.status)
		builtInCamera.toggle_cam(src,0)
	update_headlamp(1) //So borg lights are disabled when killed.

	uneq_all() // particularly to ensure sight modes are cleared

	update_icons()

	unbuckle_all_mobs(TRUE)

	SSblackbox.ReportDeath(src)
