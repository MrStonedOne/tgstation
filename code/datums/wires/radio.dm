/datum/wires/radio
	holder_type = /obj/item/device/radio
	proper_name = "Radio"

/datum/wires/radio/New(atom/holder)
	procstart = null
	src.procstart = null
	wires = list(
		WIRE_SIGNAL,
		WIRE_RX, WIRE_TX
	)
	..()

/datum/wires/radio/interactable(mob/user)
	procstart = null
	src.procstart = null
	var/obj/item/device/radio/R = holder
	return R.unscrewed

/datum/wires/radio/on_pulse(index)
	procstart = null
	src.procstart = null
	var/obj/item/device/radio/R = holder
	switch(index)
		if(WIRE_SIGNAL)
			R.listening = !R.listening
			R.broadcasting = R.listening
		if(WIRE_RX)
			R.listening = !R.listening
		if(WIRE_TX)
			R.broadcasting = !R.broadcasting
