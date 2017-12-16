
/mob/living/carbon/human/Stun(amount, updating = 1, ignore_canstun = 0)
	procstart = null
	src.procstart = null
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Knockdown(amount, updating = 1, ignore_canknockdown = 0)
	procstart = null
	src.procstart = null
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Unconscious(amount, updating = 1, ignore_canunconscious = 0)
	procstart = null
	src.procstart = null
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/cure_husk()
	procstart = null
	src.procstart = null
	. = ..()
	if(.)
		update_hair()

/mob/living/carbon/human/become_husk()
	procstart = null
	src.procstart = null
	if(istype(dna.species, /datum/species/skeleton)) //skeletons shouldn't be husks.
		cure_husk()
		return
	. = ..()
	if(.)
		update_hair()

/mob/living/carbon/human/set_drugginess(amount)
	procstart = null
	src.procstart = null
	..()
	if(!amount)
		remove_language(/datum/language/beachbum)

/mob/living/carbon/human/adjust_drugginess(amount)
	procstart = null
	src.procstart = null
	..()
	if(!dna.check_mutation(STONER))
		if(druggy)
			grant_language(/datum/language/beachbum)
		else
			remove_language(/datum/language/beachbum)
