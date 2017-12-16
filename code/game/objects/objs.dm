/obj
	var/crit_fail = FALSE
	animate_movement = 2
	var/throwforce = 0
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!

	var/damtype = BRUTE
	var/force = 0

	var/list/armor
	var/obj_integrity	//defaults to max_integrity
	var/max_integrity = 500
	var/integrity_failure = 0 //0 if we have no special broken behavior

	var/resistance_flags = NONE // INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ON_FIRE | UNACIDABLE | ACID_PROOF
	var/can_be_hit = TRUE //can this be bludgeoned by items?

	var/acid_level = 0 //how much acid is on that obj

	var/being_shocked = FALSE

	var/on_blueprints = FALSE //Are we visible on the station blueprints at roundstart?
	var/force_blueprints = FALSE //forces the obj to be on the blueprints, regardless of when it was created.

	var/persistence_replacement //have something WAY too amazing to live to the next round? Set a new path here. Overuse of this var will make me upset.
	var/unique_rename = FALSE // can you customize the description/name of the thing?
	var/current_skin //Has the item been reskinned?
	var/list/unique_reskin //List of options to reskin.
	var/dangerous_possession = FALSE	//Admin possession yes/no

/obj/vv_edit_var(vname, vval)
	procstart = null
	src.procstart = null
	switch(vname)
		if("dangerous_possession")
			return FALSE
		if("control_object")
			var/obj/O = vval
			if(istype(O) && O.dangerous_possession)
				return FALSE
	..()

/obj/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	if (!armor)
		armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0)
	if(obj_integrity == null)
		obj_integrity = max_integrity
	if(on_blueprints && isturf(loc))
		var/turf/T = loc
		if(force_blueprints)
			T.add_blueprints(src)
		else
			T.add_blueprints_preround(src)

/obj/Destroy(force=FALSE)
	procstart = null
	src.procstart = null
	if(!ismachinery(src))
		STOP_PROCESSING(SSobj, src) // TODO: Have a processing bitflag to reduce on unnecessary loops through the processing lists
	SStgui.close_uis(src)
	. = ..()

/obj/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback)
	procstart = null
	src.procstart = null
	..()
	if(flags_2 & FROZEN_2)
		visible_message("<span class='danger'>[src] shatters into a million pieces!</span>")
		qdel(src)

/obj/assume_air(datum/gas_mixture/giver)
	procstart = null
	src.procstart = null
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	procstart = null
	src.procstart = null
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	procstart = null
	src.procstart = null
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
	procstart = null
	src.procstart = null
	//Return: (NONSTANDARD)
	//		null if object handles breathing logic for lifeform
	//		datum/air_group to tell lifeform to process using that breath return
	//DEFAULT: Take air from turf to give to have mob process

	if(breath_request>0)
		var/datum/gas_mixture/environment = return_air()
		var/breath_percentage = BREATH_VOLUME / environment.return_volume()
		return remove_air(environment.total_moles() * breath_percentage)
	else
		return null

/obj/proc/updateUsrDialog()
	procstart = null
	src.procstart = null
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if(isAI(usr) || iscyborg(usr) || IsAdminGhost(usr))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)

		// check for TK users

		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(!(usr in nearby))
				if(usr.client && usr.machine==src)
					if(H.dna.check_mutation(TK))
						is_in_use = 1
						src.attack_hand(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	procstart = null
	src.procstart = null
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0


/obj/attack_ghost(mob/user)
	procstart = null
	src.procstart = null
	if(ui_interact(user) != -1)
		return
	..()

/obj/proc/container_resist(mob/living/user)
	procstart = null
	src.procstart = null
	return

/obj/proc/update_icon()
	procstart = null
	src.procstart = null
	return

/mob/proc/unset_machine()
	procstart = null
	src.procstart = null
	if(machine)
		machine.on_unset_machine(src)
		machine = null

//called when the user unsets the machine.
/atom/movable/proc/on_unset_machine(mob/user)
	procstart = null
	src.procstart = null
	return

/mob/proc/set_machine(obj/O)
	procstart = null
	src.procstart = null
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	procstart = null
	src.procstart = null
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(h)
	procstart = null
	src.procstart = null
	return

/obj/singularity_pull(S, current_size)
	procstart = null
	src.procstart = null
	..()
	if(!anchored || current_size >= STAGE_FIVE)
		step_towards(src,S)

/obj/get_spans()
	procstart = null
	src.procstart = null
	return ..() | SPAN_ROBOT

/obj/storage_contents_dump_act(obj/item/storage/src_object, mob/user)
	procstart = null
	src.procstart = null
	return

/obj/get_dumping_location(obj/item/storage/source,mob/user)
	procstart = null
	src.procstart = null
	return get_turf(src)

/obj/proc/CanAStarPass()
	procstart = null
	src.procstart = null
	. = !density

/obj/proc/check_uplink_validity()
	procstart = null
	src.procstart = null
	return 1

/obj/proc/on_mob_move(dir, mob, oldLoc, forced)
	procstart = null
	src.procstart = null
	return

/obj/proc/on_mob_turn(dir, mob)
	procstart = null
	src.procstart = null
	return

/obj/proc/intercept_user_move(dir, mob, newLoc, oldLoc)
	procstart = null
	src.procstart = null
	return

/obj/vv_get_dropdown()
	procstart = null
	src.procstart = null
	. = ..()
	.["Delete all of type"] = "?_src_=vars;[HrefToken()];delall=[REF(src)]"
	.["Osay"] = "?_src_=vars;[HrefToken()];osay[REF(src)]"

/obj/examine(mob/user)
	procstart = null
	src.procstart = null
	..()
	if(unique_rename)
		to_chat(user, "<span class='notice'>Use a pen on it to rename it or change its description.</span>")
	if(unique_reskin && !current_skin)
		to_chat(user, "<span class='notice'>Alt-click it to reskin it.</span>")

/obj/AltClick(mob/user)
	procstart = null
	src.procstart = null
	. = ..()
	if(unique_reskin && !current_skin && in_range(user,src))
		if(user.incapacitated())
			to_chat(user, "<span class='warning'>You can't do that right now!</span>")
			return
		reskin_obj(user)

/obj/proc/reskin_obj(mob/M)
	procstart = null
	src.procstart = null
	if(!LAZYLEN(unique_reskin))
		return
	var/choice = input(M,"Warning, you can only reskin [src] once!","Reskin Object") as null|anything in unique_reskin
	if(!QDELETED(src) && choice && !current_skin && !M.incapacitated() && in_range(M,src))
		if(!unique_reskin[choice])
			return
		current_skin = choice
		icon_state = unique_reskin[choice]
		to_chat(M, "[src] is now skinned as '[choice].'")
