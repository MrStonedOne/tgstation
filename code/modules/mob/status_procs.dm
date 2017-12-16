
//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness, ear damage,
// eye damage, eye_blind, eye_blurry, druggy, BLIND disability, and NEARSIGHT disability.

/////////////////////////////////// STUN ////////////////////////////////////

/mob/proc/IsStun() //non-living mobs shouldn't be stunned
	return FALSE

/////////////////////////////////// KNOCKDOWN ////////////////////////////////////

/mob/proc/IsKnockdown() //non-living mobs shouldn't be knocked down
	return FALSE

/////////////////////////////////// UNCONSCIOUS ////////////////////////////////////

/mob/proc/IsUnconscious() //non-living mobs shouldn't be unconscious
	return FALSE

/mob/living/IsUnconscious() //If we're unconscious
	return has_status_effect(STATUS_EFFECT_UNCONSCIOUS)

/mob/living/proc/AmountUnconscious() //How many deciseconds remain in our unconsciousness
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		return U.duration - world.time
	return 0

/mob/living/proc/Unconscious(amount, updating = TRUE, ignore_canunconscious = FALSE) //Can't go below remaining duration
	if((status_flags & CANUNCONSCIOUS) || ignore_canunconscious)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration = max(world.time + amount, U.duration)
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
		return U

/mob/living/proc/SetUnconscious(amount, updating = TRUE, ignore_canunconscious = FALSE) //Sets remaining duration
	if((status_flags & CANUNCONSCIOUS) || ignore_canunconscious)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(amount <= 0)
			if(U)
				qdel(U)
		else if(U)
			U.duration = world.time + amount
		else
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
		return U

/mob/living/proc/AdjustUnconscious(amount, updating = TRUE, ignore_canunconscious = FALSE) //Adds to remaining duration
	if((status_flags & CANUNCONSCIOUS) || ignore_canunconscious)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration += amount
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
		return U

/////////////////////////////////// SLEEPING ////////////////////////////////////

/mob/living/proc/IsSleeping() //If we're asleep
	return has_status_effect(STATUS_EFFECT_SLEEPING)

/mob/living/proc/AmountSleeping() //How many deciseconds remain in our sleep
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Sleeping(amount, updating = TRUE) //Can't go below remaining duration
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		S.duration = max(world.time + amount, S.duration)
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
	return S

/mob/living/proc/SetSleeping(amount, updating = TRUE) //Sets remaining duration
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(amount <= 0)
		if(S)
			qdel(S)
	else if(S)
		S.duration = world.time + amount
	else
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
	return S

/mob/living/proc/AdjustSleeping(amount, updating = TRUE) //Adds to remaining duration
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		S.duration += amount
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
	return S

/////////////////////////////////// RESTING ////////////////////////////////////

/mob/proc/Resting(amount)
	procstart = null
	src.procstart = null
	resting = max(max(resting,amount),0)

/mob/living/Resting(amount)
	procstart = null
	src.procstart = null
	..()
	update_canmove()

/mob/proc/SetResting(amount)
	procstart = null
	src.procstart = null
	resting = max(amount,0)

/mob/living/SetResting(amount)
	procstart = null
	src.procstart = null
	..()
	update_canmove()

/mob/proc/AdjustResting(amount)
	procstart = null
	src.procstart = null
	resting = max(resting + amount,0)

/mob/living/AdjustResting(amount)
	procstart = null
	src.procstart = null
	..()
	update_canmove()

/////////////////////////////////// JITTERINESS ////////////////////////////////////

/mob/proc/Jitter(amount)
	procstart = null
	src.procstart = null
	jitteriness = max(jitteriness,amount,0)

/////////////////////////////////// DIZZINESS ////////////////////////////////////

/mob/proc/Dizzy(amount)
	procstart = null
	src.procstart = null
	dizziness = max(dizziness,amount,0)

/////////////////////////////////// EYE DAMAGE ////////////////////////////////////

