//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/hooded
	actions_types = list(/datum/action/item_action/toggle_hood)
	var/obj/item/clothing/head/hooded/hood
	var/hoodtype = /obj/item/clothing/head/hooded/winterhood //so the chaplain hoodie or other hoodies can override this
	hooded = 1

/obj/item/clothing/suit/hooded/New()
	procstart = null
	src.procstart = null
	MakeHood()
	..()

/obj/item/clothing/suit/hooded/Destroy()
	procstart = null
	src.procstart = null
	. = ..()
	qdel(hood)
	hood = null

/obj/item/clothing/suit/hooded/proc/MakeHood()
	procstart = null
	src.procstart = null
	if(!hood)
		var/obj/item/clothing/head/hooded/W = new hoodtype(src)
		W.suit = src
		hood = W

/obj/item/clothing/suit/hooded/ui_action_click()
	procstart = null
	src.procstart = null
	ToggleHood()

/obj/item/clothing/suit/hooded/item_action_slot_check(slot, mob/user)
	procstart = null
	src.procstart = null
	if(slot == slot_wear_suit)
		return 1

/obj/item/clothing/suit/hooded/equipped(mob/user, slot)
	procstart = null
	src.procstart = null
	if(slot != slot_wear_suit)
		RemoveHood()
	..()

/obj/item/clothing/suit/hooded/proc/RemoveHood()
	procstart = null
	src.procstart = null
	src.icon_state = "[initial(icon_state)]"
	suittoggled = FALSE
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.transferItemToLoc(hood, src, TRUE)
		H.update_inv_wear_suit()
	else
		hood.forceMove(src)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/suit/hooded/dropped()
	procstart = null
	src.procstart = null
	..()
	RemoveHood()

/obj/item/clothing/suit/hooded/proc/ToggleHood()
	procstart = null
	src.procstart = null
	if(!suittoggled)
		if(ishuman(src.loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else if(H.equip_to_slot_if_possible(hood,slot_head,0,0,1))
				suittoggled = TRUE
				src.icon_state = "[initial(icon_state)]_t"
				H.update_inv_wear_suit()
				for(var/X in actions)
					var/datum/action/A = X
					A.UpdateButtonIcon()
	else
		RemoveHood()

/obj/item/clothing/head/hooded
	var/obj/item/clothing/suit/hooded/suit

/obj/item/clothing/head/hooded/Destroy()
	procstart = null
	src.procstart = null
	suit = null
	return ..()

/obj/item/clothing/head/hooded/dropped()
	procstart = null
	src.procstart = null
	..()
	if(suit)
		suit.RemoveHood()

/obj/item/clothing/head/hooded/equipped(mob/user, slot)
	procstart = null
	src.procstart = null
	..()
	if(slot != slot_head)
		if(suit)
			suit.RemoveHood()
		else
			qdel(src)

//Toggle exosuits for different aesthetic styles (hoodies, suit jacket buttons, etc)

/obj/item/clothing/suit/toggle/AltClick(mob/user)
	procstart = null
	src.procstart = null
	..()
	if(!user.canUseTopic(src, be_close=TRUE))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	else
		suit_toggle(user)

/obj/item/clothing/suit/toggle/ui_action_click()
	procstart = null
	src.procstart = null
	suit_toggle()

/obj/item/clothing/suit/toggle/proc/suit_toggle()
	procstart = null
	src.procstart = null
	set src in usr

	if(!can_use(usr))
		return 0

	to_chat(usr, "<span class='notice'>You toggle [src]'s [togglename].</span>")
	if(src.suittoggled)
		src.icon_state = "[initial(icon_state)]"
		src.suittoggled = FALSE
	else if(!src.suittoggled)
		src.icon_state = "[initial(icon_state)]_t"
		src.suittoggled = TRUE
	usr.update_inv_wear_suit()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/suit/toggle/examine(mob/user)
	procstart = null
	src.procstart = null
	..()
	to_chat(user, "Alt-click on [src] to toggle the [togglename].")

//Hardsuit toggle code
/obj/item/clothing/suit/space/hardsuit/New()
	procstart = null
	src.procstart = null
	MakeHelmet()
	..()

/obj/item/clothing/suit/space/hardsuit/Destroy()
	procstart = null
	src.procstart = null
	if(helmet)
		helmet.suit = null
		qdel(helmet)
	qdel(jetpack)
	return ..()

/obj/item/clothing/head/helmet/space/hardsuit/Destroy()
	procstart = null
	src.procstart = null
	if(suit)
		suit.helmet = null
	return ..()

/obj/item/clothing/suit/space/hardsuit/proc/MakeHelmet()
	procstart = null
	src.procstart = null
	if(!helmettype)
		return
	if(!helmet)
		var/obj/item/clothing/head/helmet/space/hardsuit/W = new helmettype(src)
		W.suit = src
		helmet = W

/obj/item/clothing/suit/space/hardsuit/ui_action_click()
	procstart = null
	src.procstart = null
	..()
	ToggleHelmet()

/obj/item/clothing/suit/space/hardsuit/equipped(mob/user, slot)
	procstart = null
	src.procstart = null
	if(!helmettype)
		return
	if(slot != slot_wear_suit)
		RemoveHelmet()
	..()

/obj/item/clothing/suit/space/hardsuit/proc/RemoveHelmet()
	procstart = null
	src.procstart = null
	if(!helmet)
		return
	suittoggled = FALSE
	if(ishuman(helmet.loc))
		var/mob/living/carbon/H = helmet.loc
		if(helmet.on)
			helmet.attack_self(H)
		H.transferItemToLoc(helmet, src, TRUE)
		H.update_inv_wear_suit()
		to_chat(H, "<span class='notice'>The helmet on the hardsuit disengages.</span>")
		playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
	else
		helmet.forceMove(src)

/obj/item/clothing/suit/space/hardsuit/dropped()
	procstart = null
	src.procstart = null
	..()
	RemoveHelmet()

/obj/item/clothing/suit/space/hardsuit/proc/ToggleHelmet()
	procstart = null
	src.procstart = null
	var/mob/living/carbon/human/H = src.loc
	if(!helmettype)
		return
	if(!helmet)
		return
	if(!suittoggled)
		if(ishuman(src.loc))
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to engage the helmet!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else if(H.equip_to_slot_if_possible(helmet,slot_head,0,0,1))
				to_chat(H, "<span class='notice'>You engage the helmet on the hardsuit.</span>")
				suittoggled = TRUE
				H.update_inv_wear_suit()
				playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
	else
		RemoveHelmet()
