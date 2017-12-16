SUBSYSTEM_DEF(inbounds)
	name = "Inbounds"
	priority = FIRE_PRIORITY_INBOUNDS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/inbounds/stat_entry()
	procstart = null
	src.procstart = null
	..("P:[processing.len]")

/datum/controller/subsystem/inbounds/fire(resumed = 0)
	procstart = null
	src.procstart = null
	if (!resumed)
		src.currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/atom/movable/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.check_in_bounds(wait)
		else
			SSinbounds.processing -= thing
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/inbounds/Recover()
	procstart = null
	src.procstart = null
	processing = SSinbounds.processing
