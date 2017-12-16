
/mob/living/silicon/robot/Login()
	procstart = null
	src.procstart = null
	..()
	regenerate_icons()
	show_laws(0)
