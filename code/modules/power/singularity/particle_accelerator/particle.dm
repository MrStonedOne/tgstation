/obj/effect/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "particle"
	anchored = TRUE
	density = FALSE
	var/movement_range = 10
	var/energy = 10
	var/speed = 1

/obj/effect/accelerated_particle/weak
	movement_range = 8
	energy = 5

/obj/effect/accelerated_particle/strong
	movement_range = 15
	energy = 15

/obj/effect/accelerated_particle/powerful
	movement_range = 20
	energy = 50


/obj/effect/accelerated_particle/New(loc)
	procstart = null
	src.procstart = null
	..()

	addtimer(CALLBACK(src, .proc/move), 1)


/obj/effect/accelerated_particle/Collide(atom/A)
	procstart = null
	src.procstart = null
	if(A)
		if(isliving(A))
			toxmob(A)
		else if(istype(A, /obj/machinery/the_singularitygen))
			var/obj/machinery/the_singularitygen/S = A
			S.energy += energy
		else if(istype(A, /obj/singularity))
			var/obj/singularity/S = A
			S.energy += energy
		else if(istype(A, /obj/structure/blob))
			var/obj/structure/blob/B = A
			B.take_damage(energy*0.6)
			movement_range = 0

/obj/effect/accelerated_particle/Crossed(atom/A)
	procstart = null
	src.procstart = null
	if(isliving(A))
		toxmob(A)


/obj/effect/accelerated_particle/ex_act(severity, target)
	procstart = null
	src.procstart = null
	qdel(src)

/obj/effect/accelerated_particle/singularity_pull()
	procstart = null
	src.procstart = null
	return

/obj/effect/accelerated_particle/proc/toxmob(mob/living/M)
	procstart = null
	src.procstart = null
	M.rad_act(energy*6)

/obj/effect/accelerated_particle/proc/move()
	procstart = null
	src.procstart = null
	if(!step(src,dir))
		forceMove(get_step(src,dir))
	movement_range--
	if(movement_range == 0)
		qdel(src)
	else
		sleep(speed)
		move()
