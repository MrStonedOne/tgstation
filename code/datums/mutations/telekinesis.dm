//Telekinesis lets you interact with objects from range, and gives you a light blue halo around your head.
/datum/mutation/human/telekinesis
	name = "Telekinesis"
	quality = POSITIVE
	get_chance = 20
	lowest_value = 256 * 12
	text_gain_indication = "<span class='notice'>You feel smarter!</span>"
	limb_req = "head"

/datum/mutation/human/telekinesis/New()
	procstart = null
	src.procstart = null
	..()
	visual_indicators |= mutable_appearance('icons/effects/genetics.dmi', "telekinesishead", -MUTATIONS_LAYER)

/datum/mutation/human/telekinesis/get_visual_indicator(mob/living/carbon/human/owner)
	procstart = null
	src.procstart = null
	return visual_indicators[1]

/datum/mutation/human/telekinesis/on_ranged_attack(mob/living/carbon/human/owner, atom/target)
	procstart = null
	src.procstart = null
	target.attack_tk(owner)
