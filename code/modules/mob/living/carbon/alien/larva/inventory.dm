//can't unequip since it can't equip anything
/mob/living/carbon/alien/larva/doUnEquip(obj/item/W)
	procstart = null
	src.procstart = null
	return