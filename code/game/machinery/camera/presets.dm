// PRESETS

// EMP
/obj/machinery/camera/emp_proof
	start_active = 1

/obj/machinery/camera/emp_proof/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	upgradeEmpProof()

// X-RAY

/obj/machinery/camera/xray
	start_active = 1
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/machinery/camera/xray/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	upgradeXRay()

// MOTION
/obj/machinery/camera/motion
	start_active = 1
	name = "motion-sensitive security camera"

/obj/machinery/camera/motion/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	upgradeMotion()

// ALL UPGRADES
/obj/machinery/camera/all
	start_active = 1

/obj/machinery/camera/all/Initialize()
	procstart = null
	src.procstart = null
	. = ..()
	upgradeEmpProof()
	upgradeXRay()
	upgradeMotion()

// AUTONAME

/obj/machinery/camera/autoname
	var/number = 0 //camera number in area

//This camera type automatically sets it's name to whatever the area that it's in is called.
/obj/machinery/camera/autoname/Initialize()
	procstart = null
	src.procstart = null
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/camera/autoname/LateInitialize()
	procstart = null
	src.procstart = null
	. = ..()
	number = 1
	var/area/A = get_area(src)
	if(A)
		for(var/obj/machinery/camera/autoname/C in GLOB.machines)
			if(C == src)
				continue
			var/area/CA = get_area(C)
			if(CA.type == A.type)
				if(C.number)
					number = max(number, C.number+1)
		c_tag = "[A.name] #[number]"

// CHECKS

/obj/machinery/camera/proc/isEmpProof()
	procstart = null
	src.procstart = null
	return upgrades & CAMERA_UPGRADE_EMP_PROOF

/obj/machinery/camera/proc/isXRay()
	procstart = null
	src.procstart = null
	return upgrades & CAMERA_UPGRADE_XRAY

/obj/machinery/camera/proc/isMotion()
	procstart = null
	src.procstart = null
	return upgrades & CAMERA_UPGRADE_MOTION

// UPGRADE PROCS

/obj/machinery/camera/proc/upgradeEmpProof()
	procstart = null
	src.procstart = null
	assembly.upgrades.Add(new /obj/item/stack/sheet/mineral/plasma(assembly))
	upgrades |= CAMERA_UPGRADE_EMP_PROOF

/obj/machinery/camera/proc/upgradeXRay()
	procstart = null
	src.procstart = null
	assembly.upgrades.Add(new /obj/item/device/analyzer(assembly))
	upgrades |= CAMERA_UPGRADE_XRAY

// If you are upgrading Motion, and it isn't in the camera's Initialize(), add it to the machines list.
/obj/machinery/camera/proc/upgradeMotion()
	procstart = null
	src.procstart = null
	assembly.upgrades.Add(new /obj/item/device/assembly/prox_sensor(assembly))
	upgrades |= CAMERA_UPGRADE_MOTION
