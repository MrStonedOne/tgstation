// Basically, cut the event frequency in half to simulate unluckiness.

/datum/round_event_control/fridaythethirteen
	name = "Friday the 13th"
	holidayID = FRIDAY_13TH
	typepath = /datum/round_event/fridaythethirteen
	weight = -1
	max_occurrences = 1
	earliest_start = 0

/datum/round_event/fridaythethirteen/start()
	procstart = null
	src.procstart = null
	//Very unlucky, cut the frequency of events in half.
	events.frequency_lower /= 2
	events.frequency_upper /= 2

/datum/round_event/fridaythethirteen/announce(fake)
	procstart = null
	src.procstart = null
	for(var/mob/living/L in player_list)
		to_chat(L, "<span class='warning'>You are feeling unlucky today.</span>")