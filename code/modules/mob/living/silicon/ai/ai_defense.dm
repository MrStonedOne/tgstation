
/mob/living/silicon/ai/attacked_by(obj/item/I, mob/living/user, def_zone)
	procstart = null
	src.procstart = null
	if(I.force && I.damtype != STAMINA && stat != DEAD) //only sparks if real damage is dealt.
		spark_system.start()
	return ..()


/mob/living/silicon/ai/attack_alien(mob/living/carbon/alien/humanoid/M)
	procstart = null
	src.procstart = null
	if(!SSticker.HasRoundStarted())
		to_chat(M, "You cannot attack people before the game has started.")
		return
	..()

/mob/living/silicon/ai/attack_slime(mob/living/simple_animal/slime/user)
	procstart = null
	src.procstart = null
	return //immune to slimes

/mob/living/silicon/ai/blob_act(obj/structure/blob/B)
	procstart = null
	src.procstart = null
	if (stat != DEAD)
		adjustBruteLoss(60)
		updatehealth()
		return 1
	return 0

/mob/living/silicon/ai/emp_act(severity)
	procstart = null
	src.procstart = null
	disconnect_shell()
	if (prob(30))
		switch(pick(1,2))
			if(1)
				view_core()
			if(2)
				SSshuttle.requestEvac(src,"ALERT: Energy surge detected in AI core! Station integrity may be compromised! Initiati--%m091#ar-BZZT")
	..()

/mob/living/silicon/ai/ex_act(severity, target)
	procstart = null
	src.procstart = null
	switch(severity)
		if(1)
			gib()
		if(2)
			if (stat != DEAD)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3)
			if (stat != DEAD)
				adjustBruteLoss(30)



/mob/living/silicon/ai/bullet_act(obj/item/projectile/Proj)
	procstart = null
	src.procstart = null
	..(Proj)
	updatehealth()
	return 2

/mob/living/silicon/ai/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0)
	procstart = null
	src.procstart = null
	return // no eyes, no flashing
