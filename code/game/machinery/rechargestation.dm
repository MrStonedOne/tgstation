/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = FALSE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 1000
	req_access = list(ACCESS_ROBOTICS)
	state_open = TRUE
	circuit = /obj/item/circuitboard/machine/cyborgrecharger
	var/recharge_speed
	var/repairs

/obj/machinery/recharge_station/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	update_icon()

/obj/machinery/recharge_station/RefreshParts()
	procstart = null
	src.procstart = null
	recharge_speed = 0
	repairs = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		recharge_speed += C.rating * 100
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		repairs += M.rating - 1
	for(var/obj/item/stock_parts/cell/C in component_parts)
		recharge_speed *= C.maxcharge / 10000

/obj/machinery/recharge_station/process()
	procstart = null
	src.procstart = null
	if(!is_operational())
		return

	if(occupant)
		process_occupant()
	return 1

/obj/machinery/recharge_station/relaymove(mob/user)
	procstart = null
	src.procstart = null
	if(user.stat)
		return
	open_machine()

/obj/machinery/recharge_station/emp_act(severity)
	procstart = null
	src.procstart = null
	if(!(stat & (BROKEN|NOPOWER)))
		if(occupant)
			occupant.emp_act(severity)
		open_machine()
	..()

/obj/machinery/recharge_station/attack_paw(mob/user)
	procstart = null
	src.procstart = null
	return attack_hand(user)

/obj/machinery/recharge_station/attack_ai(mob/user)
	procstart = null
	src.procstart = null
	return attack_hand(user)

/obj/machinery/recharge_station/attackby(obj/item/P, mob/user, params)
	procstart = null
	src.procstart = null
	if(state_open)
		if(default_deconstruction_screwdriver(user, "borgdecon2", "borgcharger0", P))
			return

	if(exchange_parts(user, P))
		return

	if(default_pry_open(P))
		return

	if(default_deconstruction_crowbar(P))
		return
	return ..()

/obj/machinery/recharge_station/attack_hand(mob/user)
	procstart = null
	src.procstart = null
	if(..(user,1,set_machine = 0))
		return

	toggle_open()
	add_fingerprint(user)

/obj/machinery/recharge_station/proc/toggle_open()
	procstart = null
	src.procstart = null
	if(state_open)
		close_machine()
	else
		open_machine()

/obj/machinery/recharge_station/open_machine()
	procstart = null
	src.procstart = null
	..()
	use_power = IDLE_POWER_USE

/obj/machinery/recharge_station/close_machine()
	procstart = null
	src.procstart = null
	if(!panel_open)
		for(var/mob/living/silicon/robot/R in loc)
			R.forceMove(src)
			occupant = R
			use_power = ACTIVE_POWER_USE
			add_fingerprint(R)
			break
		state_open = FALSE
		density = TRUE
		update_icon()

/obj/machinery/recharge_station/update_icon()
	procstart = null
	src.procstart = null
	if(is_operational())
		if(state_open)
			icon_state = "borgcharger0"
		else
			icon_state = (occupant ? "borgcharger1" : "borgcharger2")
	else
		icon_state = (state_open ? "borgcharger-u0" : "borgcharger-u1")

/obj/machinery/recharge_station/power_change()
	procstart = null
	src.procstart = null
	..()
	update_icon()

/obj/machinery/recharge_station/proc/process_occupant()
	procstart = null
	src.procstart = null
	if(occupant)
		var/mob/living/silicon/robot/R = occupant
		restock_modules()
		if(repairs)
			R.heal_bodypart_damage(repairs, repairs - 1)
		if(R.cell)
			R.cell.charge = min(R.cell.charge + recharge_speed, R.cell.maxcharge)

/obj/machinery/recharge_station/proc/restock_modules()
	procstart = null
	src.procstart = null
	if(occupant)
		var/mob/living/silicon/robot/R = occupant
		if(R && R.module)
			var/coeff = recharge_speed * 0.005
			R.module.respawn_consumable(R, coeff)
