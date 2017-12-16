/obj/item/gun/magic
	name = "staff of nothing"
	desc = "This staff is boring to watch because even though it came first you've seen everything it can do in other staves for years."
	icon = 'icons/obj/guns/magic.dmi'
	icon_state = "staffofnothing"
	item_state = "staff"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	fire_sound = 'sound/weapons/emitter.ogg'
	flags_1 =  CONDUCT_1
	w_class = WEIGHT_CLASS_HUGE
	var/max_charges = 6
	var/charges = 0
	var/recharge_rate = 4
	var/charge_tick = 0
	var/can_charge = 1
	var/ammo_type
	var/no_den_usage
	clumsy_check = 0
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Has no trigger at all, uses magic instead
	pin = /obj/item/device/firing_pin/magic

	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi' //not really a gun and some toys use these inhands
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'

/obj/item/gun/magic/afterattack(atom/target, mob/living/user, flag)
	procstart = null
	src.procstart = null
	if(no_den_usage)
		var/area/A = get_area(user)
		if(istype(A, /area/wizard_station))
			to_chat(user, "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to use [src].</span>")
			return
		else
			no_den_usage = 0
	..()

/obj/item/gun/magic/can_shoot()
	procstart = null
	src.procstart = null
	return charges

/obj/item/gun/magic/recharge_newshot()
	procstart = null
	src.procstart = null
	if (charges && chambered && !chambered.BB)
		chambered.newshot()

/obj/item/gun/magic/process_chamber()
	procstart = null
	src.procstart = null
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		charges--//... drain a charge
		recharge_newshot()

/obj/item/gun/magic/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	charges = max_charges
	chambered = new ammo_type(src)
	if(can_charge)
		START_PROCESSING(SSobj, src)


/obj/item/gun/magic/Destroy()
	procstart = null
	src.procstart = null
	if(can_charge)
		STOP_PROCESSING(SSobj, src)
	return ..()


/obj/item/gun/magic/process()
	procstart = null
	src.procstart = null
	charge_tick++
	if(charge_tick < recharge_rate || charges >= max_charges)
		return 0
	charge_tick = 0
	charges++
	if(charges == 1)
		recharge_newshot()
	return 1

/obj/item/gun/magic/update_icon()
	procstart = null
	src.procstart = null
	return

/obj/item/gun/magic/shoot_with_empty_chamber(mob/living/user as mob|obj)
	procstart = null
	src.procstart = null
	to_chat(user, "<span class='warning'>The [name] whizzles quietly.</span>")

/obj/item/gun/magic/suicide_act(mob/user)
	procstart = null
	src.procstart = null
	user.visible_message("<span class='suicide'>[user] is twisting [src] above [user.p_their()] head, releasing a magical blast! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, fire_sound, 50, 1, -1)
	return (FIRELOSS)

/obj/item/gun/magic/vv_edit_var(var_name, var_value)
	procstart = null
	src.procstart = null
	. = ..()
	switch (var_name)
		if ("charges")
			recharge_newshot()
