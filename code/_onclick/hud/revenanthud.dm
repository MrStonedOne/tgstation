
/datum/hud/revenant/New(mob/owner)
	procstart = null
	src.procstart = null
	..()

	healths = new /obj/screen/healths/revenant()
	infodisplay += healths

/mob/living/simple_animal/revenant/create_mob_hud()
	procstart = null
	src.procstart = null
	if(client && !hud_used)
		hud_used = new /datum/hud/revenant(src)
