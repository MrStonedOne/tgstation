var/list/VVlocked = list("vars", "var_edited", "client", "virus", "viruses", "cuffed", "last_eaten", "unlock_content", "step_x", "step_y", "force_ending")
var/list/VVicon_edit_lock = list("icon", "icon_state", "overlays", "underlays", "resize")
var/list/VVckey_edit = list("key", "ckey")

/*
/client/proc/cmd_modify_object_variables(obj/O as obj|mob|turf|area in world)
	set category = "Debug"
	set name = "Edit Variables"
	set desc="(target) Edit a target item's variables"
	src.modify_variables(O)
	feedback_add_details("admin_verb","EDITV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
*/

/client/proc/vv_get_class(var/var_value)
	if(isnull(var_value))
		. = VV_NULL

	else if (isnum(var_value))
		. = VV_NUM

	else if (istext(var_value))
		if (findtext(var_value, "\n"))
			. = VV_MESSAGE
		else
			. = VV_TEXT

	else if (isicon(var_value))
		. = VV_ICON

	else if (ismob(var_value))
		. = VV_MOB_REFERENCE

	else if (isloc(var_value))
		. = VV_ATOM_REFERENCE

	else if (istype(var_value,/client))
		. = VV_CLIENT

	else if (istype(var_value, /datum))
		. = VV_DATUM_REFERENCE

	else if (ispath(var_value))
		if (ispath(var_value, /atom))
			. = VV_ATOM_TYPE
		else if (ispath(var_value, /datum))
			. = VV_DATUM_TYPE
		else
			. = VV_TYPE

	else if (istype(var_value,/list))
		. = VV_LIST

	else if (isfile(var_value))
		. = VV_FILE
	else
		. = VV_NULL

/client/proc/vv_get_value(class, default_class, restricted_classes, extra_classes)
	. = list("class" = class, "value" = null)
	if (!class)
		var/list/classes = list (
			VV_NUM,
			VV_TEXT,
			VV_MESSAGE,
			VV_ICON,
			VV_ATOM_REFERENCE,
			#ifdef TESTING
			VV_DATUM_REFERENCE,
			#endif TESTING
			VV_MOB_REFERENCE,
			VV_CLIENT,
			VV_ATOM_TYPE,
			VV_DATUM_TYPE,
			VV_TYPE,
			VV_FILE,
			VV_NEW_ATOM,
			VV_NEW_DATUM,
			VV_NEW_TYPE,
			VV_NEW_LIST,
			VV_NULL,
			VV_RESTORE_DEFAULT
			)

		if(holder && holder.marked_datum && !(VV_MARKED_DATUM in restricted_classes))
			classes += "[VV_MARKED_DATUM] ([holder.marked_datum.type])"
		if (restricted_classes)
			classes -= restricted_classes

		if (extra_classes)
			classes += extra_classes

		.["class"] = input(src, "What kind of data?", "Variable Type", default_class) as null|anything in classes
		if (.["class"] == "[VV_MARKED_DATUM] ([holder.marked_datum.type])")
			.["class"] = VV_MARKED_DATUM


	switch(.["class"])
		if (VV_TEXT)
			.["value"] = input("Enter new text:", "Text") as null|text
		if (VV_MESSAGE)
			.["value"] = input("Enter new text:", "Text") as null|message
		if (VV_NUM)
			.["value"] = input("Enter new number:", "Num") as null|num
		if (VV_ATOM_TYPE)
			.["value"] = input("Enter type:", "Type") as null|anything in get_fancy_list_of_atom_types()
		if (VV_DATUM_TYPE)
			.["value"] = input("Enter type:", "Type") as null|anything in get_fancy_list_of_datum_types()
		if (VV_ATOM_REFERENCE)
			.["value"] = input("Select reference:", "Reference") as null|mob|obj|turf|area in world
		if (VV_MOB_REFERENCE)
			.["value"] = input("Select reference:", "Reference") as null|mob in world
		if (VV_CLIENT)
			.["value"] = input("Select reference:", "Reference") as null|anything in clients
		if (VV_FILE)
			.["value"] = input("Pick file:", "File") as null|file
		if (VV_ICON)
			.["value"] = input("Pick icon:", "Icon") as null|icon
		if (VV_MARKED_DATUM)
			.["value"] = holder.marked_datum
		if (VV_NEW_ATOM)
			var/type = input("Enter type:", "Type") as null|anything in get_fancy_list_of_atom_types()
			if (type)
				.["value"] = new type()
		if (VV_NEW_DATUM)
			var/type = input("Enter type:", "Type") as null|anything in get_fancy_list_of_datum_types()
			.["value"] = new type()
		if (VV_NEW_TYPE)
			var/type
			do
				type = input("Enter type:", "Type", type) as null|text
				if (!type)
					break
				type = text2path(type)
			while(!type)
			if (type)
				.["value"] = new type()
		if (VV_NEW_LIST)
			.["value"] = list()

/client/proc/mod_list_add_ass(atom/O) //hehe

	var/list/L = vv_get_value(restricted_classes = list(VV_RESTORE_DEFAULT))
	var/class = L["class"]
	if (!class)
		return
	var/var_value = L["value"]

	if(!var_value && class != VV_NULL)
		return

	if(class == VV_TEXT || class == VV_MESSAGE)
		if(findtext(var_value,"\["))
			var/process_vars = alert(usr,"\[] detected in string, process as variables?","Process Variables?","Yes","No")
			if(process_vars == "Yes")
				var/list/varsvars = string2listofvars(var_value, O)
				for(var/V in varsvars)
					var_value = replacetext(var_value,"\[[V]]","[O.vars[V]]")

	return var_value


/client/proc/mod_list_add(list/L, atom/O, original_name, objectvar)
	var/list/LL = vv_get_value(restricted_classes = list(VV_RESTORE_DEFAULT))
	var/class = LL["class"]
	if (!class)
		return
	var/var_value = LL["value"]
	if(!var_value && class != VV_NULL)
		return

	if(class == VV_TEXT || class == VV_MESSAGE)
		if(findtext(var_value,"\["))
			var/process_vars = alert(usr,"\[] detected in string, process as variables?","Process Variables?","Yes","No")
			if(process_vars == "Yes")
				var/list/varsvars = string2listofvars(var_value, O)
				for(var/V in varsvars)
					var_value = replacetext(var_value,"\[[V]]","[O.vars[V]]")

	var/list/newlist = L.Copy()
	newlist += var_value

	switch(alert("Would you like to associate a value with the list entry?",,"Yes","No"))
		if("Yes")
			newlist[var_value] = mod_list_add_ass(O) //hehe
	if (!O.vv_edit_var(objectvar, newlist))
		src << "Your edit was rejected by the object."
		return
	world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: ADDED=[var_value]"
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: ADDED=[var_value]")
	message_admins("[key_name_admin(src)] modified [original_name]'s [objectvar]: ADDED=[var_value]")

/client/proc/mod_list(list/L, atom/O, original_name, objectvar)
	if(!check_rights(R_VAREDIT))
		return
	if(!istype(L,/list))
		src << "Not a List."

	if(L.len > 1000)
		var/confirm = alert(src, "The list you're trying to edit is very long, continuing may crash the server.", "Warning", "Continue", "Abort")
		if(confirm != "Continue")
			return



	var/list/names = null
	for (var/i in 1 to L.len)
		names["#[i] [L[i]]"] = i

	var/variable
	var/assoc_key

	variable = input("Which var?","Var") as null|anything in names + "(ADD VAR)" + "(CLEAR NULLS)" + "(CLEAR DUPES)" + "(SHUFFLE)"

	if(variable == "(ADD VAR)")
		mod_list_add(L, O, original_name, objectvar)
		return

	if(variable == "(CLEAR NULLS)")
		L = L.Copy()
		listclearnulls(L)
		if (!O.vv_edit_var(objectvar, L))
			src << "Your edit was rejected by the object."
			return
		world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: CLEAR NULLS"
		log_admin("[key_name(src)] modified [original_name]'s [objectvar]: CLEAR NULLS")
		message_admins("[key_name_admin(src)] modified [original_name]'s list [objectvar]: CLEAR NULLS")
		return

	if(variable == "(CLEAR DUPES)")
		L = uniqueList(L)
		if (!O.vv_edit_var(objectvar, L))
			src << "Your edit was rejected by the object."
			return
		world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: CLEAR DUPES"
		log_admin("[key_name(src)] modified [original_name]'s [objectvar]: CLEAR DUPES")
		message_admins("[key_name_admin(src)] modified [original_name]'s list [objectvar]: CLEAR DUPES")
		return

	if(variable == "(SHUFFLE)")
		L = shuffle(L)
		if (!O.vv_edit_var(objectvar, L))
			src << "Your edit was rejected by the object."
			return
		world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: SHUFFLE"
		log_admin("[key_name(src)] modified [original_name]'s [objectvar]: SHUFFLE")
		message_admins("[key_name_admin(src)] modified [original_name]'s list [objectvar]: SHUFFLE")
		return

	var/default

	default = vv_get_class(variable)

	src << "Variable appears to be <b>[uppertext(default)]</b>."

	src << "Variable contains: [variable]"

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

	var/class = "text"
	if(src.holder && src.holder.marked_datum)
		class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default", "new atom", "new datum","marked datum ([holder.marked_datum.type])", "DELETE FROM LIST")
	else
		class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default", "new atom", "new datum", "DELETE FROM LIST")

	if(!class)
		return

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	var/original_var
	if(assoc)
		original_var = L[assoc_key]
	else
		original_var = L[L.Find(variable)]

	var/new_var
	L = L.Copy()
	switch(class) //Spits a runtime error if you try to modify an entry in the contents list. Dunno how to fix it, yet.
		if("list")
			mod_list(variable, O, original_name, objectvar)

		if("restore to default")
			new_var = initial(variable)
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("edit referenced object")
			modify_variables(variable)

		if("DELETE FROM LIST")
			L -= variable
			if (!O.vv_edit_var(objectvar, L))
				src << "Your edit was rejected by the object."
				return
			world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: REMOVED=[html_encode("[variable]")]"
			log_admin("[key_name(src)] modified [original_name]'s [objectvar]: REMOVED=[variable]")
			message_admins("[key_name_admin(src)] modified [original_name]'s [objectvar]: REMOVED=[variable]")
			return

		if("text")
			new_var = input("Enter new text:","Text") as message

			if(findtext(new_var,"\["))
				var/process_vars = alert(usr,"\[] detected in string, process as variables?","Process Variables?","Yes","No")
				if(process_vars == "Yes")
					var/list/varsvars = string2listofvars(new_var, O)
					for(var/V in varsvars)
						new_var = replacetext(new_var,"\[[V]]","[O.vars[V]]")

			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("num")
			new_var = input("Enter new number:","Num") as num
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("type")
			new_var = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("reference")
			new_var = input("Select reference:","Reference") as mob|obj|turf|area in world
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("mob reference")
			new_var = input("Select reference:","Reference") as mob in world
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("file")
			new_var = input("Pick file:","File") as file
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("icon")
			new_var = input("Pick icon:","Icon") as icon
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("marked datum")
			new_var = holder.marked_datum
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("new atom")
			var/type = input("Enter type:","Type") as null|anything in typesof(/obj,/mob,/area,/turf)
			new_var = new type()
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("new datum")
			var/type = input("Enter type:","Type") as null|anything in (typesof(/datum)-typesof(/obj,/mob,/area,/turf,/client))
			new_var = new type()
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var



	world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: [original_var]=[new_var]"
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: [original_var]=[new_var]")
	message_admins("[key_name_admin(src)] modified [original_name]'s varlist [objectvar]: [original_var]=[new_var]")

