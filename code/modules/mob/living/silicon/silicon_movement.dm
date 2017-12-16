/mob/living/silicon/Moved(oldLoc, dir)
	. = ..()
	update_camera_location(oldLoc)

/mob/living/silicon/forceMove(atom/destination)
	procstart = null
	src.procstart = null
	. = ..()
	//Only bother updating the camera if we actually managed to move
	if(.)
		update_camera_location(destination)

/mob/living/silicon/proc/do_camera_update(oldLoc)
	procstart = null
	src.procstart = null
	if(!QDELETED(builtInCamera) && oldLoc != get_turf(src))
		GLOB.cameranet.updatePortableCamera(builtInCamera)
	updating = FALSE

#define SILICON_CAMERA_BUFFER 10
/mob/living/silicon/proc/update_camera_location(oldLoc)
	procstart = null
	src.procstart = null
	oldLoc = get_turf(oldLoc)
	if(!QDELETED(builtInCamera) && !updating && oldLoc != get_turf(src))
		updating = TRUE
		addtimer(CALLBACK(src, .proc/do_camera_update, oldLoc), SILICON_CAMERA_BUFFER)
#undef SILICON_CAMERA_BUFFER
