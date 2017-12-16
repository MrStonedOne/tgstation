// called when movable is expelled from a disposal pipe or outlet
// by default does nothing, override for special behaviour

/atom/movable/proc/pipe_eject(direction)
	procstart = null
	src.procstart = null
	return

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(direction)
	procstart = null
	src.procstart = null
	var/list/dirs
	if(direction)
		dirs = list(direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	streak(dirs)

/obj/effect/decal/cleanable/robot_debris/gib/pipe_eject(direction)
	procstart = null
	src.procstart = null
	var/list/dirs
	if(direction)
		dirs = list(direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	streak(dirs)
