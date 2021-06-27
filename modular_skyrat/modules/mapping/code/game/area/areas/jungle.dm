/area/jungle
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	sound_environment = SOUND_AREA_ASTEROID

/area/jungle/surface
	name = "Tunari"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_CREEPY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED | NO_ALERTS
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/jungle/surface/outdoors
	name = "Tunari Surface"
	outdoors = TRUE

/area/jungle/surface/outdoors/unexplored //ruins spawn here
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | NO_ALERTS
	map_generator = /datum/map_generator/jungle_generator

/area/jungle/surface/outdoors/unexplored/monsters //monsters and ruins spawn here
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | NO_ALERTS

/area/jungle/surface/outdoors/unexplored/monsters/megafauna //monsters and ruins spawn here
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS
