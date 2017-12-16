
/mob/living/brain/Life()
	procstart = null
	src.procstart = null
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (notransform)
		return
	if(!loc)
		return
	. = ..()
	handle_emp_damage()

/mob/living/brain/update_stat()
	procstart = null
	src.procstart = null
	if(status_flags & GODMODE)
		return
	if(health <= HEALTH_THRESHOLD_DEAD)
		if(stat != DEAD)
			death()
		var/obj/item/organ/brain/BR
		if(container && container.brain)
			BR = container.brain
		else if(istype(loc, /obj/item/organ/brain))
			BR = loc
		if(BR)
			BR.damaged_brain = 1 //beaten to a pulp

/mob/living/brain/proc/handle_emp_damage()
	procstart = null
	src.procstart = null
	if(emp_damage)
		if(stat == DEAD)
			emp_damage = 0
		else
			emp_damage = max(emp_damage-1, 0)

/mob/living/brain/handle_status_effects()
	procstart = null
	src.procstart = null
	return

/mob/living/brain/handle_disabilities()
	procstart = null
	src.procstart = null
	return



