
/mob/living/carbon/alien/getToxLoss()
	procstart = null
	src.procstart = null
	return 0

/mob/living/carbon/alien/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE) //alien immune to tox damage
	return FALSE

//aliens are immune to stamina damage.
/mob/living/carbon/alien/adjustStaminaLoss(amount, updating_stamina = 1)
	procstart = null
	src.procstart = null
	return

/mob/living/carbon/alien/setStaminaLoss(amount, updating_stamina = 1)
	procstart = null
	src.procstart = null
	return