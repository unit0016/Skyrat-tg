// Used by /turf/open/chasm and subtypes to implement the "dropping" mechanic
/datum/component/chasm
	var/turf/target_turf
	var/fall_message = "GAH! Ah... where are you?"
	var/oblivion_message = "You stumble and stare into the abyss before you. It stares back, and you fall into the enveloping dark."

	var/static/list/falling_atoms = list() // Atoms currently falling into chasms
	var/static/list/forbidden_types = typecacheof(list(
		/obj/singularity,
		/obj/energy_ball,
		/obj/narsie,
		/obj/docking_port,
		/obj/structure/lattice,
		/obj/structure/stone_tile,
		/obj/projectile,
		/obj/effect/projectile,
		/obj/effect/portal,
		/obj/effect/abstract,
		/obj/effect/hotspot,
		/obj/effect/landmark,
		/obj/effect/temp_visual,
		/obj/effect/light_emitter/tendril,
		/obj/effect/collapse,
		/obj/effect/particle_effect/ion_trails,
		/obj/effect/dummy/phased_mob,
		/obj/effect/mapping_helpers
		))

/datum/component/chasm/Initialize(turf/target)
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, .proc/Entered)
	target_turf = target
	START_PROCESSING(SSobj, src) // process on create, in case stuff is still there

/datum/component/chasm/proc/Entered(datum/source, atom/movable/arrived, direction)
	SIGNAL_HANDLER

	START_PROCESSING(SSobj, src)
	drop_stuff(arrived)

/datum/component/chasm/process()
	if (!drop_stuff())
		STOP_PROCESSING(SSobj, src)

/datum/component/chasm/proc/is_safe()
	//if anything matching this typecache is found in the chasm, we don't drop things
	var/static/list/chasm_safeties_typecache = typecacheof(list(/obj/structure/lattice/catwalk, /obj/structure/stone_tile))

	var/atom/parent = src.parent
	var/list/found_safeties = typecache_filter_list(parent.contents, chasm_safeties_typecache)
	for(var/obj/structure/stone_tile/S in found_safeties)
		if(S.fallen)
			LAZYREMOVE(found_safeties, S)
	return LAZYLEN(found_safeties)

/datum/component/chasm/proc/drop_stuff(AM)
	. = 0
	if (is_safe())
		return FALSE

	var/atom/parent = src.parent
	var/to_check = AM ? list(AM) : parent.contents
	for (var/thing in to_check)
		if (droppable(thing))
			. = 1
			INVOKE_ASYNC(src, .proc/drop, thing)

/datum/component/chasm/proc/droppable(atom/movable/AM)
	// avoid an infinite loop, but allow falling a large distance
	if(falling_atoms[AM] && falling_atoms[AM] > 30)
		return FALSE
	if(!isliving(AM) && !isobj(AM))
		return FALSE
	if(is_type_in_typecache(AM, forbidden_types) || AM.throwing || (AM.movement_type & (FLOATING|FLYING)))
		return FALSE
	//Flies right over the chasm
	if(ismob(AM))
		var/mob/M = AM
		if(M.buckled) //middle statement to prevent infinite loops just in case!
			var/mob/buckled_to = M.buckled
			if((!ismob(M.buckled) || (buckled_to.buckled != M)) && !droppable(M.buckled))
				return FALSE
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(istype(H.belt, /obj/item/wormhole_jaunter))
				var/obj/item/wormhole_jaunter/J = H.belt
				//To freak out any bystanders
				H.visible_message(span_boldwarning("[H] falls into [parent]!"))
				J.chasm_react(H)
				return FALSE
	return TRUE

/datum/component/chasm/proc/drop(atom/movable/AM)
	//Make sure the item is still there after our sleep
	if(!AM || QDELETED(AM))
		return
	falling_atoms[AM] = (falling_atoms[AM] || 0) + 1
	var/turf/T = target_turf
//SKYRAT EDIT ADDITION//
	var/list/spawn_locs = null
	for(var/obj/effect/landmark/chasmfall/C in GLOB.landmarks_list) //The great cave offensive.
		spawn_locs += (C.loc)
	if(!spawn_locs.len)
		message_admins("ALERT; [AM] Entered a chasm, but no chasmfall landmarks exist! Sending to carpspawn...")
		for(var/obj/effect/landmark/carpspawn/C in GLOB.landmarks_list)
			spawn_locs += (C.loc)
		if(!spawn_locs.len)
			message_admins("RED ALERT! [AM] Entered a chasm, but no chasmfall or carp spawn landmarks exist! Yell at a mapper!")
//SKYRAT EDIT END//

	if(T)
		// send to the turf below
		AM.visible_message(span_boldwarning("[AM] falls into [parent]!"), span_userdanger("[fall_message]"))
		T.visible_message(span_boldwarning("[AM] falls from above!"))
		AM.forceMove(T)
		if(isliving(AM))
			var/mob/living/L = AM
			L.Paralyze(100)
			L.adjustBruteLoss(30)
		falling_atoms -= AM

	else
		// send to oblivion
		AM.visible_message(span_boldwarning("[AM] falls into [parent]!"), span_userdanger("[oblivion_message]"))
		if (isliving(AM))
			var/mob/living/L = AM
			L.notransform = TRUE
			L.Paralyze(20 SECONDS)

		var/oldtransform = AM.transform
		var/oldcolor = AM.color
		var/oldalpha = AM.alpha
		animate(AM, transform = matrix() - matrix(), alpha = 0, color = rgb(0, 0, 0), time = 10)
/* //SKYRAT EDIT REMOVAL START//
		for(var/i in 1 to 5)
			//Make sure the item is still there after our sleep
			if(!AM || QDELETED(AM))
				return
			AM.pixel_y--
			sleep(2)

		//Make sure the item is still there after our sleep
		if(!AM || QDELETED(AM))
			return

		if(iscyborg(AM))
			var/mob/living/silicon/robot/S = AM
			qdel(S.mmi)
		falling_atoms -= AM
		qdel(AM)
		if(AM && !QDELETED(AM)) //It's indestructible
			var/atom/parent = src.parent
			parent.visible_message(span_boldwarning("[parent] spits out [AM]!"))
*/ //Skyrat Edit Removal End//
		var/turf/wherewedropping = get_turf(pick(spawn_locs))
		wherewedropping.visible_message(span_boldwarning("[AM] suddenly appears in a flash of light!"))
		do_teleport(AM, wherewedropping, channel = TELEPORT_CHANNEL_QUANTUM)
		AM.alpha = oldalpha
		AM.color = oldcolor
		AM.transform = oldtransform
		falling_atoms -= AM
