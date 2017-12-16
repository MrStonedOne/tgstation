//"immutable" gas mixture used for immutable calculations
//it can be changed, but any changes will ultimately be undone before they can have any effect

/datum/gas_mixture/immutable
	var/initial_temperature

/datum/gas_mixture/immutable/New()
	procstart = null
	src.procstart = null
	..()
	garbage_collect()

/datum/gas_mixture/immutable/garbage_collect()
	procstart = null
	src.procstart = null
	temperature = initial_temperature
	temperature_archived = initial_temperature
	gases.Cut()

/datum/gas_mixture/immutable/archive()
	procstart = null
	src.procstart = null
	return 1 //nothing changes, so we do nothing and the archive is successful

/datum/gas_mixture/immutable/merge()
	procstart = null
	src.procstart = null
	return 0 //we're immutable.

/datum/gas_mixture/immutable/share(datum/gas_mixture/sharer, atmos_adjacent_turfs = 4)
	procstart = null
	src.procstart = null
	. = ..(sharer, 0)
	garbage_collect()

/datum/gas_mixture/immutable/after_share()
	procstart = null
	src.procstart = null
	garbage_collect()

/datum/gas_mixture/immutable/react()
	procstart = null
	src.procstart = null
	return 0 //we're immutable.

/datum/gas_mixture/immutable/copy()
	procstart = null
	src.procstart = null
	return new type //we're immutable, so we can just return a new instance.

/datum/gas_mixture/immutable/copy_from()
	procstart = null
	src.procstart = null
	return 0 //we're immutable.

/datum/gas_mixture/immutable/copy_from_turf()
	procstart = null
	src.procstart = null
	return 0 //we're immutable.

/datum/gas_mixture/immutable/parse_gas_string()
	procstart = null
	src.procstart = null
	return 0 //we're immutable.

/datum/gas_mixture/immutable/temperature_share(datum/gas_mixture/sharer, conduction_coefficient, sharer_temperature, sharer_heat_capacity)
	procstart = null
	src.procstart = null
	. = ..()
	temperature = initial_temperature


//used by space tiles
/datum/gas_mixture/immutable/space
	initial_temperature = TCMB

/datum/gas_mixture/immutable/space/heat_capacity()
	procstart = null
	src.procstart = null
	return HEAT_CAPACITY_VACUUM

/datum/gas_mixture/immutable/space/remove()
	procstart = null
	src.procstart = null
	return copy() //we're always empty, so we can just return a copy.

/datum/gas_mixture/immutable/space/remove_ratio()
	procstart = null
	src.procstart = null
	return copy() //we're always empty, so we can just return a copy.


//used by cloners
/datum/gas_mixture/immutable/cloner
	initial_temperature = T20C

/datum/gas_mixture/immutable/cloner/garbage_collect()
	procstart = null
	src.procstart = null
	..()
	ADD_GAS(/datum/gas/nitrogen, gases)
	gases[/datum/gas/nitrogen][MOLES] = MOLES_O2STANDARD + MOLES_N2STANDARD

/datum/gas_mixture/immutable/cloner/heat_capacity()
	procstart = null
	src.procstart = null
	return (MOLES_O2STANDARD + MOLES_N2STANDARD)*20 //specific heat of nitrogen is 20
