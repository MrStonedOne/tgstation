/client/proc/cmd_mass_modify_object_variables(atom/A, var_name)
	set category = "Debug"
	set name = "Mass Edit Variables"
	set desc="(target) Edit all instances of a target item's variables"

	var/method = 0	//0 means strict type detection while 1 means this type and all subtypes (IE: /obj/item with this set to 1 will set it to ALL itms)

	if(!check_rights(R_VAREDIT))
		return

	if(A && A.type)
		if(typesof(A.type))
			switch(input("Strict object type detection?") as null|anything in list("Strictly this type","This type and subtypes", "Cancel"))
				if("Strictly this type")
					method = 0
				if("This type and subtypes")
					method = 1
				if("Cancel")
					return
				if(null)
					return

	src.massmodify_variables(A, var_name, method)
	feedback_add_details("admin_verb","MEV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/massmodify_variables(datum/O, var_name = "", method = 0)
	if(!check_rights(R_VAREDIT))
		return
	if(!istype(O))
		return

	var/variable = ""
	if(!var_name)
		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("Which var?", "Var") as null|anything in names
	else
		variable = var_name

	if(!variable)
		return
	var/default
	var/var_value = O.vars[variable]

	if(variable in VVckey_edit)
		usr << "It's forbidden to mass-modify ckeys. It'll crash everyone's client you dummy."
		return
	if(variable in VVlocked)
		if(!check_rights(R_DEBUG))
			return
	if(variable in VVicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG))
			return
	default = vv_get_class(var_value)

	if(isnull(default))
		usr << "Unable to determine variable type."
	else
		usr << "Variable appears to be <b>[uppertext(default)]</b>."

	usr << "Variable contains: [var_value]"

	if(default == VV_NUM)
		var/dir_text = ""
		if(dir < 0 && dir < 16)
			if(dir & 1)
				dir_text += "NORTH"
			if(dir & 2)
				dir_text += "SOUTH"
			if(dir & 4)
				dir_text += "EAST"
			if(dir & 8)
				dir_text += "WEST"

		if(dir_text)
			usr << "If a direction, direction is: [dir_text]"

	var/class = input("What kind of variable?", "Variable Type", default) as null|anything in list("text",
		"num","type","icon","file","edit referenced object","restore to default")

	if(!class)
		return

	var/original_name

	if (!istype(O, /datum))
		original_name = "\ref[O] ([O])"
	else
		original_name = "[O]"

	var/list/items = get_all_of_type(O.type, !method)

	switch(class)

		if("restore to default")
			O.vv_edit_var(variable, initial(O.vars[variable]))
			for(var/datum/D in items)
				D.vv_edit_var(variable, initial(D.vars[variable]))
				CHECK_TICK

		if("edit referenced object")
			return .(O.vars[variable])

		if("text")
			var/new_value = input("Enter new text:", "Text", O.vars[variable]) as message|null
			if(new_value == null) return

			var/process_vars = 0
			var/unique = 0
			if(findtext(new_value,"\["))
				process_vars = alert(usr, "\[] detected in string, process as variables?", "Process Variables?", "Yes", "No")
				if(process_vars == "Yes")
					process_vars = 1
					unique = alert(usr, "Process vars unique to each instance, or same for all?", "Variable Association", "Unique", "Same")
					if(unique == "Unique")
						unique = 1
					else
						unique = 0
				else
					process_vars = 0

			var/pre_processing = new_value
			var/list/varsvars = list()

			if(process_vars)
				varsvars = string2listofvars(new_value, O)
				if(varsvars.len)
					for(var/V in varsvars)
						new_value = replacetext(new_value,"\[[V]]","[O.vars[V]]")


			for(var/datum/D in items)
				if(process_vars && unique)
					new_value = pre_processing
					for(var/V in varsvars)
						new_value = replacetext(new_value,"\[[V]]","[D.vars[V]]")

				D.vv_edit_var(variable, new_value)
				CHECK_TICK

		if("num")
			var/new_value = input("Enter new number:", "Num", O.vars[variable]) as num|null
			if(new_value == null)
				return

			for(var/datum/D in items)
				D.vv_edit_var(variable, new_value)
				CHECK_TICK

		if("type")
			var/new_value
			new_value = input("Enter type:","Type",O.vars[variable]) as null|anything in typesof(/datum)
			if(new_value == null) return
			for(var/datum/D in items)
				D.vv_edit_var(variable, new_value)
				CHECK_TICK

		if("file")
			var/new_value = input("Pick file:","File",O.vars[variable]) as null|file
			if(new_value == null) return
			O.vars[variable] = new_value
			for(var/datum/D in items)
				D.vv_edit_var(variable, new_value)
				CHECK_TICK

		if("icon")
			var/new_value = input("Pick icon:","Icon",O.vars[variable]) as null|icon
			if(new_value == null) return
			O.vars[variable] = new_value
			for(var/datum/D in items)
				D.vv_edit_var(variable, new_value)
				CHECK_TICK

	world.log << "### MassVarEdit by [src]: [O.type] [variable]=[html_encode("[O.vars[variable]]")]"
	log_admin("[key_name(src)] mass modified [original_name]'s [variable] to [O.vars[variable]]")
	message_admins("[key_name_admin(src)] mass modified [original_name]'s [variable] to [O.vars[variable]]")


/proc/get_all_of_type(var/T, stricttype = FALSE)
	var/list/typecache = list(T = 1)
	if (!stricttype)
		typecache = typecacheof(typecache)
	. = list()
	if (ispath(T, /mob))
		for(var/mob/thing in mob_list)
			if (typecache[thing.type])
				. += thing
	else if (ispath(T, /obj/machinery/door))
		for(var/obj/machinery/door/thing in airlocks)
			if (typecache[thing.type])
				. += thing

	else if (ispath(T, /obj/machinery))
		for(var/obj/machinery/thing in machines)
			if (typecache[thing.type])
				. += thing

	else if (ispath(T, /obj))
		for(var/obj/thing in world)
			if (typecache[thing.type])
				. += thing

	else if (ispath(T, /atom/movable))
		for(var/atom/movable/thing in world)
			if (typecache[thing.type])
				. += thing

	else if (ispath(T, /turf))
		for(var/turf/thing in world)
			if (typecache[thing.type])
				. += thing

	else if (ispath(T, /atom))
		for(var/atom/thing in world)
			if (typecache[thing.type])
				. += thing

	else if (ispath(T, /client))
		for(var/client/thing in clients)
			if (typecache[thing.type])
				. += thing

	else if (ispath(T, /datum))
		for(var/datum/thing)
			if (typecache[thing.type])
				. += thing

	else
		for(var/datum/thing in world)
			if (typecache[thing.type])
				. += thing
