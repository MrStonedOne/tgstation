/obj/mecha/combat
	force = 30
	internal_damage_threshold = 50
	armor = list(melee = 30, bullet = 30, laser = 15, energy = 20, bomb = 20, bio = 0, rad = 0, fire = 100, acid = 100)

/obj/mecha/combat/moved_inside(mob/living/carbon/human/H)
	procstart = null
	src.procstart = null
	if(..())
		if(H.client && H.client.mouse_pointer_icon == initial(H.client.mouse_pointer_icon))
			H.client.mouse_pointer_icon = 'icons/mecha/mecha_mouse.dmi'
		return 1
	else
		return 0

/obj/mecha/combat/mmi_moved_inside(obj/item/device/mmi/mmi_as_oc,mob/user)
	procstart = null
	src.procstart = null
	if(..())
		if(occupant.client && occupant.client.mouse_pointer_icon == initial(occupant.client.mouse_pointer_icon))
			occupant.client.mouse_pointer_icon = 'icons/mecha/mecha_mouse.dmi'
		return 1
	else
		return 0


/obj/mecha/combat/go_out()
	procstart = null
	src.procstart = null
	if(occupant && occupant.client && occupant.client.mouse_pointer_icon == 'icons/mecha/mecha_mouse.dmi')
		occupant.client.mouse_pointer_icon = initial(occupant.client.mouse_pointer_icon)
	..()


