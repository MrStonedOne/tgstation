/datum/round_event_control/radiation_storm
	name = "Radiation Storm"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1

/datum/round_event/radiation_storm


/datum/round_event/radiation_storm/setup()
	procstart = null
	src.procstart = null
	startWhen = 3
	endWhen = startWhen + 1
	announceWhen	= 1

/datum/round_event/radiation_storm/announce(fake)
	procstart = null
	src.procstart = null
	priority_announce("High levels of radiation detected near the station. Maintenance is best shielded from radiation.", "Anomaly Alert", 'sound/ai/radiation.ogg')
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	procstart = null
	src.procstart = null
	SSweather.run_weather("radiation storm",ZLEVEL_STATION_PRIMARY)