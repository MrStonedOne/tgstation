
//objects in /obj/effect should never be things that are attackable, use obj/structure instead.
//Effects are mostly temporary visual effects like sparks, smoke, as well as decals, etc...
/obj/effect
	icon = 'icons/effects/effects.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	can_be_hit = FALSE

/obj/effect/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	procstart = null
	src.procstart = null
	return

/obj/effect/fire_act(exposed_temperature, exposed_volume)
	procstart = null
	src.procstart = null
	return

/obj/effect/acid_act()
	procstart = null
	src.procstart = null
	return

/obj/effect/mech_melee_attack(obj/mecha/M)
	procstart = null
	src.procstart = null
	return 0

/obj/effect/blob_act()
	procstart = null
	src.procstart = null
	return

/obj/effect/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	procstart = null
	src.procstart = null
	return 0

/obj/effect/experience_pressure_difference()
	procstart = null
	src.procstart = null
	return

/obj/effect/ex_act(severity, target)
	procstart = null
	src.procstart = null
	if(target == src)
		qdel(src)
	else
		switch(severity)
			if(1)
				qdel(src)
			if(2)
				if(prob(60))
					qdel(src)
			if(3)
				if(prob(25))
					qdel(src)

/obj/effect/singularity_act()
	procstart = null
	src.procstart = null
	qdel(src)
	return 0

/obj/effect/ConveyorMove()
	procstart = null
	src.procstart = null
	return

/obj/effect/abstract/ex_act(severity, target)
	procstart = null
	src.procstart = null
	return

/obj/effect/abstract/singularity_pull()
	procstart = null
	src.procstart = null
	return

/obj/effect/abstract/singularity_act()
	procstart = null
	src.procstart = null
	return

/obj/effect/dummy/singularity_pull()
	procstart = null
	src.procstart = null
	return

/obj/effect/dummy/singularity_act()
	procstart = null
	src.procstart = null
	return
