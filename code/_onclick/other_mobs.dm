/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)

	procstart = null
	src.procstart = null
	if(!has_active_hand()) //can't attack without a hand.
		to_chat(src, "<span class='notice'>You look at your arm and sigh.</span>")
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(proximity && istype(G) && G.Touch(A,1))
		return

	var/override = 0

	for(var/datum/mutation/human/HM in dna.mutations)
		override += HM.on_attack_hand(src, A, proximity)

	if(override)
		return

	SendSignal(COMSIG_HUMAN_MELEE_UNARMED_ATTACK, A)
	A.attack_hand(src)
	SendSignal(COMSIG_HUMAN_MELEE_UNARMED_ATTACKBY, src)

/atom/proc/attack_hand(mob/user)
	procstart = null
	src.procstart = null
	return

/atom/proc/interact(mob/user)
	procstart = null
	src.procstart = null
	return

/*
/mob/living/carbon/human/RestrainedClickOn(var/atom/A) ---carbons will handle this
	return
*/

/mob/living/carbon/RestrainedClickOn(atom/A)
	procstart = null
	src.procstart = null
	return 0

/mob/living/carbon/human/RangedAttack(atom/A, mouseparams)
	procstart = null
	src.procstart = null
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0)) // for magic gloves
			return

	for(var/datum/mutation/human/HM in dna.mutations)
		HM.on_ranged_attack(src, A, mouseparams)

	if(isturf(A) && get_dist(src,A) <= 1)
		src.Move_Pulled(A)

/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A)
	procstart = null
	src.procstart = null
	A.attack_animal(src)

/atom/proc/attack_animal(mob/user)
	procstart = null
	src.procstart = null
	return
/mob/living/RestrainedClickOn(atom/A)
	procstart = null
	src.procstart = null
	return

/*
	Monkeys
*/
/mob/living/carbon/monkey/UnarmedAttack(atom/A)
	procstart = null
	src.procstart = null
	A.attack_paw(src)
/atom/proc/attack_paw(mob/user)
	procstart = null
	src.procstart = null
	return

/*
	Monkey RestrainedClickOn() was apparently the
	one and only use of all of the restrained click code
	(except to stop you from doing things while handcuffed);
	moving it here instead of various hand_p's has simplified
	things considerably
*/
/mob/living/carbon/monkey/RestrainedClickOn(atom/A)
	procstart = null
	src.procstart = null
	if(..())
		return
	if(a_intent != INTENT_HARM || !ismob(A))
		return
	if(is_muzzled())
		return
	var/mob/living/carbon/ML = A
	if(istype(ML))
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/obj/item/bodypart/affecting = null
		if(ishuman(ML))
			var/mob/living/carbon/human/H = ML
			affecting = H.get_bodypart(ran_zone(dam_zone))
		var/armor = ML.run_armor_check(affecting, "melee")
		if(prob(75))
			ML.apply_damage(rand(1,3), BRUTE, affecting, armor)
			ML.visible_message("<span class='danger'>[name] bites [ML]!</span>", \
							"<span class='userdanger'>[name] bites [ML]!</span>")
			if(armor >= 2)
				return
			for(var/thing in viruses)
				var/datum/disease/D = thing
				ML.ForceContractDisease(D)
		else
			ML.visible_message("<span class='danger'>[src] has attempted to bite [ML]!</span>")

/*
	Aliens
	Defaults to same as monkey in most places
*/
/mob/living/carbon/alien/UnarmedAttack(atom/A)
	procstart = null
	src.procstart = null
	A.attack_alien(src)
/atom/proc/attack_alien(mob/living/carbon/alien/user)
	procstart = null
	src.procstart = null
	attack_paw(user)
	return
/mob/living/carbon/alien/RestrainedClickOn(atom/A)
	procstart = null
	src.procstart = null
	return

// Babby aliens
/mob/living/carbon/alien/larva/UnarmedAttack(atom/A)
	procstart = null
	src.procstart = null
	A.attack_larva(src)
/atom/proc/attack_larva(mob/user)
	procstart = null
	src.procstart = null
	return


/*
	Slimes
	Nothing happening here
*/
/mob/living/simple_animal/slime/UnarmedAttack(atom/A)
	procstart = null
	src.procstart = null
	A.attack_slime(src)
/atom/proc/attack_slime(mob/user)
	procstart = null
	src.procstart = null
	return
/mob/living/simple_animal/slime/RestrainedClickOn(atom/A)
	procstart = null
	src.procstart = null
	return


/*
	Drones
*/
/mob/living/simple_animal/drone/UnarmedAttack(atom/A)
	procstart = null
	src.procstart = null
	A.attack_drone(src)

/atom/proc/attack_drone(mob/living/simple_animal/drone/user)
	procstart = null
	src.procstart = null
	attack_hand(user) //defaults to attack_hand. Override it when you don't want drones to do same stuff as humans.

/mob/living/simple_animal/slime/RestrainedClickOn(atom/A)
	procstart = null
	src.procstart = null
	return


/*
	True Devil
*/

/mob/living/carbon/true_devil/UnarmedAttack(atom/A, proximity)
	procstart = null
	src.procstart = null
	A.attack_hand(src)

/*
	Brain
*/

/mob/living/brain/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return


/*
	pAI
*/

/mob/living/silicon/pai/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return


/*
	Simple animals
*/

/mob/living/simple_animal/UnarmedAttack(atom/A, proximity)
	procstart = null
	src.procstart = null
	if(!dextrous)
		return ..()
	if(!ismob(A))
		A.attack_hand(src)
		update_inv_hands()


/*
	Hostile animals
*/

/mob/living/simple_animal/hostile/UnarmedAttack(atom/A)
	procstart = null
	src.procstart = null
	target = A
	if(dextrous && !is_type_in_typecache(A, environment_target_typecache) && !ismob(A))
		..()
	else
		AttackingTarget()



/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/dead/new_player/ClickOn()
	procstart = null
	src.procstart = null
	return
