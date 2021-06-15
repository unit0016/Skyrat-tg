/*----- Template for ruins, prevents needing to re-type the filepath prefix -----*/
/datum/map_template/ruin/space/skyrat/master
	prefix = "modular_skyrat/modules/mapping/_maps/RandomRuins/SpaceRuins/"
	suffix = "completelynormalspacetile.dmm"
	name = "Completely Normal Space Tile"
	id = "no_master"
	description = "A completely normal space tile, nothing strange with it at all."
	allow_duplicates = FALSE
	cost = 0
/*------*/

/datum/map_template/ruin/space/skyrat/master/syndicate
	name = "Syndicate Master Ruin"
	id = "syndie_master"
	description = "This ruin handles spawning Cybersun/Interdyne, and is otherwise just a fake space tile with atmos on it. Honk?"
	always_place = TRUE

/datum/map_template/ruin/space/skyrat/master/syndicate/New()
	var/chancetime = rand(1,2)
	switch(chancetime)
		if(1)
			always_spawn_with += /datum/map_template/ruin/space/skyrat/forgottenship
		if(2)
			always_spawn_with += /datum/map_template/ruin/lavaland/skyrat/syndicate_base
			always_spawn_with += /datum/map_template/ruin/icemoon/underground/skyrat/syndicate_base
	. = ..() //Calling parent here so chancetime is properly taken into account.
