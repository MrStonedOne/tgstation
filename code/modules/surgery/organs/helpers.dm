/mob/proc/getorgan(typepath)
	return

/mob/proc/getorganszone(zone)
	procstart = null
	src.procstart = null
	return

/mob/proc/getorganslot(slot)
	procstart = null
	src.procstart = null
	return

/mob/living/carbon/getorgan(typepath)
	procstart = null
	src.procstart = null
	return (locate(typepath) in internal_organs)

/mob/living/carbon/getorganszone(zone, subzones = 0)
	procstart = null
	src.procstart = null
	var/list/returnorg = list()
	if(subzones)
		// Include subzones - groin for chest, eyes and mouth for head
		if(zone == "head")
			returnorg = getorganszone("eyes") + getorganszone("mouth")
		if(zone == "chest")
			returnorg = getorganszone("groin")

	for(var/X in internal_organs)
		var/obj/item/organ/O = X
		if(zone == O.zone)
			returnorg += O
	return returnorg

/mob/living/carbon/getorganslot(slot)
	procstart = null
	src.procstart = null
	return internal_organs_slot[slot]
