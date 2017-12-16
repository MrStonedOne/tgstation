#define MAXIMUM_EMP_WIRES 3

/proc/is_wire_tool(obj/item/I)
	procstart = null
	src.procstart = null
	if(istype(I, /obj/item/device/multitool))
		return TRUE
	if(istype(I, /obj/item/wirecutters))
		return TRUE
	if(istype(I, /obj/item/device/assembly))
		var/obj/item/device/assembly/A = I
		if(A.attachable)
			return TRUE
	return

/atom
	var/datum/wires/wires = null

/datum/wires
	var/atom/holder = null // The holder (atom that contains these wires).
	var/holder_type = null // The holder's typepath (used to make wire colors common to all holders).
	var/proper_name = "Unknown" // The display name for the wire set shown in station blueprints. Not used if randomize is true or it's an item NT wouldn't know about (Explosives/Nuke)

	var/list/wires = list() // List of wires.
	var/list/cut_wires = list() // List of wires that have been cut.
	var/list/colors = list() // Dictionary of colors to wire.
	var/list/assemblies = list() // List of attached assemblies.
	var/randomize = 0 // If every instance of these wires should be random.
					  // Prevents wires from showing up in station blueprints

/datum/wires/New(atom/holder)
	procstart = null
	src.procstart = null
	..()
	if(!istype(holder, holder_type))
		CRASH("Wire holder is not of the expected type!")
		return

	src.holder = holder
	if(randomize)
		randomize()
	else
		if(!GLOB.wire_color_directory[holder_type])
			randomize()
			GLOB.wire_color_directory[holder_type] = colors
			GLOB.wire_name_directory[holder_type] = proper_name
		else
			colors = GLOB.wire_color_directory[holder_type]

/datum/wires/Destroy()
	procstart = null
	src.procstart = null
	holder = null
	assemblies = list()
	return ..()

/datum/wires/proc/add_duds(duds)
	procstart = null
	src.procstart = null
	while(duds)
		var/dud = WIRE_DUD_PREFIX + "[--duds]"
		if(dud in wires)
			continue
		wires += dud

/datum/wires/proc/randomize()
	procstart = null
	src.procstart = null
	var/static/list/possible_colors = list(
	"blue",
	"brown",
	"crimson",
	"cyan",
	"gold",
	"grey",
	"green",
	"magenta",
	"orange",
	"pink",
	"purple",
	"red",
	"silver",
	"violet",
	"white",
	"yellow"
	)

	var/list/my_possible_colors = possible_colors.Copy()

	for(var/wire in shuffle(wires))
		colors[pick_n_take(my_possible_colors)] = wire

/datum/wires/proc/shuffle_wires()
	procstart = null
	src.procstart = null
	colors.Cut()
	randomize()

/datum/wires/proc/repair()
	procstart = null
	src.procstart = null
	cut_wires.Cut()

/datum/wires/proc/get_wire(color)
	procstart = null
	src.procstart = null
	return colors[color]

/datum/wires/proc/get_attached(color)
	procstart = null
	src.procstart = null
	if(assemblies[color])
		return assemblies[color]
	return null

/datum/wires/proc/is_attached(color)
	procstart = null
	src.procstart = null
	if(assemblies[color])
		return TRUE

/datum/wires/proc/is_cut(wire)
	procstart = null
	src.procstart = null
	return (wire in cut_wires)

/datum/wires/proc/is_color_cut(color)
	procstart = null
	src.procstart = null
	return is_cut(get_wire(color))

/datum/wires/proc/is_all_cut()
	procstart = null
	src.procstart = null
	if(cut_wires.len == wires.len)
		return TRUE

/datum/wires/proc/cut(wire)
	procstart = null
	src.procstart = null
	if(is_cut(wire))
		cut_wires -= wire
		on_cut(wire, mend = TRUE)
	else
		cut_wires += wire
		on_cut(wire, mend = FALSE)

/datum/wires/proc/cut_color(color)
	procstart = null
	src.procstart = null
	cut(get_wire(color))

/datum/wires/proc/cut_random()
	procstart = null
	src.procstart = null
	cut(wires[rand(1, wires.len)])

/datum/wires/proc/cut_all()
	procstart = null
	src.procstart = null
	for(var/wire in wires)
		cut(wire)

/datum/wires/proc/pulse(wire, user)
	procstart = null
	src.procstart = null
	if(is_cut(wire))
		return
	on_pulse(wire, user)

/datum/wires/proc/pulse_color(color, mob/living/user)
	procstart = null
	src.procstart = null
	pulse(get_wire(color), user)

