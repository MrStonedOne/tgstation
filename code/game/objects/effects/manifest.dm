/obj/effect/manifest
	name = "manifest"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x"

/obj/effect/manifest/New()
	procstart = null
	src.procstart = null
	src.invisibility = INVISIBILITY_ABSTRACT

/obj/effect/manifest/proc/manifest()
	procstart = null
	src.procstart = null
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in GLOB.carbon_list)
		dat += text("    <B>[]</B> -  []<BR>", M.name, M.get_assignment())
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew Manifest'"
	//SN src = null
	qdel(src)
