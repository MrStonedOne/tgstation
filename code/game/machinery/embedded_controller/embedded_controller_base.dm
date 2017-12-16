/datum/computer/file/embedded_program
	var/list/memory = list()
	var/state
	var/obj/machinery/embedded_controller/master

/datum/computer/file/embedded_program/proc/post_signal(datum/signal/signal, comm_line)
	procstart = null
	src.procstart = null
	if(master)
		master.post_signal(signal, comm_line)
	else
		qdel(signal)

/datum/computer/file/embedded_program/proc/receive_user_command(command)

/datum/computer/file/embedded_program/proc/receive_signal(datum/signal/signal)
	procstart = null
	src.procstart = null
	return null

/datum/computer/file/embedded_program/process()
	procstart = null
	src.procstart = null
	return 0

/obj/machinery/embedded_controller
	var/datum/computer/file/embedded_program/program

	name = "embedded controller"
	density = FALSE
	anchored = TRUE

	var/on = TRUE

/obj/machinery/embedded_controller/interact(mob/user)
	procstart = null
	src.procstart = null
	user.set_machine(src)
	var/datum/browser/popup = new(user, "computer", name) // Set up the popup browser window
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.set_content(return_text())
	popup.open()

/obj/machinery/embedded_controller/attack_hand(mob/user)
	procstart = null
	src.procstart = null
	interact(user)

/obj/machinery/embedded_controller/update_icon()

/obj/machinery/embedded_controller/proc/return_text()

/obj/machinery/embedded_controller/proc/post_signal(datum/signal/signal, comm_line)
	procstart = null
	src.procstart = null
	return 0

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal)
	procstart = null
	src.procstart = null
	if(istype(signal) && program)
		program.receive_signal(signal)

/obj/machinery/embedded_controller/Topic(href, href_list)
	procstart = null
	src.procstart = null
	if(..())
		return 0

	if(program)
		program.receive_user_command(href_list["command"])
		addtimer(CALLBACK(program, /datum/computer/file/embedded_program.proc/process), 5)

	usr.set_machine(src)
	addtimer(CALLBACK(src, .proc/updateDialog), 5)

/obj/machinery/embedded_controller/process()
	procstart = null
	src.procstart = null
	if(program)
		program.process()

	update_icon()
	src.updateDialog()

/obj/machinery/embedded_controller/radio
	var/frequency
	var/datum/radio_frequency/radio_connection

/obj/machinery/embedded_controller/radio/Destroy()
	procstart = null
	src.procstart = null
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/embedded_controller/radio/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	set_frequency(frequency)

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal)
	procstart = null
	src.procstart = null
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal)
	else
		signal = null

/obj/machinery/embedded_controller/radio/proc/set_frequency(new_frequency)
	procstart = null
	src.procstart = null
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency)
