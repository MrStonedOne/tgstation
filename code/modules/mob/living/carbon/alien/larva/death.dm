/mob/living/carbon/alien/larva/death(gibbed)
	if(stat == DEAD)
		return

	. = ..()

	update_icons()

/mob/living/carbon/alien/larva/spawn_gibs(with_bodyparts)
	procstart = null
	src.procstart = null
	if(with_bodyparts)
		new /obj/effect/gibspawner/larva(get_turf(src))
	else
		new /obj/effect/gibspawner/larvabodypartless(get_turf(src))

/mob/living/carbon/alien/larva/gib_animation()
	procstart = null
	src.procstart = null
	new /obj/effect/temp_visual/gib_animation(loc, "gibbed-l")

/mob/living/carbon/alien/larva/spawn_dust()
	procstart = null
	src.procstart = null
	new /obj/effect/decal/remains/xeno(loc)

/mob/living/carbon/alien/larva/dust_animation()
	procstart = null
	src.procstart = null
	new /obj/effect/temp_visual/dust_animation(loc, "dust-l")
