/datum/species/gehennite
	name = "Gehennite"
	burnmod = 1.2
	heatmod = 1.2
	id = "gehennite"
	no_equip = list(SLOT_GLASSES, SLOT_HEAD)
	inherent_traits = list(TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTLOWPRESSURE)
	species_traits = list(DIGITIGRADE, NOEYESPRITES)
	mutantears = /obj/item/organ/ears/gehennite
	var/datum/component/hand_offset
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

/datum/species/gehennite/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	H.become_blind(ROUNDSTART_TRAIT)
	H.overlay_fullscreen("total", /obj/screen/fullscreen/color_vision/black)

/datum/species/gehennite/on_species_loss(mob/living/carbon/human/H)
	.=..()
	H.clear_fullscreen("total")

/datum/action/innate/echo
	name = "Echolocate"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "meson"

/datum/action/innate/echo/Activate()
	SEND_SIGNAL(owner, COMSIG_ECHOLOCATION_PING)

