/obj/mecha/medical/odysseus
	desc = "These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	name = "\improper Odysseus"
	icon_state = "odysseus"
	step_in = 3
	max_temperature = 15000
	max_integrity = 120
	wreckage = /obj/structure/mecha_wreckage/odysseus
	internal_damage_threshold = 35
	deflect_chance = 15
	step_energy_drain = 6

/obj/mecha/medical/odysseus/moved_inside(mob/living/carbon/human/H)
	procstart = null
	src.procstart = null
	. = ..()
	if(.)
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		hud.add_hud_to(H)

/obj/mecha/medical/odysseus/go_out()
	procstart = null
	src.procstart = null
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		hud.remove_hud_from(H)
	..()
