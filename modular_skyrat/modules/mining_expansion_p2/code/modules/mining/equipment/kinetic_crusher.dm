/obj/item/crusher_trophy/brokentech
	name = "broken AI"
	desc = "It used to control a mecha, now it's just trash. Suitable as a trophy for a kinetic crusher."
	denied_type = /obj/item/crusher_trophy/brokentech
	icon = 'icons/obj/aicards.dmi'
	icon_state = "pai"
	var/range = 4
	var/cooldowntime = 50
	var/cooldown

/obj/item/crusher_trophy/brokentech/effect_desc()
	return "your kinetic crusher to create shockwaves when fired."

/obj/item/crusher_trophy/brokentech/on_projectile_fire(obj/projectile/destabilizer/marker, mob/living/user)
	. = ..()
	if(cooldowntime < world.time)
		INVOKE_ASYNC(src, .proc/invokesmoke, user)

/obj/item/crusher_trophy/brokentech/proc/invokesmoke(mob/living/user)
	cooldown = world.time + cooldowntime
	var/list/hit_things = list()
	var/turf/T = get_turf(get_step(user, user.dir))
	var/ogdir = user.dir
	for(var/i = 0, i < src.range, i++)
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/L in T.contents)
			if(L != user && !(L in hit_things) && !ishuman(L))
				if(!faction_check(user.faction, L.faction))
					if(prob(25))
						L.Stun(10)
					L.apply_damage_type(20, BRUTE)
		if(ismineralturf(T))
			var/turf/closed/mineral/M = T
			M.gets_drilled(user)
		T = get_step(T, ogdir)
		sleep(2)
