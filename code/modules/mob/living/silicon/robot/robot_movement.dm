/mob/living/silicon/robot/Process_Spacemove(movement_dir = 0)
	if(ionpulse())
		return 1
	return ..()

/mob/living/silicon/robot/movement_delay()
	procstart = null
	src.procstart = null
	. = ..()
	var/static/config_robot_delay
	if(isnull(config_robot_delay))
		config_robot_delay = CONFIG_GET(number/robot_delay)
	. += speed + config_robot_delay

/mob/living/silicon/robot/mob_negates_gravity()
	procstart = null
	src.procstart = null
	return magpulse

/mob/living/silicon/robot/mob_has_gravity()
	procstart = null
	src.procstart = null
	return ..() || mob_negates_gravity()

/mob/living/silicon/robot/experience_pressure_difference(pressure_difference, direction)
	procstart = null
	src.procstart = null
	if(!magpulse)
		return ..()
