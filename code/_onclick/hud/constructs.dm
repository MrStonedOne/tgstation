
/datum/hud/constructs
	ui_style_icon = 'icons/mob/screen_construct.dmi'

/datum/hud/constructs/New(mob/owner)
	procstart = null
	src.procstart = null
	..()
	pull_icon = new /obj/screen/pull()
	pull_icon.icon = 'icons/mob/screen_construct.dmi'
	pull_icon.update_icon(mymob)
	pull_icon.screen_loc = ui_construct_pull
	static_inventory += pull_icon

	healths = new /obj/screen/healths/construct()
	infodisplay += healths

/mob/living/simple_animal/hostile/construct/create_mob_hud()
	procstart = null
	src.procstart = null
	if(client && !hud_used)
		hud_used = new /datum/hud/constructs(src)
