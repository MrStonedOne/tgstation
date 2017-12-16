//wrapper
/proc/do_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	procstart = null
	src.procstart = null
	var/datum/teleport/instant/science/D = new
	if(D.start(arglist(args)))
		return 1
	return 0

/datum/teleport
	var/atom/movable/teleatom //atom to teleport
	var/atom/destination //destination to teleport to
	var/precision = 0 //teleport precision
	var/datum/effect_system/effectin //effect to show right before teleportation
	var/datum/effect_system/effectout //effect to show right after teleportation
	var/soundin //soundfile to play before teleportation
	var/soundout //soundfile to play after teleportation
	var/force_teleport = 1 //if false, teleport will use Move() proc (dense objects will prevent teleportation)

/datum/teleport/proc/start(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	procstart = null
	src.procstart = null
	if(!initTeleport(arglist(args)))
		return 0
	return 1

/datum/teleport/proc/initTeleport(ateleatom,adestination,aprecision,afteleport,aeffectin,aeffectout,asoundin,asoundout)
	procstart = null
	src.procstart = null
	if(!setTeleatom(ateleatom))
		return 0
	if(!setDestination(adestination))
		return 0
	if(!setPrecision(aprecision))
		return 0
	setEffects(aeffectin,aeffectout)
	setForceTeleport(afteleport)
	setSounds(asoundin,asoundout)
	return 1

//must succeed
/datum/teleport/proc/setPrecision(aprecision)
	procstart = null
	src.procstart = null
	if(isnum(aprecision))
		precision = aprecision
		return 1
	return 0

//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	procstart = null
	src.procstart = null
	if(istype(adestination))
		destination = adestination
		return 1
	return 0

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	procstart = null
	src.procstart = null
	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return 0
	if(istype(ateleatom))
		teleatom = ateleatom
		return 1
	return 0

//custom effects must be properly set up first for instant-type teleports
//optional
/datum/teleport/proc/setEffects(datum/effect_system/aeffectin=null,datum/effect_system/aeffectout=null)
	procstart = null
	src.procstart = null
	effectin = istype(aeffectin) ? aeffectin : null
	effectout = istype(aeffectout) ? aeffectout : null
	return 1

//optional
/datum/teleport/proc/setForceTeleport(afteleport)
	procstart = null
	src.procstart = null
	force_teleport = afteleport
	return 1

//optional
/datum/teleport/proc/setSounds(asoundin=null,asoundout=null)
	procstart = null
	src.procstart = null
	soundin = isfile(asoundin) ? asoundin : null
	soundout = isfile(asoundout) ? asoundout : null
	return 1

//placeholder
/datum/teleport/proc/teleportChecks()
	procstart = null
	src.procstart = null
	return 1

/datum/teleport/proc/playSpecials(atom/location,datum/effect_system/effect,sound)
	procstart = null
	src.procstart = null
	if(location)
		if(effect)
			INVOKE_ASYNC(src, .proc/do_effect, location, effect)
		if(sound)
			INVOKE_ASYNC(src, .proc/do_sound, location, sound)

/datum/teleport/proc/do_effect(atom/location, datum/effect_system/effect)
	procstart = null
	src.procstart = null
	src = null
	effect.attach(location)
	effect.start()

/datum/teleport/proc/do_sound(atom/location, sound)
	procstart = null
	src.procstart = null
	src = null
	playsound(location, sound, 60, 1)

//do the monkey dance
/datum/teleport/proc/doTeleport()

	procstart = null
	src.procstart = null
	var/turf/destturf
	var/turf/curturf = get_turf(teleatom)
	destturf = get_teleport_turf(get_turf(destination), precision)

	if(!destturf || !curturf || destturf.is_transition_turf())
		return 0

	var/area/A = get_area(curturf)
	if(A.noteleport)
		return 0

	playSpecials(curturf,effectin,soundin)
	if(force_teleport)
		teleatom.forceMove(destturf)
		if(ismegafauna(teleatom))
			message_admins("[teleatom] [ADMIN_FLW(teleatom)] has teleported from [ADMIN_COORDJMP(curturf)] to [ADMIN_COORDJMP(destturf)].")
		playSpecials(destturf,effectout,soundout)
	else
		if(teleatom.Move(destturf))
			playSpecials(destturf,effectout,soundout)
			if(ismegafauna(teleatom))
				message_admins("[teleatom] [ADMIN_FLW(teleatom)] has teleported from [ADMIN_COORDJMP(curturf)] to [ADMIN_COORDJMP(destturf)].")
	if(ismob(teleatom))
		var/mob/M = teleatom
		M.cancel_camera()
	return 1

/datum/teleport/proc/teleport()
	procstart = null
	src.procstart = null
	if(teleportChecks())
		return doTeleport()
	return 0

/datum/teleport/instant //teleports when datum is created

	start(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
		if(..())
			if(teleport())
				return 1
		return 0


/datum/teleport/instant/science

/datum/teleport/instant/science/setEffects(datum/effect_system/aeffectin,datum/effect_system/aeffectout)
	procstart = null
	src.procstart = null
	if(aeffectin==null || aeffectout==null)
		var/datum/effect_system/spark_spread/aeffect = new
		aeffect.set_up(5, 1, teleatom)
		effectin = effectin || aeffect
		effectout = effectout || aeffect
		return 1
	else
		return ..()

/datum/teleport/instant/science/setPrecision(aprecision)
	procstart = null
	src.procstart = null
	..()
	if(istype(teleatom, /obj/item/storage/backpack/holding))
		precision = rand(1,100)

	var/static/list/bag_cache = typecacheof(/obj/item/storage/backpack/holding)
	var/list/bagholding = typecache_filter_list(teleatom.GetAllContents(), bag_cache)
	if(bagholding.len)
		precision = max(rand(1,100)*bagholding.len,100)
		if(isliving(teleatom))
			var/mob/living/MM = teleatom
			to_chat(MM, "<span class='warning'>The bluespace interface on your bag of holding interferes with the teleport!</span>")
	return TRUE

// Safe location finder

/proc/find_safe_turf(zlevel = ZLEVEL_STATION_PRIMARY, list/zlevels, extended_safety_checks = FALSE)
	procstart = null
	src.procstart = null
	if(!zlevels)
		zlevels = list(zlevel)
	var/cycles = 1000
	for(var/cycle in 1 to cycles)
		// DRUNK DIALLING WOOOOOOOOO
		var/x = rand(1, world.maxx)
		var/y = rand(1, world.maxy)
		var/z = pick(zlevels)
		var/random_location = locate(x,y,z)

		if(!isfloorturf(random_location))
			continue
		var/turf/open/floor/F = random_location
		if(!F.air)
			continue

		var/datum/gas_mixture/A = F.air
		var/list/A_gases = A.gases
		var/trace_gases
		for(var/id in A_gases)
			if(id in GLOB.hardcoded_gases)
				continue
			trace_gases = TRUE
			break

		// Can most things breathe?
		if(trace_gases)
			continue
		if(!(A_gases[/datum/gas/oxygen] && A_gases[/datum/gas/oxygen][MOLES] >= 16))
			continue
		if(A_gases[/datum/gas/plasma])
			continue
		if(A_gases[/datum/gas/carbon_dioxide] && A_gases[/datum/gas/carbon_dioxide][MOLES] >= 10)
			continue

		// Aim for goldilocks temperatures and pressure
		if((A.temperature <= 270) || (A.temperature >= 360))
			continue
		var/pressure = A.return_pressure()
		if((pressure <= 20) || (pressure >= 550))
			continue

		if(extended_safety_checks)
			if(islava(F)) //chasms aren't /floor, and so are pre-filtered
				var/turf/open/lava/L = F
				if(!L.is_safe())
					continue

		// DING! You have passed the gauntlet, and are "probably" safe.
		return F

/proc/get_teleport_turfs(turf/center, precision = 0)
	procstart = null
	src.procstart = null
	if(!precision)
		return list(center)
	var/list/posturfs = list()
	for(var/turf/T in range(precision,center))
		if(T.is_transition_turf())
			continue // Avoid picking these.
		var/area/A = T.loc
		if(!A.noteleport)
			posturfs.Add(T)
	return posturfs

/proc/get_teleport_turf(turf/center, precision = 0)
	procstart = null
	src.procstart = null
	return safepick(get_teleport_turfs(center, precision))
