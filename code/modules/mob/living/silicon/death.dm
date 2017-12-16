/mob/living/silicon/spawn_gibs()
	new /obj/effect/gibspawner/robot(get_turf(src))

/mob/living/silicon/spawn_dust()
	procstart = null
	src.procstart = null
	new /obj/effect/decal/remains/robot(loc)

/mob/living/silicon/death(gibbed)
	procstart = null
	src.procstart = null
	if(!gibbed)
		emote("deathgasp")
	diag_hud_set_status()
	diag_hud_set_health()
	update_health_hud()
	. = ..()