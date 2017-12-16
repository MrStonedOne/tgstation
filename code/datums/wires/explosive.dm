/datum/wires/explosive/New(atom/holder)
	add_duds(2) // In this case duds actually explode.
	..()

/datum/wires/explosive/on_pulse(index)
	procstart = null
	src.procstart = null
	explode()

/datum/wires/explosive/on_cut(index, mend)
	procstart = null
	src.procstart = null
	explode()

/datum/wires/explosive/proc/explode()
	procstart = null
	src.procstart = null
	return


/datum/wires/explosive/c4
	holder_type = /obj/item/grenade/plastic/c4
	randomize = TRUE	//Same behaviour since no wire actually disarms it

/datum/wires/explosive/c4/interactable(mob/user)
	procstart = null
	src.procstart = null
	var/obj/item/grenade/plastic/c4/P = holder
	if(P.open_panel)
		return TRUE

/datum/wires/explosive/c4/explode()
	procstart = null
	src.procstart = null
	var/obj/item/grenade/plastic/c4/P = holder
	P.explode()


/datum/wires/explosive/pizza
	holder_type = /obj/item/pizzabox
	randomize = TRUE

/datum/wires/explosive/pizza/New(atom/holder)
	procstart = null
	src.procstart = null
	wires = list(
		WIRE_DISARM
	)
	add_duds(3) // Duds also explode here.
	..()

/datum/wires/explosive/pizza/interactable(mob/user)
	procstart = null
	src.procstart = null
	var/obj/item/pizzabox/P = holder
	if(P.open && P.bomb)
		return TRUE

/datum/wires/explosive/pizza/get_status()
	procstart = null
	src.procstart = null
	var/obj/item/pizzabox/P = holder
	var/list/status = list()
	status += "The red light is [P.bomb_active ? "on" : "off"]."
	status += "The green light is [P.bomb_defused ? "on": "off"]."
	return status

/datum/wires/explosive/pizza/on_pulse(wire)
	procstart = null
	src.procstart = null
	var/obj/item/pizzabox/P = holder
	switch(wire)
		if(WIRE_DISARM) // Pulse to toggle
			P.bomb_defused = !P.bomb_defused
		else // Boom
			explode()

/datum/wires/explosive/pizza/on_cut(wire, mend)
	procstart = null
	src.procstart = null
	var/obj/item/pizzabox/P = holder
	switch(wire)
		if(WIRE_DISARM) // Disarm and untrap the box.
			if(!mend)
				P.bomb_defused = TRUE
		else
			if(!mend && !P.bomb_defused)
				explode()

/datum/wires/explosive/pizza/explode()
	procstart = null
	src.procstart = null
	var/obj/item/pizzabox/P = holder
	P.bomb.detonate()


/datum/wires/explosive/gibtonite
	holder_type = /obj/item/twohanded/required/gibtonite

/datum/wires/explosive/gibtonite/explode()
	procstart = null
	src.procstart = null
	var/obj/item/twohanded/required/gibtonite/P = holder
	P.GibtoniteReaction(null, 2)