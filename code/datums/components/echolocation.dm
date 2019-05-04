/datum/component/echolocation
	var/echo_range = 4

	var/cooldown_time = 15
	var/image_expiry_time = 30
	var/cooldown_last = 0
	var/list/static/echo_blacklist
	var/list/static/uniques
	var/list/static/echo_images

/datum/component/echolocation/Initialize()
	. = ..()
	var/mob/M = parent
	if(!istype(M))
		return COMPONENT_INCOMPATIBLE
	echo_blacklist = typecacheof(list(
	/atom/movable/lighting_object,
	/obj/effect/decal/cleanable/blood,
	/obj/effect/decal/cleanable/xenoblood,
	/obj/effect/decal/cleanable/oil,
	/obj/screen,
	/image,
	/turf/open,
	/area)
	)

	uniques = typecacheof(list(
	/obj/structure/table,
	/mob/living/carbon/human,
	/obj/machinery/door/airlock)
	)

	echo_images = list()
	var/datum/action/innate/echo/E = new
	var/datum/action/innate/echo/auto/A = new
	E.Grant(M)
	A.Grant(M)
	RegisterSignal(E, COMSIG_ACTION_TRIGGER, .proc/echolocate)
	RegisterSignal(A, COMSIG_ACTION_TRIGGER, .proc/toggle_auto)

/datum/component/echolocation/process()
	var/mob/M = parent
	if(!M.client)
		STOP_PROCESSING(SSecholocation, src)
	echolocate()

/datum/component/echolocation/proc/echolocate()
	if(world.time < cooldown_last)
		return
	cooldown_last = world.time + cooldown_time
	var/mob/H = parent
	var/mutable_appearance/image_output
	var/list/filtered = list()
	var/list/turfs = list()
	var/list/seen = oview(echo_range, H)
	var/list/receivers = list()
	receivers += H
	for(var/I in seen)
		var/atom/A = I
		if(!(A.type in echo_blacklist) && !A.invisibility)
			if(istype(I, /obj))
				if(istype(A.loc, /turf))
					filtered += I
			if(istype(I, /mob/living))
				filtered += I
			if(istype(I, /turf/closed/wall))
				turfs += I
	for(var/mob/M in seen)
		var/datum/component/echolocation/E = M.GetComponent(/datum/component/echolocation)
		if(E)
			receivers += M
	for(var/F in filtered)
		var/atom/S = F
		if(echo_images[S.type])
			image_output = mutable_appearance(echo_images[S.type].icon, echo_images[S.type].icon_state, echo_images[S.type].layer, echo_images[S.type].plane)
			image_output.filters = echo_images[S.type].filters
			realign_icon(image_output, S)
		else
			image_output = generate_image(S)
			realign_icon(image_output, S)
			if(!(uniques[S.type]))
				echo_images[S.type] = image_output
		for(var/D in S.datum_outputs)
			if(istype(D, /datum/outputs/echo_override))
				var/datum/outputs/echo_override/O = D
				image_output = mutable_appearance(O.vfx.icon, O.vfx.icon_state, O.vfx.layer, O.vfx.plane)
				realign_icon(image_output, S)
		show_image(receivers, image_output, S)
	for(var/T in turfs)
		var/key = generate_wall_key(T)
		if(echo_images[key])
			image_output = mutable_appearance(echo_images[key].icon, echo_images[key].icon_state, echo_images[key].layer, echo_images[key].plane)
			image_output.filters = echo_images[key].filters
		else
			image_output = generate_wall_image(T)
			image_output.loc = T
			echo_images[generate_wall_key(T)] = image_output
		show_image(receivers, image_output, T)

/datum/component/echolocation/proc/show_image(list/receivers, mutable_appearance/mutable_echo, atom/input)
	var/image/image_echo = image(mutable_echo)
	if(istype(input, /turf))
		image_echo.loc = input
	else
		image_echo.loc = input.loc
	for(var/M in receivers)
		var/mob/receiving_mob = M
		if(receiving_mob.client)
			receiving_mob.client.images += image_echo
			addtimer(CALLBACK(src, .proc/remove_image, image_echo, receiving_mob), image_expiry_time)

/datum/component/echolocation/proc/remove_image(sound_image, mob/M)
	if(M.client && sound_image)
		M.client.images -= sound_image
		qdel(sound_image)

/datum/component/echolocation/proc/generate_image(atom/input)
	var/icon/I
	if(uniques[input.type])
		I = getFlatIcon(input)
	else
		I = icon(input.icon, input.icon_state)
	I.MapColors(rgb(0,0,0,0), rgb(0,0,0,0), rgb(0,0,0,255), rgb(0,0,0,-254))
	var/mutable_appearance/final_image = mutable_appearance(I, input.icon_state, CURSE_LAYER, input.plane)
	final_image.filters += filter(type="outline", size=1, color="#FFFFFF")
	return final_image

/datum/component/echolocation/proc/generate_wall_image(turf/input)
	var/icon/I = icon('icons/obj/echo_override.dmi',"wall")
	var/list/dirs = list()
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(input, direction)
		if(istype(T, /turf/closed))
			dirs += direction
	for(var/dir in dirs)
		switch(dir)
			if(NORTH)
				I.DrawBox(null,2,32,31,31)
			if(SOUTH)
				I.DrawBox(null,2,1,31,1)
			if(EAST)
				I.DrawBox(null,32,2,32,31)
			if(WEST)
				I.DrawBox(null,1,2,1,31)
	return mutable_appearance(I, null, CURSE_LAYER, input.plane)

/datum/component/echolocation/proc/generate_wall_key(turf/input)
	var/list/dirs = list()
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(input, direction)
		if(istype(T, /turf/closed))
			dirs += direction
	var/key = dirs.Join()
	return key

/datum/component/echolocation/proc/realign_icon(mutable_appearance/I, atom/input)
	I.dir = input.dir
	I.loc = input.loc
	I.pixel_x = input.pixel_x
	I.pixel_y = input.pixel_y

//AUTO

/datum/component/echolocation/proc/toggle_auto()
	if(!(datum_flags & DF_ISPROCESSING))
		to_chat(parent, "<span class='notice'>Instinct takes over your echolocation.</span>")
		START_PROCESSING(SSecholocation, src)
	else
		to_chat(parent, "<span class='notice'>You pay more attention on when to echolocate.</span>")
		STOP_PROCESSING(SSecholocation, src)

/datum/action/innate/echo
	name = "Echolocate"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "meson"

/datum/action/innate/echo/auto
	name = "Automatic Echolocation"