/client/proc/modify_variables(atom/O, param_var_name = null, autodetect_class = 0)
	if(!check_rights(R_VAREDIT))
		return

	if(istype(O, /client) && (param_var_name == "ckey" || param_var_name == "key"))
		usr << "<span class='danger'>You cannot edit ckeys on client objects.</span>"
		return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!param_var_name in O.vars)
			src << "A variable with this name ([param_var_name]) doesn't exist in this atom ([O])"
			return

		if(param_var_name in VVlocked)
			if(!check_rights(R_DEBUG))
				return
		if(param_var_name in VVckey_edit)
			if(!check_rights(R_SPAWN|R_DEBUG))
				return
		if(param_var_name in VVicon_edit_lock)
			if(!check_rights(R_FUN|R_DEBUG))
				return

		variable = param_var_name

		var_value = O.vars[variable]

		if(autodetect_class)
			if(isnull(var_value))
				usr << "Unable to determine variable type."
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				usr << "Variable appears to be <b>NUM</b>."
				class = "num"
				setDir(1)

			else if(istext(var_value))
				usr << "Variable appears to be <b>TEXT</b>."
				class = "text"

			else if(isloc(var_value))
				usr << "Variable appears to be <b>REFERENCE</b>."
				class = "reference"

			else if(isicon(var_value))
				usr << "Variable appears to be <b>ICON</b>."
				var_value = "\icon[var_value]"
				class = "icon"

			else if(istype(var_value,/client))
				usr << "Variable appears to be <b>CLIENT</b>."
				class = "cancel"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				usr << "Variable appears to be <b>TYPE</b>."
				class = "type"

			else if(istype(var_value,/list))
				usr << "Variable appears to be <b>LIST</b>."
				class = "list"

			else
				usr << "Variable appears to be <b>FILE</b>."
				class = "file"

	else

		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("Which var?","Var") as null|anything in names
		if(!variable)
			return
		var_value = O.vars[variable]

		if(variable in VVlocked)
			if(!check_rights(R_DEBUG))
				return
		if(variable in VVckey_edit)
			if(!check_rights(R_SPAWN|R_DEBUG))
				return
		if(variable in VVicon_edit_lock)
			if(!check_rights(R_FUN|R_DEBUG))
				return

	if(!autodetect_class)

		var/dir
		var/default
		if(isnull(var_value))
			usr << "Unable to determine variable type."

		else if(isnum(var_value))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
			setDir(1)

		else if(istext(var_value))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"

		else if(isloc(var_value))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"

		else if(isicon(var_value))
			usr << "Variable appears to be <b>ICON</b>."
			var_value = "\icon[var_value]"
			default = "icon"

		else if(istype(var_value,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			default = "cancel"

		else if(istype(var_value,/atom) || istype(var_value,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"

		else if(istype(var_value,/list))
			usr << "Variable appears to be <b>LIST</b>."
			default = "list"

		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"

		usr << "Variable contains: [var_value]"
		if(dir)
			switch(var_value)
				if(1)
					setDir("NORTH")
				if(2)
					setDir("SOUTH")
				if(4)
					setDir("EAST")
				if(8)
					setDir("WEST")
				if(5)
					setDir("NORTHEAST")
				if(6)
					setDir("SOUTHEAST")
				if(9)
					setDir("NORTHWEST")
				if(10)
					setDir("SOUTHWEST")
				else
					setDir(null)
			if(dir)
				usr << "If a direction, direction is: [dir]"

		if(src.holder && src.holder.marked_datum)
			class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
				"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default", "new atom", "new datum", "marked datum ([holder.marked_datum.type])")
		else
			class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
				"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default", "new atom", "new datum")

		if(!class)
			return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref[O] ([O])"
	else
		original_name = O:name

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	switch(class)

		if("list")
			if(!istype(O.vars[variable],/list))
				var/listchange = alert(usr,"Force change to empty list?","Change to list?","Yes","No")
				if(listchange == "Yes")
					O.vars[variable] = list()	//Unlike all other VV operations, the type change must be set here, not at the end of setting data. Hence the warning
			mod_list(O.vars[variable], O, original_name, variable)
			return

		if("restore to default")
			O.vars[variable] = initial(O.vars[variable])

		if("edit referenced object")
			return .(O.vars[variable])

		if("text")
			var/var_new = input("Enter new text:","Text",O.vars[variable]) as null|message
			if(var_new==null) return

			if(findtext(var_new,"\["))
				var/process_vars = alert(usr,"\[] detected in string, process as variables?","Process Variables?","Yes","No")
				if(process_vars == "Yes")
					var/list/varsvars = string2listofvars(var_new, O)
					for(var/V in varsvars)
						var_new = replacetext(var_new,"\[[V]]","[O.vars[V]]")

			O.vars[variable] = var_new

		if("num")
			if(variable=="luminosity")
				var/var_new = input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new == null) return
				O.SetLuminosity(var_new)
			else if(variable=="stat")
				var/var_new = input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new == null) return
				if((O.vars[variable] == 2) && (var_new < 2))//Bringing the dead back to life
					dead_mob_list -= O
					living_mob_list += O
				if((O.vars[variable] < 2) && (var_new == 2))//Kill he
					living_mob_list -= O
					dead_mob_list += O
				O.vars[variable] = var_new
			else
				var/var_new =  input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new==null) return
				O.vars[variable] = var_new

		if("type")
			var/target_path = input("Enter type:", "Type", O.vars[variable]) as null|text
			if(!target_path)
				return
			var/var_new = text2path(target_path)
			if(!ispath(var_new))
				var_new = pick_closest_path(target_path)
			if(!var_new)
				return
			O.vars[variable] = var_new

		if("reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob|obj|turf|area in world
			if(var_new==null) return
			O.vars[variable] = var_new

		if("mob reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob in world
			if(var_new==null) return
			O.vars[variable] = var_new

		if("file")
			var/var_new = input("Pick file:","File",O.vars[variable]) as null|file
			if(var_new==null) return
			O.vars[variable] = var_new

		if("icon")
			var/var_new = input("Pick icon:","Icon",O.vars[variable]) as null|icon
			if(var_new==null) return
			O.vars[variable] = var_new

		if("marked datum")
			O.vars[variable] = holder.marked_datum

		if("new atom")
			var/type = input("Enter type:","Type") as null|anything in typesof(/obj,/mob,/area,/turf)
			var/var_new = new type()
			if(var_new==null) return
			O.vars[variable] = var_new

		if("new datum")
			var/type = input("Enter type:","Type") as null|anything in (typesof(/datum)-typesof(/obj,/mob,/area,/turf,/client))
			var/var_new = new type()
			if(var_new==null) return
			O.vars[variable] = var_new

	if (!O.vv_edit_var(variable, var_new))
		src << "Your edit was rejected by the object."
		return
	world.log << "### VarEdit by [src]: [O.type] [variable]=[html_encode("[O.vars[variable]]")]"
	log_admin("[key_name(src)] modified [original_name]'s [variable] to [O.vars[variable]]")
	message_admins("[key_name_admin(src)] modified [original_name]'s [variable] to [O.vars[variable]]")
