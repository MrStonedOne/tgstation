/obj/item/organ/body_egg
	name = "body egg"
	desc = "All slimy and yuck."
	icon_state = "innards"
	zone = "chest"
	slot = "parasite_egg"

/obj/item/organ/body_egg/on_find(mob/living/finder)
	procstart = null
	src.procstart = null
	..()
	to_chat(finder, "<span class='warning'>You found an unknown alien organism in [owner]'s [zone]!</span>")

/obj/item/organ/body_egg/New(loc)
	procstart = null
	src.procstart = null
	if(iscarbon(loc))
		src.Insert(loc)
	return ..()

/obj/item/organ/body_egg/Insert(var/mob/living/carbon/M, special = 0)
	procstart = null
	src.procstart = null
	..()
	owner.status_flags |= XENO_HOST
	START_PROCESSING(SSobj, src)
	owner.med_hud_set_status()
	INVOKE_ASYNC(src, .proc/AddInfectionImages, owner)

/obj/item/organ/body_egg/Remove(var/mob/living/carbon/M, special = 0)
	procstart = null
	src.procstart = null
	STOP_PROCESSING(SSobj, src)
	if(owner)
		owner.status_flags &= ~(XENO_HOST)
		owner.med_hud_set_status()
		INVOKE_ASYNC(src, .proc/RemoveInfectionImages, owner)
	..()

/obj/item/organ/body_egg/process()
	procstart = null
	src.procstart = null
	if(!owner)
		return
	if(!(src in owner.internal_organs))
		Remove(owner)
		return
	egg_process()

/obj/item/organ/body_egg/proc/egg_process()
	procstart = null
	src.procstart = null
	return

/obj/item/organ/body_egg/proc/RefreshInfectionImage()
	procstart = null
	src.procstart = null
	RemoveInfectionImages()
	AddInfectionImages()

/obj/item/organ/body_egg/proc/AddInfectionImages()
	procstart = null
	src.procstart = null
	return

/obj/item/organ/body_egg/proc/RemoveInfectionImages()
	procstart = null
	src.procstart = null
	return
