/datum/config_entry/string/comms_key
	protection = CONFIG_ENTRY_HIDDEN

/datum/config_entry/string/comms_key/ValidateAndSet(str_val)
	procstart = null
	src.procstart = null
	return str_val != "default_pwd" && length(str_val) > 6 && ..()

/datum/config_entry/keyed_string_list/cross_server
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/keyed_string_list/cross_server/ValidateAndSet(str_val)
	procstart = null
	src.procstart = null
	. = ..()
	if(.)
		var/list/newv = list()
		for(var/I in value)
			newv[replacetext(I, "+", " ")] = value[I]
		value = newv

/datum/config_entry/keyed_string_list/cross_server/ValidateListEntry(key_name, key_value)
	procstart = null
	src.procstart = null
	return key_value != "byond:\\address:port" && ..()

/datum/config_entry/string/cross_comms_name

GLOBAL_VAR_INIT(medals_enabled, TRUE)	//will be auto set to false if the game fails contacting the medal hub to prevent unneeded calls.

/datum/config_entry/string/medal_hub_address

/datum/config_entry/string/medal_hub_password
	protection = CONFIG_ENTRY_HIDDEN