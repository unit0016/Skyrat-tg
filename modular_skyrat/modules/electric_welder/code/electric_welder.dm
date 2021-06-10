/obj/item/weldingtool/electric
	name = "electrical welding tool"
	desc = "An experimental welding tool capable of welding functionality through the use of electricity. The flame seems almost cold."
	icon = 'modular_skyrat/modules/aesthetics/tools/tools.dmi'
	icon_state = "elwelder"
	inhand_icon_state = "elwelder"
	light_power = 1
	light_color = LIGHT_COLOR_HALOGEN
	tool_behaviour = NONE
	toolspeed = 0.2
	power_use_amount = POWER_CELL_USE_LOW
	var/cell_override = /obj/item/stock_parts/cell/high
	max_fuel = 20

/obj/item/weldingtool/electric/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/cell, cell_override, CALLBACK(src, .proc/switched_off))

/obj/item/weldingtool/electric/attack_self(mob/user, modifiers)
	. = ..()
	if(!welding)
		if(!(item_use_power(power_use_amount, user, TRUE) & COMPONENT_POWER_SUCCESS))
			return
	welding = !welding
	playsound(src, 'sound/effects/sparks4.ogg', 100, TRUE)
	if(welding)
		to_chat(user, "<span class='notice'>You turn [src] on.</span>")
		switched_on()
	else
		to_chat(user, "<span class='notice'>You turn [src] off.</span>")
		switched_off()

/obj/item/weldingtool/electric/switched_on(mob/user)
	welding = TRUE
	tool_behaviour = TOOL_WELDER
	light_on = TRUE
	force = 15
	damtype = BURN
	hitsound = 'sound/items/welder.ogg'
	set_light_on(welding)
	update_appearance()
	START_PROCESSING(SSobj, src)

/obj/item/weldingtool/electric/switched_off(mob/user)
	welding = FALSE
	light_on = FALSE
	force = initial(force)
	damtype = BRUTE
	set_light_on(welding)
	tool_behaviour = NONE
	update_appearance()
	STOP_PROCESSING(SSobj, src)

/obj/item/weldingtool/electric/process(delta_time)
	if(!welding)
		switched_off()
		return
	if(!(item_use_power(power_use_amount) & COMPONENT_POWER_SUCCESS))
		switched_off()
		return

// We don't need to know how much fuel it has, because it doesn't use any.
/obj/item/weldingtool/electric/examine(mob/user)
	. = ..()
	. -= "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."

// This is what uses fuel in the parent. We override it here to not use fuel
/obj/item/weldingtool/electric/use(used = 0)
	if(isOn())
		return TRUE
	else
		return FALSE

// This is what starts fires. Overriding it stops it starting fires
/obj/item/weldingtool/electric/handle_fuel_and_temps(used = 0, mob/living/user)
	return

/obj/item/weldingtool/electric/update_overlays()
	. = ..()
	if(welding)
		. += mutable_appearance('modular_skyrat/modules/aesthetics/tools/tools.dmi', "elwelder_on")

/obj/item/weldingtool/electric/examine()
	. = ..()
	. += "[src] is currently [welding ? "powered" : "unpowered"]."

/datum/design/exwelder
	name = "Electrical Welding Tool"
	desc = "An experimental welding tool capable of welding using electricity."
	id = "exwelder"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500, /datum/material/plasma = 1500, /datum/material/uranium = 200)
	build_path = /obj/item/weldingtool/electric
	category = list("Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
