//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness
// eye damage, eye_blind, eye_blurry, druggy, BLIND disability, and NEARSIGHT disability.

/////////////////////////////////// EYE_BLIND ////////////////////////////////////

/mob/living/brain/blind_eyes() // no eyes to damage or heal
	return

/mob/living/brain/adjust_blindness()
	procstart = null
	src.procstart = null
	return

/mob/living/brain/set_blindness()
	procstart = null
	src.procstart = null
	return

/////////////////////////////////// EYE_BLURRY ////////////////////////////////////

/mob/living/brain/blur_eyes()
	procstart = null
	src.procstart = null
	return

/mob/living/brain/adjust_blurriness()
	procstart = null
	src.procstart = null
	return

/mob/living/brain/set_blurriness()
	procstart = null
	src.procstart = null
	return