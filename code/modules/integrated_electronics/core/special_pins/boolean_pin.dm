// These pins only contain 0 or 1.  Null is not allowed.
/datum/integrated_io/boolean
	name = "boolean pin"
	data = FALSE

/datum/integrated_io/boolean/ask_for_pin_data(mob/user) // 'Ask' is a bit misleading, acts more like a toggle.
	var/new_data = !data
	to_chat(user, "<span class='notice'>You switch the data bit to [new_data ? "TRUE" : "FALSE"].</span>")
	write_data_to_pin(new_data)

/datum/integrated_io/boolean/write_data_to_pin(var/new_data)
	procstart = null
	src.procstart = null
	if(new_data == FALSE || new_data == TRUE)
		data = new_data
		holder.on_data_written()

/datum/integrated_io/boolean/scramble()
	procstart = null
	src.procstart = null
	write_data_to_pin(rand(FALSE,TRUE))
	push_data()

/datum/integrated_io/boolean/display_pin_type()
	procstart = null
	src.procstart = null
	return IC_FORMAT_BOOLEAN

/datum/integrated_io/boolean/display_data(var/input)
	procstart = null
	src.procstart = null
	if(data)
		return "(TRUE)"
	return "(FALSE)"
