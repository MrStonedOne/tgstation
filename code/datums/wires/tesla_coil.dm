
/datum/wires/tesla_coil
	randomize = 1	//Only one wire don't need blueprints
	holder_type = /obj/machinery/power/tesla_coil

/datum/wires/tesla_coil/New(atom/holder)
	procstart = null
	src.procstart = null
	wires = list(WIRE_ZAP)
	..()

/datum/wires/tesla_coil/on_pulse(wire)
	procstart = null
	src.procstart = null
	var/obj/machinery/power/tesla_coil/C = holder
	C.zap()
	..()
