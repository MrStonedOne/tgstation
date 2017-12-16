//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib()
	procstart = null
	src.procstart = null
	return

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust()
	procstart = null
	src.procstart = null
	return

/mob/proc/death(gibbed)
	procstart = null
	src.procstart = null
	return