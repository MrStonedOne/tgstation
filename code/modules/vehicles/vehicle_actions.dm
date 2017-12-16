//VEHICLE DEFAULT HANDLING
/obj/vehicle/proc/generate_actions()
	procstart = null
	src.procstart = null
	return

/obj/vehicle/proc/generate_action_type(actiontype)
	procstart = null
	src.procstart = null
	var/datum/action/vehicle/A = new actiontype
	if(!istype(A))
		return
	A.vehicle_target = src
	return A

/obj/vehicle/proc/initialize_passenger_action_type(actiontype)
	procstart = null
	src.procstart = null
	autogrant_actions_passenger += actiontype
	for(var/i in occupants)
		grant_passenger_actions(i)	//refresh

/obj/vehicle/proc/initialize_controller_action_type(actiontype, control_flag)
	procstart = null
	src.procstart = null
	LAZYINITLIST(autogrant_actions_controller["[control_flag]"])
	autogrant_actions_controller["[control_flag]"] += actiontype
	for(var/i in occupants)
		grant_controller_actions(i)	//refresh

/obj/vehicle/proc/grant_action_type_to_mob(actiontype, mob/m)
	procstart = null
	src.procstart = null
	if(!occupants[m] || !actiontype)
		return FALSE
	LAZYINITLIST(occupant_actions[m])
	if(occupant_actions[m][actiontype])
		return TRUE
	var/datum/action/action = generate_action_type(actiontype)
	action.Grant(m)
	occupant_actions[m][action.type] = action
	return TRUE

/obj/vehicle/proc/remove_action_type_from_mob(actiontype, mob/m)
	procstart = null
	src.procstart = null
	if(!occupants[m] || !actiontype)
		return FALSE
	LAZYINITLIST(occupant_actions[m])
	if(occupant_actions[m][actiontype])
		var/datum/action/action = occupant_actions[m][actiontype]
		action.Remove(m)
		occupant_actions[m] -= actiontype
	return TRUE

/obj/vehicle/proc/grant_passenger_actions(mob/M)
	procstart = null
	src.procstart = null
	for(var/v in autogrant_actions_passenger)
		grant_action_type_to_mob(v, M)

/obj/vehicle/proc/remove_passenger_actions(mob/M)
	procstart = null
	src.procstart = null
	for(var/v in autogrant_actions_passenger)
		remove_action_type_from_mob(v, M)

/obj/vehicle/proc/grant_controller_actions(mob/M)
	procstart = null
	src.procstart = null
	if(!istype(M) || !occupants[M])
		return FALSE
	for(var/i in GLOB.bitflags)
		if(occupants[M] & i)
			grant_controller_actions_by_flag(M, i)
	return TRUE

/obj/vehicle/proc/remove_controller_actions(mob/M)
	procstart = null
	src.procstart = null
	if(!istype(M) || !occupants[M])
		return FALSE
	for(var/i in GLOB.bitflags)
		remove_controller_actions_by_flag(M, i)
	return TRUE

/obj/vehicle/proc/grant_controller_actions_by_flag(mob/M, flag)
	procstart = null
	src.procstart = null
	if(!istype(M) || !autogrant_actions_controller["[flag]"])
		return FALSE
	for(var/v in autogrant_actions_controller["[flag]"])
		grant_action_type_to_mob(v, M)
	return TRUE

/obj/vehicle/proc/remove_controller_actions_by_flag(mob/M, flag)
	procstart = null
	src.procstart = null
	if(!istype(M) || autogrant_actions_controller["[flag]"])
		return FALSE
	for(var/v in autogrant_actions_controller["[flag]"])
		remove_action_type_from_mob(v, M)
	return TRUE

/obj/vehicle/proc/cleanup_actions_for_mob(mob/M)
	procstart = null
	src.procstart = null
	if(!istype(M))
		return FALSE
	LAZYINITLIST(occupant_actions[M])
	for(var/path in occupant_actions[M])
		stack_trace("Leftover action type [path] in vehicle type [type] for mob type [M.type] - THIS SHOULD NOT BE HAPPENING!")
		var/datum/action/action = occupant_actions[M]
		action.Remove(M)
	occupant_actions -= M
	return TRUE

//ACTION DATUMS

/datum/action/vehicle
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUN | AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_vehicle.dmi'
	button_icon_state = "vehicle_eject"
	var/obj/vehicle/vehicle_target

/datum/action/vehicle/sealed
	var/obj/vehicle/sealed/vehicle_entered_target

/datum/action/vehicle/sealed/climb_out
	name = "Climb Out"
	desc = "Climb out of your vehicle!"

/datum/action/vehicle/sealed/climb_out/Trigger()
	procstart = null
	src.procstart = null
	if(..() && istype(vehicle_entered_target))
		vehicle_entered_target.mob_try_exit(owner, owner)

/datum/action/vehicle/ridden
	var/obj/vehicle/ridden/vehicle_ridden_target