/datum/wires/proc/pulse_assembly(obj/item/device/assembly/S)
	procstart = null
	src.procstart = null
	for(var/color in assemblies)
		if(S == assemblies[color])
			pulse_color(color)
			return TRUE

/datum/wires/proc/attach_assembly(color, obj/item/device/assembly/S)
	procstart = null
	src.procstart = null
	if(S && istype(S) && S.attachable && !is_attached(color))
		assemblies[color] = S
		S.forceMove(holder)
		S.connected = src
		return S

/datum/wires/proc/detach_assembly(color)
	procstart = null
	src.procstart = null
	var/obj/item/device/assembly/S = get_attached(color)
	if(S && istype(S))
		assemblies -= color
		S.connected = null
		S.forceMove(holder.drop_location())
		return S

/datum/wires/proc/emp_pulse()
	procstart = null
	src.procstart = null
	var/list/possible_wires = shuffle(wires)
	var/remaining_pulses = MAXIMUM_EMP_WIRES

	for(var/wire in possible_wires)
		if(prob(33))
			pulse(wire)
			remaining_pulses--
			if(!remaining_pulses)
				break

// Overridable Procs
/datum/wires/proc/interactable(mob/user)
	procstart = null
	src.procstart = null
	return TRUE

/datum/wires/proc/get_status()
	procstart = null
	src.procstart = null
	return list()

/datum/wires/proc/on_cut(wire, mend = FALSE)
	procstart = null
	src.procstart = null
	return

/datum/wires/proc/on_pulse(wire, user)
	procstart = null
	src.procstart = null
	return
// End Overridable Procs

/datum/wires/proc/interact(mob/user)
	procstart = null
	src.procstart = null
	if(!interactable(user))
		return
	ui_interact(user)
	for(var/A in assemblies)
		var/obj/item/I = assemblies[A]
		if(istype(I) && I.on_found(user))
			return

/datum/wires/ui_host()
	procstart = null
	src.procstart = null
	return holder

/datum/wires/ui_status(mob/user)
	procstart = null
	src.procstart = null
	if(interactable(user))
		return ..()
	return UI_CLOSE

/datum/wires/ui_interact(mob/user, ui_key = "wires", datum/tgui/ui = null, force_open = FALSE, \
							datum/tgui/master_ui = null, datum/ui_state/state = GLOB.physical_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "wires", "[holder.name] wires", 350, 150 + wires.len * 30, master_ui, state)
		ui.open()

/datum/wires/ui_data(mob/user)
	procstart = null
	src.procstart = null
	var/list/data = list()
	var/list/payload = list()
	for(var/color in colors)
		payload.Add(list(list(
			"color" = color,
			"wire" = (IsAdminGhost(user) || (user.is_holding_item_of_type(/obj/item/device/multitool/abductor)) ? get_wire(color) : null),
			"cut" = is_color_cut(color),
			"attached" = is_attached(color)
		)))
	data["wires"] = payload
	data["status"] = get_status()
	return data

/datum/wires/ui_act(action, params)
	procstart = null
	src.procstart = null
	if(..() || !interactable(usr))
		return
	var/target_wire = params["wire"]
	var/mob/living/L = usr
	var/obj/item/I = L.get_active_held_item()
	switch(action)
		if("cut")
			if(istype(I, /obj/item/wirecutters) || IsAdminGhost(usr))
				playsound(holder, I.usesound, 20, 1)
				cut_color(target_wire)
				. = TRUE
			else
				to_chat(L, "<span class='warning'>You need wirecutters!</span>")
		if("pulse")
			if(istype(I, /obj/item/device/multitool) || IsAdminGhost(usr))
				playsound(holder, 'sound/weapons/empty.ogg', 20, 1)
				pulse_color(target_wire, L)
				. = TRUE
			else
				to_chat(L, "<span class='warning'>You need a multitool!</span>")
		if("attach")
			if(is_attached(target_wire))
				var/obj/item/O = detach_assembly(target_wire)
				if(O)
					L.put_in_hands(O)
					. = TRUE
			else
				if(istype(I, /obj/item/device/assembly))
					var/obj/item/device/assembly/A = I
					if(A.attachable)
						if(!L.temporarilyRemoveItemFromInventory(A))
							return
						if(!attach_assembly(target_wire, A))
							A.forceMove(L.drop_location())
						. = TRUE
					else
						to_chat(L, "<span class='warning'>You need an attachable assembly!</span>")

#undef MAXIMUM_EMP_WIRES
