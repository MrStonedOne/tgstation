
/datum/hud/blobbernaut/New(mob/owner)
	procstart = null
	src.procstart = null
	..()

	blobpwrdisplay = new /obj/screen/healths/blob/naut/core()
	infodisplay += blobpwrdisplay

	healths = new /obj/screen/healths/blob/naut()
	infodisplay += healths

/mob/living/simple_animal/hostile/blob/blobbernaut/create_mob_hud()
	procstart = null
	src.procstart = null
	if(client && !hud_used)
		hud_used = new /datum/hud/blobbernaut(src)
