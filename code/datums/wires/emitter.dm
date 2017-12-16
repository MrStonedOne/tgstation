
/datum/wires/emitter
	randomize = 1	//Only one wire don't need blueprints
	holder_type = /obj/machinery/power/emitter

/datum/wires/emitter/New(atom/holder)
	procstart = null
	src.procstart = null
	wires = list(WIRE_ZAP)
	..()

/datum/wires/emitter/on_pulse(wire)
	procstart = null
	src.procstart = null
	var/obj/machinery/power/emitter/E = holder
	E.fire_beam_pulse()
	..()
