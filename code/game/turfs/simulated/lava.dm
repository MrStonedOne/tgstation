///LAVA

/turf/open/lava
	name = "lava"
	icon_state = "lava"
	gender = PLURAL //"That's some lava."
	baseturf = /turf/open/lava //lava all the way down
	slowdown = 2

	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA

/turf/open/lava/ex_act(severity, target)
	procstart = null
	src.procstart = null
	contents_explosion(severity, target)

/turf/open/lava/MakeSlippery(wet_setting = TURF_WET_WATER, min_wet_time = 0, wet_time_to_add = 0)
	procstart = null
	src.procstart = null
	return

/turf/open/lava/MakeDry(wet_setting = TURF_WET_WATER)
	procstart = null
	src.procstart = null
	return

/turf/open/lava/airless
	initial_gas_mix = "TEMP=2.7"

/turf/open/lava/Entered(atom/movable/AM)
	procstart = null
	src.procstart = null
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/open/lava/hitby(atom/movable/AM)
	procstart = null
	src.procstart = null
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/open/lava/process()
	procstart = null
	src.procstart = null
	if(!burn_stuff())
		STOP_PROCESSING(SSobj, src)

/turf/open/lava/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	procstart = null
	src.procstart = null
	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 3)
	return FALSE

/turf/open/lava/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	procstart = null
	src.procstart = null
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, "<span class='notice'>You build a floor.</span>")
			ChangeTurf(/turf/open/floor/plating)
			return TRUE
	return FALSE

/turf/open/lava/singularity_act()
	procstart = null
	src.procstart = null
	return

/turf/open/lava/singularity_pull(S, current_size)
	procstart = null
	src.procstart = null
	return

/turf/open/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	procstart = null
	src.procstart = null
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/lava/GetHeatCapacity()
	procstart = null
	src.procstart = null
	. = 700000

/turf/open/lava/GetTemperature()
	procstart = null
	src.procstart = null
	. = 5000

/turf/open/lava/TakeTemperature(temp)


/turf/open/lava/proc/is_safe()
	procstart = null
	src.procstart = null
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/lattice/catwalk, /obj/structure/stone_tile))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	for(var/obj/structure/stone_tile/S in found_safeties)
		if(S.fallen)
			LAZYREMOVE(found_safeties, S)
	return LAZYLEN(found_safeties)


/turf/open/lava/proc/burn_stuff(AM)
	procstart = null
	src.procstart = null
	. = 0

	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if (AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if((O.resistance_flags & (LAVA_PROOF|INDESTRUCTIBLE)) || O.throwing)
				continue
			. = 1
			if((O.resistance_flags & (ON_FIRE)))
				continue
			if(!(O.resistance_flags & FLAMMABLE))
				O.resistance_flags |= FLAMMABLE //Even fireproof things burn up in lava
			if(O.resistance_flags & FIRE_PROOF)
				O.resistance_flags &= ~FIRE_PROOF
			if(O.armor["fire"] > 50) //obj with 100% fire armor still get slowly burned away.
				O.armor["fire"] = 50
			O.fire_act(10000, 1000)

		else if (isliving(thing))
			. = 1
			var/mob/living/L = thing
			if(L.movement_type & FLYING)
				continue	//YOU'RE FLYING OVER IT
			if("lava" in L.weather_immunities)
				continue
			if(L.buckled)
				if(isobj(L.buckled))
					var/obj/O = L.buckled
					if(O.resistance_flags & LAVA_PROOF)
						continue
				if(isliving(L.buckled)) //Goliath riding
					var/mob/living/live = L.buckled
					if("lava" in live.weather_immunities)
						continue

			L.adjustFireLoss(20)
			if(L) //mobs turning into object corpses could get deleted here.
				L.adjust_fire_stacks(20)
				L.IgniteMob()

/turf/open/lava/smooth
	name = "lava"
	baseturf = /turf/open/lava/smooth
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/lava/smooth)

/turf/open/lava/smooth/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturf = /turf/open/chasm/lavaland

/turf/open/lava/smooth/airless
	initial_gas_mix = "TEMP=2.7"