/mob/proc/damage_eyes(amount)
	procstart = null
	src.procstart = null
	return

/mob/proc/adjust_eye_damage(amount)
	procstart = null
	src.procstart = null
	return

/mob/proc/set_eye_damage(amount)
	procstart = null
	src.procstart = null
	return

/////////////////////////////////// EYE_BLIND ////////////////////////////////////

/mob/proc/blind_eyes(amount)
	procstart = null
	src.procstart = null
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = max(eye_blind, amount)
		if(!old_eye_blind)
			if(stat == CONSCIOUS || stat == SOFT_CRIT)
				throw_alert("blind", /obj/screen/alert/blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)

/mob/proc/adjust_blindness(amount)
	procstart = null
	src.procstart = null
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind += amount
		if(!old_eye_blind)
			if(stat == CONSCIOUS || stat == SOFT_CRIT)
				throw_alert("blind", /obj/screen/alert/blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else if(eye_blind)
		var/blind_minimum = 0
		if((stat != CONSCIOUS && stat != SOFT_CRIT) || (disabilities & BLIND))
			blind_minimum = 1
		eye_blind = max(eye_blind+amount, blind_minimum)
		if(!eye_blind)
			clear_alert("blind")
			clear_fullscreen("blind")

/mob/proc/set_blindness(amount)
	procstart = null
	src.procstart = null
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = amount
		if(client && !old_eye_blind)
			if(stat == CONSCIOUS || stat == SOFT_CRIT)
				throw_alert("blind", /obj/screen/alert/blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else if(eye_blind)
		var/blind_minimum = 0
		if((stat != CONSCIOUS && stat != SOFT_CRIT) || (disabilities & BLIND))
			blind_minimum = 1
		eye_blind = blind_minimum
		if(!eye_blind)
			clear_alert("blind")
			clear_fullscreen("blind")

/////////////////////////////////// EYE_BLURRY ////////////////////////////////////

/mob/proc/blur_eyes(amount)
	procstart = null
	src.procstart = null
	if(amount>0)
		var/old_eye_blurry = eye_blurry
		eye_blurry = max(amount, eye_blurry)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)

/mob/proc/adjust_blurriness(amount)
	procstart = null
	src.procstart = null
	var/old_eye_blurry = eye_blurry
	eye_blurry = max(eye_blurry+amount, 0)
	if(amount>0)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
	else if(old_eye_blurry && !eye_blurry)
		clear_fullscreen("blurry")

/mob/proc/set_blurriness(amount)
	procstart = null
	src.procstart = null
	var/old_eye_blurry = eye_blurry
	eye_blurry = max(amount, 0)
	if(amount>0)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
	else if(old_eye_blurry)
		clear_fullscreen("blurry")

/////////////////////////////////// DRUGGY ////////////////////////////////////

/mob/proc/adjust_drugginess(amount)
	procstart = null
	src.procstart = null
	return

/mob/proc/set_drugginess(amount)
	procstart = null
	src.procstart = null
	return

/////////////////////////////////// GROSSED OUT ////////////////////////////////////

/mob/proc/adjust_disgust(amount)
	procstart = null
	src.procstart = null
	return

/mob/proc/set_disgust(amount)
	procstart = null
	src.procstart = null
	return

/////////////////////////////////// BLIND DISABILITY ////////////////////////////////////

/mob/proc/cure_blind() //when we want to cure the BLIND disability only.
	return

/mob/proc/become_blind()
	procstart = null
	src.procstart = null
	return

/////////////////////////////////// NEARSIGHT DISABILITY ////////////////////////////////////

/mob/proc/cure_nearsighted()
	procstart = null
	src.procstart = null
	return

/mob/proc/become_nearsighted()
	procstart = null
	src.procstart = null
	return


//////////////////////////////// HUSK DISABILITY ///////////////////////////:

/mob/proc/cure_husk()
	procstart = null
	src.procstart = null
	return

/mob/proc/become_husk()
	procstart = null
	src.procstart = null
	return







